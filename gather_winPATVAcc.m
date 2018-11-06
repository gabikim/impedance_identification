function [data] = gather_winPATVAcc(perturb, stepNum, newSampleSize, perturbSig, jointAngle_RHF, jointAngle_RKF, torque_RHF, torque_RKF, jointVel_RHF, jointVel_RKF,accel_RHF ,accel_RKF  )
%perturb signal, RHF angle, RKF angle, RHF torque, RKF torque, RHF vel, RKF vel, RHF accel, RKF accel

data = gather_windowData(perturb, stepNum, newSampleSize, perturbSig);
data = [data, gather_windowData(perturb, stepNum, newSampleSize, jointAngle_RHF)];
data = [data, gather_windowData(perturb, stepNum, newSampleSize, jointAngle_RKF)];
data = [data, gather_windowData(perturb, stepNum, newSampleSize, torque_RHF)];
data = [data, gather_windowData(perturb, stepNum, newSampleSize, torque_RKF)];
data = [data, gather_windowData(perturb, stepNum, newSampleSize, jointVel_RHF)];
data = [data, gather_windowData(perturb, stepNum, newSampleSize, jointVel_RKF)];
data = [data, gather_windowData(perturb, stepNum, newSampleSize, accel_RHF)];
data = [data, gather_windowData(perturb, stepNum, newSampleSize, accel_RKF)];

end

