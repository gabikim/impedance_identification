%% make directory to save figures
if plotTorqueCalc == 1 || plotData == 1 || plotKB == 1
    currDate = strrep(datestr(datetime), ':', '_');
    c = mkdir(currDate);
    clear c;
end

%% Load data from file
data_file = load(fileName);

%% Set up data
%Extract data from file
[time_data, gaitPhase, perturbSig_1, perturbSig_2, jointAngle_RHF, jointAngle_RKF, torque_RHF, torque_RKF, jointVel_RHF, jointVel_RKF] = extract_data(data_file);

%Calculate instantaneous accelerations from joint velocities
accel_RKF = calc_acceleration(jointVel_RKF, time_data);                                                                                                        
accel_RHF = calc_acceleration(jointVel_RHF, time_data); 

%% Sorting data into steps looking at gait cycle
[startCycles, sampleSize, stepCount] = find_gaitData(gaitPhase); 
%startCycles contains the index of the beginning of each gait cycle in the vector gaitPhas
%stepCount is the number of steps taken in the dataset
%sampleSize is a vector containing the sample size of each gait cycle
%The index of the end of each cycle is (startCycles(n+1))-1 

newSampleSize = mode(sampleSize);%Resample Cycles using the mode of sample sizes 
%resample_tostep resamples the data and makes it into a matrix where each
%column is a new step
jointAngle_RHF = resample_tostep(newSampleSize, stepCount, startCycles, sampleSize, jointAngle_RHF);
jointAngle_RKF = resample_tostep(newSampleSize, stepCount, startCycles, sampleSize, jointAngle_RKF);
torque_RHF = resample_tostep(newSampleSize, stepCount, startCycles, sampleSize, torque_RHF);
torque_RKF = resample_tostep(newSampleSize, stepCount, startCycles, sampleSize, torque_RKF);
perturbSig_1 = resample_tostep(newSampleSize, stepCount, startCycles, sampleSize, perturbSig_1);        
perturbSig_2 = resample_tostep(newSampleSize, stepCount, startCycles, sampleSize, perturbSig_2); 
jointVel_RHF = resample_tostep(newSampleSize, stepCount, startCycles, sampleSize, jointVel_RHF);        
jointVel_RKF = resample_tostep(newSampleSize, stepCount, startCycles, sampleSize, jointVel_RKF);
accel_RHF = resample_tostep(newSampleSize, stepCount, startCycles, sampleSize, accel_RHF);        
accel_RKF = resample_tostep(newSampleSize, stepCount, startCycles, sampleSize, accel_RKF);

%% Aside used to plot accelerations for the report
if plotAccFilt == 1
    for i = 1 : 10
        figure
        subplot(4,1,1);
        plot(linspace(0, 100, newSampleSize), jointVel_RKF(:,i));
        set(gca, 'XTickLabel', []);
        ylabel('Joint Vel RKF');
        title('Filtered Accelration Data');

        subplot(4,1,2);
        plot(linspace(0, 100, newSampleSize), accel_RKF(:,i));
        hold on
        plot(linspace(0, 100, newSampleSize), smoothdata(accel_RKF(:,i),'movmean',10));
        ylabel('Acceleration RKF');
        set(gca, 'XTickLabel', []);
        %legend('Raw acceleration', 'Filtered acceleration')

        subplot(4,1,3);
        plot(linspace(0, 100, newSampleSize), jointVel_RHF(:,i));
        ylabel('Joint Vel RHF');
        set(gca, 'XTickLabel', []);

        subplot(4,1,4);
        plot(linspace(0, 100, newSampleSize), accel_RHF(:,i));
        hold on
        plot(linspace(0, 100, newSampleSize), smoothdata(accel_RHF(:,i),'movmean',10));
        ylabel('Acceleration RHF');
        xlabel('Percent gait cycle');
        legend('Raw acceleration', 'Filtered acceleration')
    end 
end 


%% filter acceleration data
for i = 1:stepCount
    accel_RKF(:,i) = smoothdata(accel_RKF(:,i),'movmean',10);
    accel_RHF(:,i) = smoothdata(accel_RHF(:,i),'movmean',10);
end 

%% Find the closest unperturbed step
%perturb array contains the following data: (Note that each row is a different step
%Col 1: Signal 1, Col 2: Signal 2, Col 3: Start Window 1, Col 4: End Window 1
%Col 5: Start Window 2, Col 6: End Window 2, Col 7: Closest step,Col 8: percent gait cycle of onset of perturbation
%Col 9: percent gait cycle group: 0-9%, 10-19%, 20-29%, 30-39%, 40-49%, 50-59%, 60-69%, 70-79%, 80-89%, 90-99%
perturb = build_perturb(stepCount, perturbSig_1, perturbSig_2, windowSize);
corrCoeff_matrix = nan(stepCount,1);

%We need to find the analogous portion of the gait cycle that matches the closest window 1 of the unperturbed step.
%This is determined by finding the highest correlation coefficient
num_pets = 0;
for i = 1:stepCount %for each perturbed step
    if (perturb(i,3) ~= 0) && ((perturb(i,1)==1) || (perturb(i,2)==1))%if signal 1 is perturbing and there is a start window
        num_pets = num_pets + 1;
        curr_pet = gather_winAT(perturb(i,:), i, newSampleSize, jointAngle_RHF, jointAngle_RKF, torque_RHF, torque_RKF); %gather perturbed data based on window sizes 
        numvalid = 0; %keep track of how many valid unperturbed steps there are that fit the window
        meanCorr = 0; %reset the mean correlation vector
        for j=2:stepCount 
            if perturb(j,1) == 0 && perturb(j,2) == 0 %get unperturbed steps 
                curr_unpet = 0; %Perturb Sig_1 RHF angle, RKF angle, RHF torque, RKF torque
                valid = is_stepOK(perturb, j, i, newSampleSize); %check to see if the step's window is valid
                if  valid == 1
                    numvalid = numvalid + 1;
                    curr_unpet = gather_winAT(perturb(i,:), j, newSampleSize, jointAngle_RHF, jointAngle_RKF, torque_RHF, torque_RKF);
                    %shift data so that the perturbed and unperturbed have the same starting y-value --use average of 10% of window size
                    curr_unpet = shift_data(curr_unpet, curr_pet, windowSize, 10);
                    %Now, find correlation coefficients for the current unperturbed step
                    corrVector = get_corrVector(curr_unpet, curr_pet, windowSize);%RHF angle, RKF angle, RHF torque, RKF torque
                    if numvalid == 1
                        meanCorr = [mean(corrVector), j]; %get the mean of the correlation vector, and put the corresponding step number in the next col
                    else
                        meanCorr = [meanCorr; mean(corrVector), j];
                    end
                end     
            end
        end
        [MaxCorr, MaxCorrIndex]= max(meanCorr(:,1)); %now see which step has the highest correlation coefficient
        perturb(i,7) = meanCorr(MaxCorrIndex,2); %put the closest step into perturbation array
        corrCoeff_matrix(i, 1) = MaxCorr;
    end
end

%% Compile the array of data needed to perform calculations
%each page is one perturbation
%Col 1: perturb signal, Col 2: RHF angle pet, Col 3:RKF angle pet, Col 4:RHF torque pet, Col 5: RKF pet torque, Col 6: RHF pet velocity, Col 7: RKF pet velocity, Col 8: RHF pet acc, Col 9: RKF pet acc 
%Col 10: signal (all 0 bc unpet), Col 11: RHF angle normal, Col 12:RKF angle normal, Col 13:RHF torque normal, Col 14: RKF normal torque, Col 15: RHF velocity, Col 16: RKF velocity, Col 17:RHF acc, Col 18:RKF acc,
%Col 19: (1,15) index is the percent gait grouping
%Col 20: accurate percentage of onset of perturbation (vector)
perturb_data_3d = zeros(windowSize*2+2, 20, num_pets);

%Column vector of the number of perturbations within each percentage of the cycle grouping
%Column 1 is for signal 1 and column 2 is for signal 2
groupings_size = zeros(10, 2); 

num_pets = 0;
sig1_start = 1; %where the first perturbation signal begins
%for signal 1, get the windows and graph
for i = 1:stepCount %for each perturbed step
    if perturb(i,3) ~= 0 && (perturb(i,1)==1)
        num_pets = num_pets + 1;
        unpet_step = perturb(i,7);
        %Gather windowed data for: perturb signal, RHF angle, RKF angle, RHF torque, RKF torque, RHF vel, RKF vel, RHF accel, RKF accel
        curr_pet = gather_winPATVAcc(perturb(i,:), i, newSampleSize, perturbSig_1, jointAngle_RHF, jointAngle_RKF, torque_RHF, torque_RKF, jointVel_RHF, jointVel_RKF,accel_RHF, accel_RKF);
        curr_unpet = gather_winPATVAcc(perturb(i,:), unpet_step, newSampleSize, perturbSig_1, jointAngle_RHF, jointAngle_RKF, torque_RHF, torque_RKF, jointVel_RHF, jointVel_RKF,accel_RHF, accel_RKF);
        
        if plotShiftData == 1 && num_pets == 10
            unshifted_unpet = curr_unpet(:,2:9); %%for plotting purposes in the report
        end
        
        %shift all data to match y-values
        curr_unpet(:,2:9) = shift_data(curr_unpet(:,2:9), curr_pet(:,2:9), windowSize, 10);
        
        %put data into 3d array
        perturb_data_3d(:,1:9,num_pets) = curr_pet;
        perturb_data_3d(:,10:18,num_pets) = curr_unpet;
        %x = plot_data(curr_pet, curr_unpet, 1, num_pets);
        perturb_data_3d(1,19,num_pets) = perturb(i,9); %grouping
        perturb_data_3d(2,19,num_pets) = perturb(i,8); %accurate percentage
        %get percent gait cycle for each sample
        perturb_data_3d(:,20,num_pets) = get_percentVector(perturb(i,8),newSampleSize, windowSize);
        
        if plotShiftData == 1 && num_pets == 10 %% this is just plotting for the report
            da = 3;
            figure
            subplot(2,1,1)
            plot(perturb_data_3d(:,20,num_pets), unshifted_unpet(:,da));
            hold on
            plot(perturb_data_3d(:,20,num_pets), curr_unpet(:,da+1));
            hold on
            plot(perturb_data_3d(:,20,num_pets), curr_pet(:,da+1));
            legend('unperturbed signal', 'shifted unperturbed signal', 'perturbed signal')
            ylabel('RHF torque')
            subplot(2,1,2)
            plot(perturb_data_3d(:,20,num_pets), curr_pet(:,1))
            xlabel('percent gait cycle');
            ylabel('perturb sig')
            title('Shifted unperturbed signals RHF torque')
        end
        
        groupings_size(perturb(i,9),1) = groupings_size(perturb(i,9),1) + 1; %compile groupings size vector
    end
end
sig1_end = num_pets;

%for signal 2, get the windows and graph
sig2_start = num_pets + 1;
for i = 1:stepCount
    if perturb(i,3) ~= 0 && (perturb(i,2)==1)
        num_pets = num_pets+1;
        unpet_step = perturb(i,7);
        %Gather windowed data for: perturb signal, RHF angle, RKF angle, RHF torque, RKF torque, RHF vel, RKF vel, RHF accel, RKF accel
        curr_pet = gather_winPATVAcc(perturb(i,:), i, newSampleSize, perturbSig_2, jointAngle_RHF, jointAngle_RKF, torque_RHF, torque_RKF, jointVel_RHF, jointVel_RKF,accel_RHF, accel_RKF);
        curr_unpet = gather_winPATVAcc(perturb(i,:), unpet_step, newSampleSize, perturbSig_2, jointAngle_RHF, jointAngle_RKF, torque_RHF, torque_RKF, jointVel_RHF, jointVel_RKF,accel_RHF, accel_RKF);
        %shift all data to match y-values
        curr_unpet(:,2:9) = shift_data(curr_unpet(:,2:9), curr_pet(:,2:9), windowSize, 10);
        
        %put data into 3d array
        perturb_data_3d(:,1:9,num_pets) = curr_pet;
        perturb_data_3d(:,10:18,num_pets) = curr_unpet;
        %x = plot_data(curr_pet, curr_unpet, 2, num_pets);
        perturb_data_3d(1,19,num_pets) = perturb(i,9); %grouping
        perturb_data_3d(2,19,num_pets) = perturb(i,8); %accurate percentage
        %get percent gait cycle for each sample
        perturb_data_3d(:,20,num_pets) = get_percentVector(perturb(i,8),newSampleSize, windowSize);
        
        groupings_size(perturb(i,9),2) = groupings_size(perturb(i,9),2)+1; %compile groupings size vector
    end
end
sig2_end = num_pets;

