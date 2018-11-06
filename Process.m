%Run preProcess first to load all data 

%% Column vector index from perturb_data_3D
col_sigP = 1;
col_RHFangP = 2;
col_RKFangP = 3;
col_RHFtorqueP = 4;
col_RKFtorqueP = 5;
col_RHFvelP = 6;
col_RKFvelP = 7;
col_RHFaccP = 8;
col_RKFaccP = 9;
col_sigU = 10; %should be all 0's because this is the closest unperturbed step
col_RHFangU = 11;
col_RKFangU = 12;
col_RHFtorqueU = 13;
col_RKFtorqueU = 14;
col_RHFvelU = 15;
col_RKFvelU = 16;
col_RHFaccU = 17;
col_RKFaccU = 18;
%%perturb_data_3d (1,19,i) is the grouping, and perturb_data_3d(2,19,i) is the percentage
col_percentSamp = 20; %vector of gait cycle
moving_windowSize = floor(movingWindowSize/2); %This is the moving window to be examined, it is 8 samples to the left and 8 samples to the right of the current sample
corrRMSE_matrix = nan(num_pets,2,2); %first column is correlation, second column is RMSE, first page is RHF, second page is RKF

%%
      
%index of signals
%sig1_start is the start page index of perturbations on RHF in the perturb_data_3d array
%sig1_end is the end page index of perturbations on RHF in the perturb_data_3d array
%sig2_start is the start page index of perturbations on RKF in the perturb_data_3d array
%sig2_end is the end page index of perturbations on RKF in the perturb_data_3d array
%In this case, sig1_start=1, sig1_end = 41, sig2_start = 42, sig2_end = 81
p_start = windowSize+2; %This is the index in the window of the onset of the perturbation
p_end = windowSize*2+2; %This is the index in the window of the windowSize after the onset of the perturbation
cycle_groups = permute(perturb_data_3d(1,19,:), [1 3 2]);
p_size = p_end - p_start + 1;

%find delta values for perturbed and unperturbed -after the perturbation
%one row, each column is a different step, each page is a different sample
RHFtorque_delt = get_delt(perturb_data_3d, col_RHFtorqueU, col_RHFtorqueP, p_start, p_end);
RKFtorque_delt = get_delt(perturb_data_3d, col_RKFtorqueU, col_RKFtorqueP, p_start, p_end);
RHFangle_delt = get_delt(perturb_data_3d, col_RHFangU, col_RHFangP, p_start, p_end);
RKFangle_delt = get_delt(perturb_data_3d, col_RKFangU, col_RKFangP, p_start, p_end);
RHFvel_delt = get_delt(perturb_data_3d, col_RHFvelU, col_RHFvelP, p_start, p_end);
RKFvel_delt = get_delt(perturb_data_3d, col_RKFvelU, col_RKFvelP, p_start, p_end);
RHFacc_delt = get_delt(perturb_data_3d, col_RHFaccU, col_RHFaccP, p_start, p_end);
RKFacc_delt = get_delt(perturb_data_3d, col_RKFaccU, col_RKFaccP, p_start, p_end);
RHFtorque_unpet = permute(perturb_data_3d(:,col_RHFtorqueU,:),[2 3 1]);
RHFtorque_pet = permute(perturb_data_3d(:,col_RHFtorqueP,:), [2 3 1]);
RKFtorque_unpet = permute(perturb_data_3d(:,col_RKFtorqueU,:),[2 3 1]);
RKFtorque_pet = permute(perturb_data_3d(:,col_RKFtorqueP,:), [2 3 1]);
percent_arr = permute(perturb_data_3d(:,col_percentSamp,:), [2 3 1]);

torque_delt = [RHFtorque_delt; RKFtorque_delt];
torque_unpet = [RHFtorque_unpet; RKFtorque_unpet];
torque_pet = [RHFtorque_pet; RKFtorque_pet];

%X matrices
X_matrix = [RHFangle_delt; RKFangle_delt; RHFvel_delt; RKFvel_delt];
Acc_matrix = [RHFacc_delt; RKFacc_delt];

%% train data for signal 1 and signal 2 applied
count_step = 0;
sig = 1;
RHF = 1;
RKF = 2;
Hacc = 0;
run('train.m')

Hacc = 0;
sig = 2;
run('train.m')

