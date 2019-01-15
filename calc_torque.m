function [torque_delt_calc, torque_delt_actual, error, percent_calc, torqueU_resized, torqueP_resized, W_trainRHF, W_trainRKF] = calc_torque(testNum, moving_windowSize, shifted_petSize, percent_testVec, W_train, X_testVec, torque_delt_testVec, torqueU_actual, torqueP_actual, Hacc_testVec, useH)
    count = 0;
    for i=moving_windowSize+1:shifted_petSize-moving_windowSize
        if (~isnan(percent_testVec(1,1,i))) && (~isnan(sum(sum(W_train(testNum:testNum+1,:,i))))) %find the beginning of the step, do not use values where W_train is NaN
            count = count + 1;
            if count == 1  
                if useH == 0
                    torque_delt_calc = W_train(testNum:testNum+1, :, i)*X_testVec(:, :, i); %get calculated delta torque
                else
                    torque_delt_calc = W_train(testNum:testNum+1, :, i)*X_testVec(:, :, i) + Hacc_testVec(:,i); %get calculated delta torque
                end
                torque_delt_actual = torque_delt_testVec(:, i);
                percent_calc  = percent_testVec(1,1,i);
                torqueU_resized = torqueU_actual(:, testNum, i);
                torqueP_resized = torqueP_actual(:, testNum, i);
                error = torque_delt_actual(:,count)- torque_delt_calc(:, count);
                W_trainRHF = W_train(testNum, :, i);
                W_trainRKF = W_train(testNum+1, :, i);
            else
                if useH == 0
                    torque_delt_calc = [torque_delt_calc, W_train(testNum:testNum+1, :, i)*X_testVec(:, :, i)]; %get calculated delta torque
                else
                    torque_delt_calc = [torque_delt_calc, W_train(testNum:testNum+1, :, i)*X_testVec(:, :, i)+Hacc_testVec(:,i)];
                end
                torque_delt_actual = [torque_delt_actual, torque_delt_testVec(:, i)];
                percent_calc = [percent_calc, percent_testVec(1,1,i)];
                error = [error, torque_delt_actual(:,count)- torque_delt_calc(:, count)];
                torqueU_resized = [torqueU_resized, torqueU_actual(:, testNum, i)];
                torqueP_resized = [torqueP_resized, torqueP_actual(:, testNum, i)];
                W_trainRHF = [W_trainRHF; W_train(testNum, :, i)];
                W_trainRKF = [W_trainRKF; W_train(testNum+1, :, i)];
            end
            %get delta, ie error
        end
    end  
end

