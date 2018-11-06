function [torque_delt_trainSamp, X_trainSamp] = get_trainVectorSamples(index, grouping_size_curr, moving_windowSize, X_train, torque_delt_train, percent_train)
% get X_h and torques for the current window for steps in the group
    torque_delt_trainSamp = NaN;
    X_trainSamp = NaN;
    count = 0; 
    for x = 1:moving_windowSize %for values before index i
        for y = 1:grouping_size_curr-1 %because we exclude the test vector
            if ~isnan(percent_train(1,y,index-x))
                count = count + 1;
                torque_delt_trainSamp(1:2,count) =  torque_delt_train(:, y, index-x);
                X_trainSamp(1:4,count) = X_train(:, y, index-x);
            end
        end
    end
    for x = 0: moving_windowSize %for values after index i, and index i
        for y = 1:grouping_size_curr -1
            if ~isnan(percent_train(1,y,index+x))
                count = count + 1;
                torque_delt_trainSamp(1:2,count) =  torque_delt_train(:, y, index+x);
                X_trainSamp(1:4,count) = X_train(:, y, index+x);
            end
        end
    end
end

