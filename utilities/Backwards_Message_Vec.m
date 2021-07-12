
function [bwds_msg, partial_marg] = Backwards_Message_Vec(likelihood,blockEnd,Trans)
% adpated from the compute_likehood from the Emily B. Fox HDPHMM_HDPSLDS
% toolbox

% Allocate storage space
Nmax = size(Trans,2);
T  = length(blockEnd);

bwds_msg     = ones(Nmax,T);
partial_marg = zeros(Nmax,T);

% Compute marginalized likelihoods for all times, integrating s_t
if Nmax==1
    marg_like = squeeze(likelihood)';
else
    marg_like = squeeze(sum(likelihood,2));
end

% If necessary, combine likelihoods within blocks, avoiding underflow
if T < blockEnd(end)
  marg_like = log(marg_like+eps);

  block_like = zeros(Nmax,T);
  block_like(:,1) = sum(marg_like(:,1:blockEnd(1)),2);
  for tt = 2:T
    block_like(:,tt) = sum(marg_like(:,blockEnd(tt-1)+1:blockEnd(tt)),2);
  end

  block_norm = max(block_like,[],1);
  block_like = exp(block_like - block_norm(ones(Nmax,1),:));
else
  block_like = marg_like;
end

% Compute messages backwards in time
for tt = T-1:-1:1
  % Multiply likelihood by incoming message:
  partial_marg(:,tt+1) = block_like(:,tt+1) .* bwds_msg(:,tt+1);
  
  % Integrate out z_t:
  bwds_msg(:,tt) = Trans * partial_marg(:,tt+1);
  bwds_msg(:,tt) = bwds_msg(:,tt) / sum(bwds_msg(:,tt));
end

% Compute marginal for first time point
partial_marg(:,1) = block_like(:,1) .* bwds_msg(:,1);

