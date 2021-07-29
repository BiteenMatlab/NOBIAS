function Results=NOBIAS_plot(out,data, Params)
Niter=length(out.L);
if nargin<3
    Params.frametime=0.04; %s
    Params.pixelsize=0.049; %um
    Params.Plot=1;
    Params.MotionBlur=1;%whether to do the motion blur correction, need data to have corr_obs
    Params.SampleSaveFreq=10;
end
SampleSaveFreq=Params.SampleSaveFreq;
c=colormap('lines');

state_num=mode(out.L(end-5000:end));
burn=1000;

used_state=unique(out.stateSeq);
savd_L=out.L(rem(1:Niter,SampleSaveFreq)==0);
Sampled_sigma=out.theta.Sigma(savd_L==state_num);
Sampled_sigma=Sampled_sigma(burn+1:end);
Sampled_weight=out.theta.Weight(savd_L==state_num);
Sampled_weight=Sampled_weight(burn+1:end);
Sampled_Trans=out.trans_struct.Trans(savd_L==state_num);
Sampled_Trans=Sampled_Trans(burn+1:end);
[~, L_Ranked]=sort(Sampled_sigma{end}(1,1,used_state),'ascend');
used_state=used_state(L_Ranked);

% whether to calculate the diffusion coefficents for both directions
asymeteric=0;
frametime=Params.frametime; %s
pixelsize=Params.pixelsize; %um

if Params.MotionBlur
    Corrsteps=data.obs_corr;
    corrMu=zeros(2,length(used_state));
    for ii=1:length(used_state)
        cur_corrsteps=Corrsteps(:,out.stateSeq==used_state(ii));
        corrMu(:,ii)=mean(cur_corrsteps,2,'omitnan');
    end
    corrMu_mean=mean(corrMu,1);
end
Allweight=zeros(length(Sampled_weight),length(used_state));
AllTran=zeros(length(Sampled_weight),length(used_state),length(used_state));
if ~asymeteric
    AllSigma=zeros(length(Sampled_weight),length(used_state));
    AllD=zeros(length(Sampled_weight),length(used_state));
    
    for i=1:length(Sampled_weight)
        tempSig=Sampled_sigma{i};
        Allweight(i,:)=Sampled_weight{i}(used_state);
        AllTran(i,:,:)=Sampled_Trans{i}(used_state,used_state);
        AllSigma(i,:)=(tempSig(1,1,used_state)+tempSig(2,2,used_state))/2;
        if Params.MotionBlur
            AllD(i,:)=(AllSigma(i,:) + 2*corrMu_mean)/2/frametime*pixelsize*pixelsize;
        else
            AllD(i,:)=AllSigma(i,:)/2/frametime*pixelsize*pixelsize;
        end
    end
else
    AllSigma=zeros(length(Sampled_weight),length(used_state),2);
    AllD=zeros(length(Sampled_weight),length(used_state),2);
    
    for i=1:length(Sampled_weight)
        tempSig=Sampled_sigma{i};
        Allweight(i,:)=Sampled_weight{i}(used_state);
        AllTran(i,:,:)=Sampled_Trans{i}(used_state,used_state);
        AllSigma(i,:,1)=tempSig(1,1,used_state);
        AllSigma(i,:,2)=tempSig(2,2,used_state);
        if Params.MotionBlur
            AllD(i,:,1)=(AllSigma(i,:,1) + 2*corrMu(1,:))/2/frametime*pixelsize*pixelsize;
            AllD(i,:,2)=(AllSigma(i,:,2) + 2*corrMu(2,:))/2/frametime*pixelsize*pixelsize;
        else
            AllD(i,:,1)=AllSigma(i,:,1)/2/frametime*pixelsize*pixelsize;
            AllD(i,:,2)=AllSigma(i,:,2)/2/frametime*pixelsize*pixelsize;
        end

    end
end
if Params.Plot
    plot(out.L);
    title('state number convergence')
    xlabel('iterations');
    ylabel('state number')
    ylim([1 10])
    figure
    hold on
    if ~asymeteric
    for j=1:length(used_state)
        scatter(Allweight(:,j),AllD(:,j),7,c(j,:),'filled');
    end
    else
        for j=1:length(used_state)
            scatter(Allweight(:,j),AllD(:,j,1),7,c(j,:),'filled');
            scatter(Allweight(:,j),AllD(:,j,2),7,c(j,:),'filled');
        end
    end
    set(gca,'yscale','log')
    axis tight
    xlim([0 1]);
    ylim([0.005,5]);
    ylabel('Diffusion coefficients, um2/s')
    xlabel('Weight Fraction')
    hold off
end
Results.AllD=AllD;
Results.Allweight=Allweight;
Results.AllTran=AllTran;
Results.D=mean(AllD,1);
Results.Weight=mean(Allweight);
Results.Trans=squeeze(mean(AllTran,1));

end