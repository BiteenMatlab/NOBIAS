function data = NOBIAS_step_simu_blur(N,L,Aver_seq)

L=L+1;% one more point in track compare with wanted steps
sigma=zeros(2,2,4);
mu1=[0,0]; sigma(:,:,1)=[0.2,0;0,0.2];
mu2=[0,0]; sigma(:,:,2)=[2,0;0,2];
mu3=[0,0]; sigma(:,:,3)=[12,0;0,12];
mu4=[0,0]; sigma(:,:,4)=[50,0;0,50];
mu=[mu1;mu2;mu3;mu4];

% sigma=zeros(2,2,3);
% mu1=[0,0]; sigma(:,:,1)=[0.5,0;0,0.5];
% mu2=[0,0]; sigma(:,:,2)=[5,0;0,5];
% mu3=[0,0]; sigma(:,:,3)=[50,0;0,50];
% mu=[mu1;mu2;mu3];
sigma=sigma*3/2/Aver_seq;
mu=mu/Aver_seq;
errsigma=[0.167,0;0,0.167];
Statelabel=zeros(N,L*Aver_seq);
MeanStateLabel=zeros(N,L);
steps=zeros(N,L*Aver_seq,2);
Tracks_mean=zeros(N,L,2);

Transmat = [0.99 0.004 0.003 0.003;
    0.01 0.98 0.005 0.005;
    0.005 0.005 0.98 0.01;
    0.003 0.003 0.004 0.99];
% Transmat = [0.95 0.02 0.015 0.015;
%     0.05 0.9 0.025 0.025;
%     0.025 0.025 0.9 0.05;
%     0.015 0.015 0.02 0.95];
% Transmat = [0.99 0.005 0.005;
%     0.01 0.98 0.01;
%     0.005 0.005 0.99];


for i=1:N
      Statelabel(i,1)= datasample(1:4,1,'Weights',[0.25,0.25,0.25,0.25]);
%     Statelabel(i,1)= datasample(1:3,1,'Weights',[0.33,0.34,0.33]);

    for j=2:Aver_seq*L
        Statelabel(i,j) = datasample(1:4,1,'Weights',Transmat(Statelabel(i,j-1),:));
    end
    [Tempnonrepseq , TempSeqLen]= GetUniqueSeq(Statelabel(i,:), ones(L*Aver_seq,1));
    Mark=[0, cumsum(TempSeqLen)];
    temperr=mvnrnd([0,0],errsigma,L);
    for k=1:length(Tempnonrepseq)
        tempsteps=mvnrnd(mu(Tempnonrepseq(k),:),sigma(:,:,Tempnonrepseq(k)),TempSeqLen(k));
        
        steps(i,Mark(k)+1:Mark(k+1),1)=tempsteps(:,1);
        steps(i,Mark(k)+1:Mark(k+1),2)=tempsteps(:,2);
    end
    temptrawtracks=[cumsum(steps(i,:,1)); cumsum(steps(i,:,2))];
    for jj=1:L
        Tracks_mean(i,jj,1)=mean(temptrawtracks(1,(jj-1)*Aver_seq+1:jj*Aver_seq));
        Tracks_mean(i,jj,2)=mean(temptrawtracks(2,(jj-1)*Aver_seq+1:jj*Aver_seq));
        MeanStateLabel(i,jj)=ceil(median(Statelabel(i,(jj-1)*Aver_seq+1:jj*Aver_seq)));
    end
    Tracks_mean(i,:,1)=Tracks_mean(i,:,1)+temperr(:,1)';
    Tracks_mean(i,:,2)=Tracks_mean(i,:,2)+temperr(:,2)';
end
L_step=L-1; % step is one less than points

obs_mean=zeros(2,N*L_step);
TrID=zeros(N*L_step,1);
for i=1:N
    tempstep=[Tracks_mean(i,2:end,1)-Tracks_mean(i,1:end-1,1);Tracks_mean(i,2:end,2)-Tracks_mean(i,1:end-1,2)];
    obs_mean(:,L_step*i-(L_step-1):L_step*i)=tempstep;
    TrID(L_step*i-(L_step-1):L_step*i)=i;
end
MeanStateLabel=MeanStateLabel(:,2:end); %actual label start from 2nd step 
data.obs=obs_mean;
data.TrID=TrID;
data.Truetrans=Transmat;
data.TrueMu=mu*Aver_seq;
data.TrueSigma=sigma*Aver_seq;
data.tracks=Tracks_mean;
data.truelabel=reshape(MeanStateLabel',1,[]);
data.alllabel=reshape(Statelabel',1,[]);
data = NOBIAS_get_simu_data_corrsteps(data);
end