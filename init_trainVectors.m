function [torque_delt_train, X_train, percent_train] = init_trainVectors(testVect, grouping_size_curr, shifted_petSize, torque_delt_curr, X_curr, percent_curr)
%Initialize the training vectors
    torque_delt_train = zeros(2, grouping_size_curr - 1, shifted_petSize); %train the model using N-1 pieces of data
    X_train = zeros(4, grouping_size_curr-1, shifted_petSize);
    percent_train = zeros(1, grouping_size_curr - 1, shifted_petSize);

    %concatinating data so that it does not include the test vector, testVect is the test vector
    if testVect == 1 %if the test vector is the first one in the group
        torque_delt_train = torque_delt_curr(:, 2:grouping_size_curr, :);
        X_train = X_curr(:, 2:grouping_size_curr, :);
        percent_train = percent_curr(:, 2:grouping_size_curr, :);
    elseif testVect == grouping_size_curr %if the test vector is the last one in the group
        torque_delt_train = torque_delt_curr(:, 1:grouping_size_curr-1, :);
        X_train = X_curr(:, 1:grouping_size_curr-1, :);
        percent_train = percent_curr(:, 1:grouping_size_curr-1, :);
    else 
        torque_delt_train(:, 1:testVect-1, :) = torque_delt_curr(:, 1:testVect-1, :);
        torque_delt_train(:, testVect:grouping_size_curr-1, :)= torque_delt_curr(:, testVect+1:grouping_size_curr, :);
        X_train(:, 1:testVect-1, :) = X_curr(:, 1:testVect-1, :);
        X_train(:, testVect:grouping_size_curr-1, :)= X_curr(:, testVect+1:grouping_size_curr, :);
        percent_train(:,1:testVect-1,:) = percent_curr(:, 1:testVect-1, :);
        percent_train(:, testVect:grouping_size_curr-1, :) = percent_curr(:, testVect+1:grouping_size_curr, :);
    end 

end

