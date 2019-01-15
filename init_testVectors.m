function [torque_delt_testVec, X_testVec, percent_testVec, Hacc_testVec] = init_testVectors(testVect, torque_delt_curr, X_curr, percent_curr, Hacc_curr)
%initialize the test vector
    torque_delt_testVec = permute(torque_delt_curr(:, testVect, :), [1 3 2]);
    Hacc_testVec = permute(Hacc_curr(:, testVect, :), [1 3 2]);
    X_testVec =  X_curr(:, testVect, :);
    percent_testVec = percent_curr(:, testVect, :);
end

