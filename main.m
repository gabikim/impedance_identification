clear all;
close all;
clc;

%% Set up parameters
fileName = '160226_LPER_FED_03_SLRT_ZeroImpedance.mat';

%Constants
m1 = 6.4; %mass of thigh
m2 = 3.1; %mass of calf
Lth = 0.46; %Length thigh
Lca = 0.43; %Length calf
Ith = 0.1238; %moment of inertia thigh
Ica = 0.049; %moment of inertia calf
L1 = 0.39*Lth; 
L2 = 0.42*Lca; 

%Options
windowSize = 750; %set window size in terms of # of samples
useH = 0; % 1 for true, 0 for false to use mass matrix in calculations
movingWindowSize = 25; %size of window to train data (make this an odd number)

%Data plots
plotData = 0; %1 for true, 0 for false to plot data for all steps
plotGroupings = 0; %1 for true, 0 for false to plot groupings of cycles
plotMassMatrix = 0; %1 for true, 0 for false to plot mass matrix values
plotTorqueCalc = 0; %1 for true, 0 for false to plot calculated torque values
plotCorrCoeff = 0; %1 for true, 0 for false to plot correlation coefficients between perturbed and associated unpet step
plotKB = 0; %1 for true, 0 for false to plot K and B matrices
plotCorrRMSE =0; %1 for true, 0 for false to plot histograms for correlation coefficients and RMSE of trained data

%Aside data plots for the report
plotAccFilt = 0; %1 for true, 0 for false to plot acceleration, JV, and filtered acceleration
plotShiftData = 0; %1 for true, 0 for false to plot shifted unperturbed/ perturbed steps

%% Run the scripts
if mod(movingWindowSize,2) == 0
    disp('please make variable movingWindowSize an odd integer')
else
    run('preProcess.m')  %Run the pre-processing script 
    run('Process.m') % Run the script to process data
    run('plotting.m') %Run the script to plot data
end


    
    
    