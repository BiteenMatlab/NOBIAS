function Model_Prob = NOBIAS_difmodel_plot(state_predict, out)

% input: state_predict: the output from the 'predict_state_model.m'
% function; out: the output from NOBIAS HDPHMM
% output: normalized probability weighted by length for each state
Niter=length(out.L);
SampleSaveFreq=10;% to do SampleSaveFreq=out.SampleSaveFreq;
savd_L=out.L(rem(1:Niter,SampleSaveFreq)==0);
state_num=mode(out.L(end-5000:end));
Sampled_sigma=out.theta.Sigma(savd_L==state_num);

used_state=unique(out.stateSeq);
[~, L_Ranked]=sort(Sampled_sigma{end}(1,1,used_state),'ascend');
used_state=used_state(L_Ranked);
Model_Prob=zeros(state_num, size(state_predict.model,2));
labels = {'BM','FBM','CTRW','LW'};

for i=1:state_num
    cur_state_ID=    state_predict.state==used_state(i);
    temp_state_cumprob=sum(double(state_predict.model(cur_state_ID,:)).*state_predict.length(cur_state_ID)',1);
    Model_Prob(i,:)=temp_state_cumprob/sum(temp_state_cumprob);
%     figure;
%     pie(Model_Prob(i,:),labels); title(['State ',num2str(i),' diffusion type'])
end
end