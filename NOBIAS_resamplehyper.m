function hyperparams = NOBIAS_resamplehyper(stateCounts,hyperparams)
% the resample of the hyperparameter is adapted from the E. B. Foc thesis
% appendix C, and the HDP-HMM toolbox from the Fox lab. 
% see also Teh, et al, 2006 the HDPHMM paper for derivation


% one key trick to resample the hyperparameter is using the auxiliary
% variable alpha+kappa and rho, as they work identically and have better
% difined distribution
alpha0 = hyperparams.alpha0;
kappa0 = hyperparams.kappa0;
gamma0 = hyperparams.gamma0;
rho0 = kappa0/(alpha0+kappa0);
alpha0_p_kappa0 = alpha0+kappa0;

% for simplicity always set alpha of prior for hyperparameters to 1
a_alpha=1; b_alpha = 1/alpha0_p_kappa0;
a_gamma=1; b_gamma= 1/gamma0;
% for rho always set d=1
c=rho0; d=1;

N = stateCounts.N; % N(i,j) = # z_t = i to z_{t+1}=j transitions in z_{1:T}. N(Kz+1,i) = 1 for i=z_1.
M = stateCounts.M; % M(i,j) = # of tables in restaurant i serving dish k
barM = stateCounts.barM; % barM(i,j) = # of tables in restaurant i considering dish k
sum_w = stateCounts.sum_w; % sum_w(i) = # of overriden dish assignments in restaurant i

Nkdot = sum(N,2);
Mkdot = sum(M,2);
barK = length(find(sum(barM,1)>0));
validindices = find(Nkdot>0);


gamma0 = hyperparams.gamma0;

% Resample concentration parameters:
% the gibbs_conparam.m is acquired from the HDPHMM toolbox from Fox lab
if isempty(validindices)
    alpha0_p_kappa0 = randgamma(a_alpha) / b_alpha;    % Gj concentration parameter
    gamma0 = randgamma(a_gamma) / b_gamma;    % G0 concentration parameter
else
    alpha0_p_kappa0  = gibbs_conparam(alpha0_p_kappa0, Nkdot(validindices),Mkdot(validindices),a_alpha,b_alpha,50);
    gamma0 = gibbs_conparam(gamma0,sum(sum(barM)),barK,a_gamma,b_gamma,50);
end

hyperparams.gamma0 = gamma0;
rho0 = betarnd(c+sum(sum_w),d+(sum(sum(M))-sum(sum_w)));

hyperparams.alpha0=alpha0_p_kappa0*(1-rho0);
hyperparams.kappa0=alpha0_p_kappa0*rho0;

end