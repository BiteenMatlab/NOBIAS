function [stateSeq, State_inds, stateCounts] = NOBIAS_sampleseq(data,trans_struct,theta)
% Define parameters:
Trans = trans_struct.Trans;  % transition distributions with pi_z(i,j) the probability of going from i->j
pi_init = trans_struct.pi_init;  % initial distribution on z_1

N_max = size(Trans,2);  % truncation level for transition distributions

N = zeros(N_max+1,N_max);  % blank counting matrix


%% the block sampler majorly based on the E. B. Fox code and thesis
for ii = 1:length(data)
    T = length(data(ii).obs);
    % Initialize state sequence structure:
    State_inds(ii).obsIndzs(1:N_max) = struct('inds',sparse(1,T),'tot',0);
    stateSeq(ii) = struct('z',zeros(1,T));
    TrID=data(ii).TrID;
    z = zeros(1,T);
    
    likelihood = Compute_likelihood(data(ii),theta,N_max);
    
    % Compute backwards messages:
    [~, partial_marg] = Backwards_Message_Vec(likelihood, [1:T], Trans);
    totSeq = zeros(N_max,1);
    indSeq = zeros(T,N_max);
    % sample the state
    Pz = pi_init' .* partial_marg(:,1);
    Pz   = cumsum(Pz);
    z(1) = 1 + sum(Pz(end)*rand(1) > Pz);
    N(N_max+1,z(1)) = N(N_max+1,z(1)) + 1;% Store initial point in "root" restaurant Kz+1
    for t=2:T
        % Sample z(t):
        if (TrID(t)~=TrID(t-1))
            Pz = pi_init' .* partial_marg(:,t);
        else
            Pz = Trans(z(t-1),:)' .* partial_marg(:,t);
        end
        Pz   = cumsum(Pz);
        z(t) = 1 + sum(Pz(end)*rand(1) > Pz);
        
        % Add state to counts matrix:
        if TrID(t)==TrID(t-1)
            N(z(t-1),z(t)) = N(z(t-1),z(t)) + 1;
        else
            N(N_max+1,z(t)) = N(N_max+1,z(t)) + 1;  %No need to save all the initial point in all tracks?
        end
        totSeq(z(t)) = totSeq(z(t)) + 1;
        indSeq(totSeq(z(t)),z(t)) = t;
    end
    
    
    stateSeq(ii).z = z;
end
for jj = 1:N_max
    State_inds(ii).obsIndzs(jj).tot  = totSeq(jj);
    State_inds(ii).obsIndzs(jj).inds = sparse(indSeq(:,jj)');
end

stateCounts.N=N;
end
