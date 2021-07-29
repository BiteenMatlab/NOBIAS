
function out = NOBIAS(data,varargin)
% data input: data: a strct, each element should have variable 
% obs a 2 by T tracks and a variable TrID that indicate track ID, see example data

%%%%
% Written by Ziyuan Chen at the University of Michigan last update
% 07/11/21 ZC
%
%     Copyright (C) 2021  Ziyuan Chen (ziyuanc@umich.edu)
%
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
%
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
%
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
dim=size(data(1).obs,1);

% Parameters
Params.dim=dim;
Params.Nmax=10;
Params.Niter=20000;
Params.SampleSaveFreq=10;
% Hyper hyperparameters are set within code
Params.gamma=0.1;
Params.alpha=1;
Params.kappa=20;  % the sticky parameter
Params.DispFreq=5000;


% prior parameter for the NIW sampling
Params.M  = zeros([dim 1]);
Params.K = 0.1;  % NIW(kappa,theta,delta,nu_delta); K is kappa
Params.nu = dim+2;  % d+2
Params.nu_delta= eye(dim); %(nu-d-1) * diag(d)

Params.MotionBlur=1; %whether to do the motion blur correction, need data to have corr_obs
Params.frametime=0.04; %s
Params.pixelsize=0.049; %um
Params.Plot=1;



fNames=fieldnames(Params);
if nargin>1&&rem(nargin,2)==1
    for ii=1:2:nargin-1
        whichField = strcmp(fNames,varargin{ii});
        if all(~whichField)
            warning(['Check spelling. ', ...
                'Parameter change may have not occurred'])
        end
        eval([fNames{whichField} ' = varargin{ii+1};'])
        eval(['Params.' fNames{whichField} ' = ' fNames{whichField},';'])
    end
elseif nargin>1
    warning('use paired inputs')
    return
end

% test the existence of the light speed toolbox
try
   x = randgamma(1);
catch ME
    error('Please Makse Sure the light speed toolbox is put in path, avaialble on https://github.com/tminka/lightspeed')
end
clear x


Nmax=Params.Nmax;
Niter=Params.Niter;
SampleSaveFreq=Params.SampleSaveFreq;
Allmean=cell(Niter/SampleSaveFreq,1);
Allsigma=cell(Niter/SampleSaveFreq,1);
AllWeight=cell(Niter/SampleSaveFreq,1);
AllTran=cell(Niter/SampleSaveFreq,1);
AllPi_init=cell(Niter/SampleSaveFreq,1);
AllBeta_vec=cell(Niter/SampleSaveFreq,1);
% initilize the parameter space
[theta, Suff_Stat , stateCounts , hyperparams, prior_params] = NOBIAS_init(Params);

% sample transition
trans_struct = NOBIAS_sample_trans(stateCounts,hyperparams);

% sample the parameter space
% by default used a NIW prior
theta = NOBIAS_theta(theta,Suff_Stat,Params);
L=zeros(1,Niter);
for n=1:Niter
    % Block sample (z_{1:T})|y_{1:T}
    [stateSeq, State_inds, stateCounts] = NOBIAS_sampleseq(data,trans_struct,theta);
    % Create sufficient statistics:
    Suff_Stat = NOBIAS_Suffstats(data,State_inds,stateCounts.N);
    % Based on mode sequence assignment, sample how many tables in each
    % restaurant are serving each of the selected dishes. Also sample the
    % dish override variables:
    stateCounts =  NOBIAS_auxiliary_m(stateCounts, hyperparams, trans_struct.beta_vec, size(stateCounts.N,2));
    % update the transition matrix, parameter and hyperparameter
    trans_struct = NOBIAS_sample_trans(stateCounts,hyperparams);
    theta = NOBIAS_theta(theta,Suff_Stat,prior_params);
    % hyperparameters can be resampled if found needed
    %     hyperparams = NOBIAS_resamplehyper(stateCounts,hyperhyperparams,hyperparams);
    
    L(n)=length(unique(extractfield(stateSeq,'z')));
    if rem(n,Params.DispFreq)==0
        fprintf('Current state number L= %d\n',L(n))
    end
    if rem(n,SampleSaveFreq)==0
        Allmean{n/SampleSaveFreq}=theta.mu;
        
        Allsigma{n/SampleSaveFreq}=theta.Sigma;
        tempweight=zeros(1,Nmax);
        for state = 1:Nmax
            tempweight(state)= sum(extractfield(stateSeq,'z')==state);
        end
        AllWeight{n/SampleSaveFreq}=tempweight/sum(tempweight);
        AllTran{n/SampleSaveFreq}=trans_struct.Trans;
        AllPi_init{n/SampleSaveFreq}=trans_struct.pi_init;
        AllBeta_vec{n/SampleSaveFreq}=trans_struct.beta_vec;
    end
end

out.theta.mu=Allmean;
out.theta.Sigma=Allsigma;
out.theta.Weight=AllWeight;

out.trans_struct.Trans=AllTran;
out.trans_struct.pi_init=AllPi_init;
out.trans_struct.beta_vec=AllBeta_vec;
out.stateSeq=extractfield(stateSeq,'z');
out.hyperparams=hyperparams;
out.L=L;
out.SampleSaveFreq=SampleSaveFreq;
Results=NOBIAS_plot(out,data,Params);
out.Results=Results;

end
