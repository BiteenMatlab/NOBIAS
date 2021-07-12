function  Suff_Stat = NOBIAS_Suffstats(data,State_inds,N)

Nmax = size(N,2);

unique_z = find(sum(N,1));

dimu = size(data(1).obs,1);

YYt = zeros(dimu,dimu,Nmax);
store_sumY = zeros(dimu,Nmax);
for ii=1:length(data)
    
    u = data(ii).obs;
    
    for n=unique_z
            obsInd = State_inds(ii).obsIndzs(n).inds(1:State_inds(ii).obsIndzs(n).tot);
            YYt(:,:,n) = YYt(:,:,n) + u(:,obsInd)*u(:,obsInd)';
            store_sumY(:,n) = store_sumY(:,n) + sum(u(:,obsInd),2);   
    end
end

Suff_Stat.card = sum(N,1);
Suff_Stat.YYt = YYt;
Suff_Stat.sumY = store_sumY;
end