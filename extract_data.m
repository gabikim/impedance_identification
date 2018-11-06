function [time_data, gaitPhase, perturbSig_1, perturbSig_2, jointAngle_RHF, jointAngle_RKF, torque_RHF, torque_RKF, jointVel_RHF, jointVel_RKF] = extract_data(data_file)
%Extract data from file

time_data = data_file.SLRTdata.data(:,52); %time data
gaitPhase = data_file.SLRTdata.data(:,46); %Gait phase (1-4)
perturbSig_1 = data_file.SLRTdata.data(:,1);
perturbSig_2 = data_file.SLRTdata.data(:,2);

%Measured Position (joint angles) of right and left hip and knee, flexion/extension
jointAngle_RHF = data_file.SLRTdata.data(:,22);
jointAngle_RKF = data_file.SLRTdata.data(:,23);

%Force (torque) of right and left hip and knee, flexion/extension
torque_RHF = data_file.SLRTdata.data(:,44);
torque_RKF = data_file.SLRTdata.data(:,45);

%Measured joint velocities
jointVel_RHF = data_file.SLRTdata.data(:,33);
jointVel_RKF = data_file.SLRTdata.data(:,34);


end

