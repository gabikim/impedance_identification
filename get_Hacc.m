function [Hacc] = get_Hacc(m1, m2, L1, L2, Ith, Ica, Lth, acc_delt_curr, RKFangles_delt_curr)
%Get the H matrix
numSamples = size(acc_delt_curr,3);
Hacc = zeros(2, 1, numSamples);

    for i = 1:numSamples
        theta2 = RKFangles_delt_curr(1, 1, i);
        H = [m1*L1^2 + m2*(Lth^2 + L2^2 + 2*Lth*L2*cos(theta2)) + Ith, m2*(L2^2 + Lth*L2*cos(theta2));
             m2*(L2^2 + Lth*L2*cos(theta2)), m2*L2^2 + Ica];
        Hacc(:, 1, i) = H*acc_delt_curr(:,1,i);
    end

end

