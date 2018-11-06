%% 
if sig==1
    sig_start = sig1_start;
    sig_end = sig1_end;
elseif sig == 2
    sig_start = sig2_start;
    sig_end = sig2_end;
end


for k = 1:9 %for each cycle percentage grouping
    %% Get all current data for one particular percentage grouping (1-9)
    groupsize_curr = groupings_size(k, sig);
    %preallocate necessary vectors
    [torque_delt_curr, X_curr, percentP_curr, percent_curr, torque_curr_pet, torque_curr_unpet] = init_groupData(groupsize_curr, p_size, p_end);
    count = 0;
    for j = sig_start:sig_end %go through all steps that were perturbed by signal 1
        if cycle_groups(1,j) == k %find steps with the wanted cycle percentage group
            count = count + 1; 
            if useH == 1
                Hacc = get_Hacc(m1, m2, L1, L2, Ith, Ica, Lth, Acc_matrix(:, j, :),  X_matrix(2, j, :)); %create H matrix only if option is selected
            end
            torque_delt_curr(:, count, :) = torque_delt(:,j,:) - Hacc; 
            X_curr(:, count, :) = X_matrix(:,j,:);
            torque_curr_pet(:, count, :) = torque_pet(:, j, :);
            torque_curr_unpet (:, count, :)= torque_unpet(:, j, :);
            percent_curr(1, count, :) = percent_arr(1, j, :); %before perturbation and after perturbation
            percentP_curr(1, count,:) = percent_arr(1,j,p_start:p_end); %just perturbation
        end
    end 
    
    %% Shift the data so that the percentage gait cycles are aligned
    % All data spaces without samples are replaced with NaN
    torqueU_actual = torque_curr_unpet(:,:,p_start:p_end); %unperturbed torques for after pet starts 
    torqueP_actual = torque_curr_pet(:,:,p_start:p_end); %perturbed torques for after pet starts 
    [percentP_curr, torque_delt_curr, X_curr, torqueU_actual, torqueP_actual] = align_cyclePercent(newSampleSize, p_size, groupsize_curr, percentP_curr, torque_delt_curr, X_curr, torqueU_actual, torqueP_actual);
    shifted_petSize = size(percentP_curr, 3); %look how big the new shifted array is by looking at the 3rd dimension (samples) of percentP_curr
    
    %% Use one test vector and the rest in the group as training vectors
    % initialize the matrices where we will store our calculated parameters
    [W_train] = init_paramMatrix(shifted_petSize, groupsize_curr); 
    
    %Go through all steps in the group, successively choose test vectors and training data
    for testNum = 1:groupsize_curr 
        %initialize data for training vectors
        [torque_delt_train, X_train, percent_train] = init_trainVectors(testNum, groupsize_curr, shifted_petSize, torque_delt_curr, X_curr, percentP_curr);
        %Get the weighted matrix that was trained on N-1 samples using the perscribed moving window size
        for i=moving_windowSize+1:shifted_petSize-moving_windowSize %i is the current index 
            %Get the samples based on the moving window centered on i
            [torque_delt_trainSamp, X_trainSamp] = get_trainVectorSamples(i, groupsize_curr, moving_windowSize, X_train, torque_delt_train, percent_train);
            XXT = X_trainSamp(:,:)*transpose(X_trainSamp(:,:)); %vector X multiplied by its transpose
            if det(XXT) > 1e-15 %%dont take the inverse if the determinant is too close to zero, leave it as NaN
                W_train(testNum:testNum+1,:,i)= torque_delt_trainSamp(:,:)*transpose(X_trainSamp(:,:))*inv(XXT);%inverse_XXT;
            else
                W_train(testNum:testNum+1,:,i) = NaN;
            end        
        end  
        
        %W_h_train goes from moving windowSize+1 to shifted_petSize-moving_windowSize
        % initialize data for test vector, testNum
        [torque_delt_testVec, X_testVec, percent_testVec] = init_testVectors(testNum, torque_delt_curr, X_curr, percentP_curr);
        % calculate torque for test vector, testNum
        [torque_delt_calc, torque_delt_actual, delt_error, percent_calc, torqueU_actual_curr, torqueP_actual_curr, W_trainRHF, W_trainRKF] = calc_torque(testNum, moving_windowSize, shifted_petSize, percent_testVec, W_train, X_testVec, torque_delt_testVec, torqueU_actual, torqueP_actual);
       
        RHFtorque_delt_calc = smoothdata(torque_delt_calc(RHF,:) , 'gaussian', 5); %apply a filter to remove noise
        RHFtorque_calc = torqueU_actual_curr(RHF,:) - RHFtorque_delt_calc; %calculate torque by adding to unperturbed torque
        RKFtorque_delt_calc = smoothdata(torque_delt_calc(RKF,:) , 'gaussian', 10); %apply a median filter to remove singularities
        RKFtorque_calc = torqueU_actual_curr(RKF,:) - RKFtorque_delt_calc; %calculate torque by adding to unperturbed torque
        
        %get correlation coefficients and mean squared errors
        count_step = count_step + 1;
        corrRMSE_matrix (count_step, 1, RHF) = corr2(RHFtorque_calc, torqueP_actual_curr(RHF,:));
        corrRMSE_matrix (count_step, 2, RHF) = sqrt(sum((delt_error(RHF,:)).^2)/size(delt_error(RHF,:), 2));
        corrRMSE_matrix (count_step, 1, RKF) = corr2(RKFtorque_calc, torqueP_actual_curr(RKF,:));
        corrRMSE_matrix (count_step, 2, RKF) = sqrt(sum((delt_error(RKF,:)).^2)/size(delt_error(RKF,:), 2));

        if plotTorqueCalc == 1 %&& count_step < 10 && count_step > 0
            valid = plot_torqueCalc(delt_error, RKFtorque_calc, RHFtorque_calc, corrRMSE_matrix, percent_calc, count_step, torque_delt_actual, RHFtorque_delt_calc, RKFtorque_delt_calc, torqueP_actual_curr, torqueU_actual_curr);
        end  
        if plotKB == 1 %&& count_step < 10 && count_step > 0
            valid = plot_KB(W_trainRHF, W_trainRKF, RKFtorque_calc, RHFtorque_calc, percent_calc);
        end
        
    end   
end
