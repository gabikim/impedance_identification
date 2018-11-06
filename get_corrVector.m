function [corrVector] = get_corrVector(curr_unpet, curr_pet, windowSize)
%Get a vector of correlation coefficients between the unperturbed step and the perturbed step, before the perturbation
%for each of RHF angle, RKF angle, RHF torque, RKF torque
    corrVector = zeros(1,4);

    for x = 1:4 %%do not take the first column, which is the perturbation signal
        R_matrix = corrcoef(curr_unpet(1:windowSize,x), curr_pet(1:windowSize,x)); %%note only look at window before onset of perturbation
        corrVector(1,x) = abs(R_matrix(1,2)); %do not take diagonal entries for matrix
    end
end

