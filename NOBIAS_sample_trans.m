
function trans_struct = NOBIAS_sample_trans(stateCounts,hyperparams)

alpha0 = hyperparams.alpha0;
kappa0 = hyperparams.kappa0;
gamma0 = hyperparams.gamma0;

N = stateCounts.N;  % N(i,j) = # z_t = i to z_{t+1}=j transitions. N(Kz+1,i) = 1 for i=z_1.

N_cur=size(N,2);

barM = stateCounts.barM;  % barM(i,j) = # tables in restaurant i that considered dish j

beta_vec = randdirichlet((sum(barM,1) + gamma0/N_cur)')';

%sapmle the transition matrix
Trans = zeros(N_cur,N_cur);
for j=1:N_cur
    kappa_vec = zeros(1,N_cur);
    % Add an amount \kappa to Dirichlet parameter corresponding to a
    % self-transition:
    kappa_vec(j) = kappa0;
    % Sample \pi_j's given sampled \beta_vec and counts N, where
    % DP(\alpha+\kappa,(\alpha\beta+\kappa\delta(j))/(\alpha+\kappa)) is
    % Dirichlet distributed over the finite partition defined by beta_vec:
    % LightSpeed toolbox used
    Trans(j,:) = randdirichlet([alpha0*beta_vec + kappa_vec + N(j,:)]')';
end
pi_init = randdirichlet([alpha0*beta_vec + N(N_cur+1,:)]')';

trans_struct.Trans = Trans;
trans_struct.pi_init = pi_init;
trans_struct.beta_vec = beta_vec;

end