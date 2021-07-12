function AllSigma=NOBIAS_acf(out)
% notice please change the SampleSaveFreq to 1 when want to do acf analysis
Niter=length(out.L);
SampleSaveFreq=1;
state_num=mode(out.L(end-5000:end));
burn=1000;
used_state=unique(out.stateSeq);
savd_L=out.L(rem(1:Niter,SampleSaveFreq)==0);
Sampled_sigma=out.theta.Sigma(savd_L==state_num);
Sampled_sigma=Sampled_sigma(burn+1:end);
AllSigma=zeros(length(Sampled_sigma),length(used_state));
for i=1:length(Sampled_sigma)
    tempSig=Sampled_sigma{i};
    AllSigma(i,:)=tempSig(1,1,used_state);
end
%
% for j=1:length(used_state)
%      autocorr(AllSigma(:,j),'NumLags',10);
% end
end