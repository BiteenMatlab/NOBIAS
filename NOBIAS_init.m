function [theta, Suff_Stat , stateCounts , hyperparams , prior_params] = NOBIAS_init(Params)

Nmax = Params.Nmax;
dimu=Params.dim;

%parameters
theta = struct('Sigma',zeros(dimu,dimu,Nmax),'mu',zeros(dimu,Nmax),'invSigma',zeros(dimu,dimu,Nmax));

% sufficient statistics
Suff_Stat = struct('card',zeros(Nmax,1),'YYt',zeros(dimu,dimu,Nmax),'sumY',zeros(dimu,Nmax));

% set up structure of the state count
stateCounts.N = zeros(Nmax+1,Nmax);
stateCounts.M = zeros(Nmax+1,Nmax);
stateCounts.barM = zeros(Nmax+1,Nmax);
stateCounts.sum_w = zeros(1,Nmax);


% Resample concentration parameters:
hyperparams.gamma0 = Params.gamma;
hyperparams.alpha0 = Params.alpha; 
hyperparams.kappa0 = Params.kappa;



prior_params.M  = Params.M;
prior_params.K = Params.K;
prior_params.nu = Params.nu;
prior_params.nu_delta= Params.nu_delta;

end