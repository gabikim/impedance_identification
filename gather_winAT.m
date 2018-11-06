function [data] = gather_winAT(perturb, stepNum, newSampleSize, jointAngle_RHF, jointAngle_RKF, torque_RHF, torque_RKF)
%%perturb signal, RHF angle, RKF angle, RHF torque, RKF torque based on
%%windows

data = gather_windowData(perturb, stepNum, newSampleSize, jointAngle_RHF);
data = [data, gather_windowData(perturb, stepNum, newSampleSize, jointAngle_RKF)];
data = [data, gather_windowData(perturb, stepNum, newSampleSize, torque_RHF)];
data = [data, gather_windowData(perturb, stepNum, newSampleSize, torque_RKF)];

end

