function [SQ,acc]=NOBIAS_out_acc(TrueLabel, out)
% get the out sequence with the D acending order and get the accuracy
Niter=length(out.L);
SampleSaveFreq=10;
savd_L=out.L(rem(1:Niter,SampleSaveFreq)==0);
state_num=mode(out.L(end-5000:end));
Sampled_sigma=out.theta.Sigma(savd_L==state_num);

used_state=unique(out.stateSeq);
[~, L_Ranked]=sort(Sampled_sigma{end}(1,1,used_state),'ascend');
used_state=used_state(L_Ranked);

SQ=out.stateSeq;
for i=1:length(used_state)
    SQ(SQ==used_state(i))=i+10;
end
SQ=SQ-10;
acc=sum(TrueLabel==SQ)/size(SQ,2);

end