% NOBIAS running code

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To do simulations

% change input sigma and transmat accoring to need in codes

% 
% data = NOBIAS_step_simu_standard(N,L); Standard dataset
% data = NOBIAS_step_simu_blur(N,L,Aver_seq); motion blur dataset
% 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% experimental data
% input All tracks is a N by 1 cell array, where each element of the cell
% array is a tracectories with at least 4 colmns, where the 2nd columns
% should correspond to the frame of the tracks (gaps are allowed and 
% should be pre-filtered in tracking step to avoid too huge gaps), the 3rd
% and 4th columns should be the rows and columns of the 2D tracks
% coordinates, pay attention to x-y and row-col difference.
% 
% data = NOBIAS_preparedata(AllTracks);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% the HDP-HMM module
% out = NOBIAS(data);% change parameters according to needs


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RNN module, first load the pre-trained network
% load('net.mat') 
% 
% state_model=predict_state_model(out,data,net, minseglength);
% 
% Model_Prob = NOBIAS_difmodel_plot(state_predict, out) 
% 
% Model_Prob rows stand for each diffusive state and columns stands for prediction probability
% for the diffusion type BM, FBM, CTRW, LW