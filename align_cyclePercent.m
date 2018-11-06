function [percent_curr, torque_delt_curr, X_h_curr, torqueU_actual, torqueP_actual] = align_cyclePercent(newSampleSize, p_size, grouping_size_curr, percent_curr, torque_delt_curr, X_h_curr, torqueU_actual, torqueP_actual)
%Shift the data so that the percentage gait cycles are aligned
%find minimum and maximum percentage of sample 1, get the index
   %find minimum and maximum percentage of sample 1, get the index
    [minPercent, minIndex] = min(percent_curr(:, :, 1));
    [maxPercent, maxIndex] = max(percent_curr(:, :, 1));
    percent_perSample = (1/newSampleSize)*100; %percentage per sample
    max_shift = round(abs((percent_curr(1, maxIndex, 1) - percent_curr(1, minIndex, 1))/percent_perSample));
    
    %Make arrays big enough to fit all samples by adding a NaN vector at
    %the end. Now can just shift data to the right
    torque_delt_curr = cat(3, torque_delt_curr, nan(2, grouping_size_curr, max_shift));
    X_h_curr = cat(3, X_h_curr, nan(4, grouping_size_curr, max_shift));
    percent_curr = cat(3, percent_curr, nan(1, grouping_size_curr, max_shift));
    torqueU_actual = cat(3, torqueU_actual, nan(2, grouping_size_curr, max_shift));
    torqueP_actual = cat(3, torqueP_actual, nan(2, grouping_size_curr, max_shift));
    
    for j = 1:grouping_size_curr
        if j ~= minIndex
            shift_index = round(abs((percent_curr(1,j,1)- percent_curr(1, minIndex, 1))/percent_perSample));

            torque_delt_curr(:, j, shift_index+1:shift_index+p_size) = torque_delt_curr(:, j, 1:p_size);
            torque_delt_curr(:, j, 1:shift_index) = nan(2,1,shift_index);
            X_h_curr(:, j, shift_index+1:shift_index+p_size) = X_h_curr(:, j, 1:p_size);
            X_h_curr(:, j, 1:shift_index) = nan(4,1,shift_index);
            percent_curr(1, j, shift_index+1:shift_index+p_size) = percent_curr(1, j, 1:p_size);
            percent_curr(1, j, 1:shift_index) = nan(1,1,shift_index);
            torqueU_actual(:, j, shift_index+1:shift_index+p_size) = torqueU_actual(:, j, 1:p_size);
            torqueU_actual(:, j, 1:shift_index) = nan(2,1,shift_index);
            torqueP_actual(:, j, shift_index+1:shift_index+p_size) = torqueP_actual (:, j, 1:p_size);
            torqueP_actual(:, j, 1:shift_index) = nan(2,1,shift_index);
        end
    end
    
end

