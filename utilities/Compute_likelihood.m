function [likelihood,normalizer] = Compute_likelihood(data_struct,theta,N_cur)
% adpated from the compute_likehood from the Emily B. Fox HDPHMM_HDPSLDS
% toolbox
invSigma = theta.invSigma;
mu = theta.mu;

T = size(data_struct.obs,2);
dimu = size(data_struct.obs,1);

log_likelihood = zeros(N_cur,1,T);
for n=1:N_cur
    
    cholinvSigma = chol(invSigma(:,:,n,1));
    dcholinvSigma = diag(cholinvSigma);
    
    u = cholinvSigma*(data_struct.obs - mu(:,n*ones(1,T),1));
    
    log_likelihood(n,1,:) = -0.5*sum(u.^2,1) + sum(log(dcholinvSigma));
    
end
normalizer = max(max(log_likelihood,[],1),[],2);
log_likelihood = log_likelihood - normalizer(ones(N_cur,1),1,:);
likelihood = exp(log_likelihood);

normalizer = normalizer - (dimu/2)*log(2*pi);
end
