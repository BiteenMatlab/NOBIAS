function theta = NOBIAS_theta(theta,Suff_Stat, prior_params)
% Please refer to for derative of the E. B. Fox. Bayesian Nonparametric Learning of Complex Dynamical Phenomena. Ph.D. thesis,
% MIT, Cambridge, MA, 2009 for how the 2D gaussian is sampled

store_card = Suff_Stat.card;
nu = prior_params.nu;
nu_delta = prior_params.nu_delta;

YYt = Suff_Stat.YYt;
sumY = Suff_Stat.sumY;

N_cur = length(store_card);
K = prior_params.K;
M = prior_params.M;
MK = prior_params.M*prior_params.K;
MKM = MK*prior_params.M';
mu=theta.mu;
Sigma=theta.Sigma;
invSigma=theta.invSigma;
for n = 1: N_cur
    
    if store_card(n)>0
        %% Given X, Y get sufficient statistics   EBfox thesis 2.83-2.86
        Sxx       = store_card(n) + K;  % kappabar=kappa+N
        Syx       = sumY(:,n) + MK; % 2.84
        Syy       = YYt(:,:,n) + MKM;
        SyxSxxInv = Syx/Sxx;
        Sygx      = Syy - SyxSxxInv*Syx';
        Sygx = (Sygx + Sygx')/2;
        
    else
        Sxx = K;
        SyxSxxInv = M;
        Sygx = 0;
        
    end
    % Sample Sigma given s.stats
    try chol(Sygx + nu_delta);
    catch ME
        disp('Matrix is not symmetric positive definite')
    end
    [sqrtSigma,sqrtinvSigma] = randiwishart(Sygx + nu_delta,nu+store_card(n));
    invSigma(:,:,n) = sqrtinvSigma'*sqrtinvSigma;
    Sigma(:,:,n) = inv(invSigma(:,:,n));
    
    % Sample A given Sigma and s.stats
    cholinvSxx = chol(inv(Sxx));
    tempmu = SyxSxxInv(:);
    tempsqrtsigma = kron(cholinvSxx,sqrtSigma);
    S = tempmu + tempsqrtsigma'*randn(length(tempmu),1);
    S = reshape(S,size(SyxSxxInv));
    mu(:,n)=S;
    
    clear S tempmu tempsqrtsigma
end
theta.Sigma = Sigma;
theta.mu =  mu;
theta.invSigma=invSigma;

end