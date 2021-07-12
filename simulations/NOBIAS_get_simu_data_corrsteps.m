function data = NOBIAS_get_simu_data_corrsteps(data)

obs=data.obs;
TrID=data.TrID;

obs_corr=zeros(size(obs));

for i=1:length(unique(TrID))
    curobs=obs(:,TrID==i);
    obs_corr(:,TrID==i)=[curobs(:,1:end-1).*curobs(:,2:end), [nan;nan]];
end
data.obs_corr=obs_corr;
end