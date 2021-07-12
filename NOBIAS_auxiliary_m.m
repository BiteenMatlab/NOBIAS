function stateCounts =  NOBIAS_auxiliary_m(stateCounts, hyperparams, beta_vec, Nmax)

% allocate hyperparameter
alpha0 = hyperparams.alpha0;
kappa0 = hyperparams.kappa0;
rho0 = kappa0/(alpha0+kappa0);

N = stateCounts.N;
% the calculation of the auxiliary variable m should refer to E. B. Fox et al 2010, or see algorithm
% 9 of E. B. Fox thesis step 3,
M = zeros(Nmax+1,Nmax);
auxiliary_alpha=[alpha0*beta_vec(ones(1,Nmax),:)+kappa0*eye(Nmax); alpha0*beta_vec];
for ii=1:numel(M)
    M(ii)=1+sum(rand(1,N(ii)-1)<ones(1,N(ii)-1)*auxiliary_alpha(ii)./(auxiliary_alpha(ii)+(1:(N(ii)-1)))); 
end
M(N==0) = 0;

barM = M;
sum_w = zeros(size(M,2),1);
% see E. B. Fox thesis appendix A.1.3 for detailed explaination of bar_m and w
for j=1:size(M,2)
    if rho0>0
        p = rho0/(beta_vec(j)*(1-rho0) + rho0);
    else
        p = 0;
    end
    sum_w(j) = randbinom(p,M(j,j));
    barM(j,j) = M(j,j) - sum_w(j);
end

stateCounts.M = M;
stateCounts.barM = barM;
stateCounts.sum_w = sum_w;


end