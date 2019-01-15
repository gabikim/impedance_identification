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
    legend('H_1_1', 'H_1_2 = H_2_1',  'H_2_2')
    xlabel('theta (rad)')
    ylabel('H-matrix value')
    title('Mass matrix values vs. knee angle')
end 

%% Plot Correlation coefficients and RMSE
if plotCorrRMSE == 1
    edges = linspace(0,1,21);
    figure('Name', 'Correlation Coefficients and RMSE')
    subplot(4,1,1);
    histogram(abs(corrRMSE_matrix(:,1,1)), edges)
    ylabel('num values')
    xlabel('Correlation Coefficient RHF torque')
    
    if useH == 0
        title('Correlation Coefficients and RMSE Histograms')
    else
        title(['Correlation Coefficients and RMSE Histograms using Mass Matrix'])
    end
    
    subplot(4,1,2);
    histogram(abs(corrRMSE_matrix(:,1,2)), edges)
    ylabel('num values')
    xlabel('Correlation Coefficient RKF torque')

    
    edges = linspace(0,160,21);
    subplot(4,1,3);
    histogram(abs(corrRMSE_matrix(:,2,1)), edges)
    ylabel('num values')
    xlabel('RMSE RHF torque')
    xticks(linspace(0,160,11))
    
    subplot(4,1,4);
    histogram(abs(corrRMSE_matrix(:,2,2)), edges)
    ylabel('num values')
    xlabel('RMSE RKF torque')
    xticks(linspace(0,160,11))
 
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

%% Plot correlation coefficients between unperturbed step and perturbed step
if plotCorrCoeff == 1
    edges = linspace(0,1,11);
    figure('Name', 'Correlation Coefficients and RMSE')
    histogram(corrCoeff_matrix, edges)
    ylabel('number of steps')
    xlabel('Average Correlation Coefficient')
    title('Average Correlation Coefficient Between Perturbed and Matched Unperturbed Step')
end
    