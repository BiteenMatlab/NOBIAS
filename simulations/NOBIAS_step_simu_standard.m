function data = NOBIAS_step_simu_standard(N,L)
% you can also set averblur to 1 in the step_simu_blur code
L=L+1;% one more point in track compare with wanted steps
% sigma=zeros(2,2,4);
% mu1=[0,0]; sigma(:,:,1)=[0.2,0;0,0.2];
% mu2=[0,0]; sigma(:,:,2)=[2,0;0,2];
% mu3=[0,0]; sigma(:,:,3)=[12,0;0,12];
% mu4=[0,0]; sigma(:,:,4)=[50,0;0,50];
% mu=[mu1;mu2;mu3;mu4];

sigma=zeros(2,2,3);
mu1=[0,0]; sigma(:,:,1)=[0.5,0;0,0.5];
mu2=[0,0]; sigma(:,:,2)=[5,0;0,5];
mu3=[0,0]; sigma(:,:,3)=[50,0;0,50];
mu=[mu1;mu2;mu3];
Statelabel=zeros(N,L);
steps=zeros(N,L,2);
Tracks=zeros(N,L,2);

% Transmat = [0.9 0.04 0.03 0.03;
%     0.1 0.8 0.05 0.05;
%     0.05 0.05 0.8 0.1;
%     0.03 0.03 0.04 0.9];
Transmat = [0.99 0.005 0.005;
    0.01 0.98 0.01;
    0.005 0.005 0.99];


for i=1:N
%         Statelabel(i,1)= datasample(1:4,1,'Weights',[0.25,0.25,0.25,0.25]);
    Statelabel(i,1)= datasample(1:3,1,'Weights',[0.33,0.34,0.33]);

    for j=2:L
        Statelabel(i,j) = datasample(1:3,1,'Weights',Transmat(Statelabel(i,j-1),:));
    end
    [Tempnonrepseq , TempSeqLen]= GetUniqueSeq(Statelabel(i,:), ones(L,1));
    Mark=[0, cumsum(TempSeqLen)];
    for k=1:length(Tempnonrepseq)
        tempsteps=mvnrnd(mu(Tempnonrepseq(k),:),sigma(:,:,Tempnonrepseq(k)),TempSeqLen(k));
        
        steps(i,Mark(k)+1:Mark(k+1),1)=tempsteps(:,1);
        steps(i,Mark(k)+1:Mark(k+1),2)=tempsteps(:,2);
    end
    
    Tracks(i,:,1)=cumsum(steps(i,:,1));
    Tracks(i,:,2)=cumsum(steps(i,:,2));
end
L_step=L-1; % step is one less than points
Statelabel=Statelabel(:,2:end);
obs=zeros(2,N*L_step);
TrID=zeros(N*L_step,1);
for i=1:N
        obs(:,L_step*i-(L_step-1):L_step*i)=[Tracks(i,2:end,1)-Tracks(i,1:end-1,1);Tracks(i,2:end,2)-Tracks(i,1:end-1,2)];
        TrID(L_step*i-(L_step-1):L_step*i)=i;
end
data.obs=obs;
data.TrID=TrID;
data.Truetrans=Transmat;
data.TrueMu=mu;
data.TrueSigma=sigma;
data.tracks=Tracks;
data.truelabel=reshape(Statelabel',1,[]);

end