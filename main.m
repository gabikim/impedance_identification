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
L1 = 0.39*Lth;
L2 = 0.42*Lca; 
Ith = 0.1238; %moment of inertia thigh
Ica = 0.049; %moment of inertia calf

%Options
windowSize = 750; %set window size in terms of # of samples
useH = 0; % 1 for true, 0 for false to use mass matrix in calculations
movingWindowSize = 25; %size of window to train data (make this an odd number)

%Data plots
plotData = 0; %1 for true, 0 for false to plot data for all steps
plotGroupings = 0; %1 for true, 0 for false to plot groupings of cycles
plotMassMatrix = 0; %1 for true, 0 for false to plot mass matrix values
plotTorqueCalc = 0; %1 for true, 0 for false to plot calculated torque values
plotKB = 0; %1 for true, 0 for false to plot K and B matrices
plotCorrRMSE = 0; %1 for true, 0 for false to plot histograms for correlation coefficients and RMSE

%Aside data plots for the report
plotAccFilt = 0; %1 for true, 0 for false to plot acceleration, JV, and filtered acceleration
plotShiftData = 0; %1 for true, 0 for false to plot shifted unperturbed/ perturbed steps

%% Run the pre-processing script
run('preProcess.m')

%% Run the script to process data
run('Process.m')

%% Plot mass matrix as a function of theta
if plotMassMatrix == 1
    th_vector = linspace(0, 1, 200);
    H_11 =  m1*L1^2 + m2*(Lth^2 + L2^2 + 2*Lth*L2*cos(th_vector)) + Ith;
    H_12 = m2*(L2^2 + Lth*L2*cos(th_vector));
    H_22 = ones(1,200)*m2*L2^2 + Ica;
    figure
    plot(th_vector, H_11);
    hold on
    plot(th_vector, H_12);
    hold on
    plot(th_vector, H_22);
    legend('H 11', 'H 12 = H 21',  'H 22')
    xlabel('theta (rad)')
    ylabel('H-matrix value')
    title('Mass matrix values vs. knee angle')
end 

%% Plot Correlation coefficients and RMSE
if plotCorrRMSE == 1
    steps = linspace(1, num_pets, num_pets);
    figure('Name', 'Correlation Coefficients and RMSE')
    subplot(4,1,1);
    histogram(abs(corrRMSE_matrix(:,1,1)), 19)
    ylabel('num values')
    xlabel('Correlation Coefficient RHF torque')
    title('Correlation Coefficients and RMSE Histograms')
    
    subplot(4,1,2);
    histogram(abs(corrRMSE_matrix(:,1,2)), 19)
    ylabel('num values')
    xlabel('Correlation Coefficient RKF torque')
    
    subplot(4,1,3);
    histogram(abs(corrRMSE_matrix(:,2,1)), 19)
    ylabel('num values')
    xlabel('RMSE RHF torque')
    
    subplot(4,1,4);
    histogram(abs(corrRMSE_matrix(:,2,2)), 19)
    ylabel('num values')
    xlabel('RMSE RKF torque')
    
end

%% Plot data
if plotData == 1
    for i = 1:num_pets
        curr_pet = perturb_data_3d(:,1:9,i);
        curr_unpet = perturb_data_3d(:,10:18,i);
        curr_percentage = perturb_data_3d(:,20,i);
        if i < sig2_start
            sigNum = 1;
        else
            sigNum = 2;
        end
        x = plot_data(curr_pet, curr_unpet, sigNum, i, curr_percentage);
    end
end

%% Plot groupings size
if plotGroupings == 1
    figure('Name', 'Grouping sizes for Signal 1')
    for i = sig1_start:sig1_end
        plot(perturb_data_3d(2,19,i), 1, '*', 'MarkerEdgeColor','red')
        hold on
    end 
    for i = 1:size(groupings_size,1)
        hold on
        yLine = linspace(0.8, 1.2, 100);
        xLine = ones(100,1)*i*10;
        plot(xLine, yLine, 'b');
    end
    title('Groupings for Signal 1')
    xlabel('Percent gait cycle')
    axis([0, 100, 0.8, 1.2])
    
    figure('Name', 'Grouping sizes for Signal 2')
    for i = sig2_start:sig2_end
        plot(perturb_data_3d(2,19,i), 1, '*','MarkerEdgeColor','red')
        hold on
    end
    for i = 1:size(groupings_size,1)
        hold on
        yLine = linspace(0.8, 1.2, 100);
        xLine = ones(100,1)*i*10;
        plot(xLine, yLine, 'b');
    end
    title('Groupings for Signal 2')
    xlabel('Percent gait cycle')
    axis([0, 100, 0.8, 1.2])
end

    
    
    