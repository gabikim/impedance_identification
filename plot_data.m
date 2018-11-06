function [x] = plot_data(data1, data2, sigNum, i, curr_percentage)


    figure;
    %perturb signal, RHF angle, RKF angle, RHF torque, RKF torque
    pet_signal = data1(:,1);
    RHF_jointAngles_pet = data1(:,2);
    RKF_jointAngles_pet = data1(:,3);
    RHF_torques_pet = data1(:,4);
    RKF_torques_pet = data1(:,5);
    RHF_jointVel_pet = data1(:,6);
    RKF_jointVel_pet = data1(:,7);
    RHF_accel_pet = data1(:,8);
    RKF_accel_pet = data1(:,9);
    
    signal = data2(:,1);
    RHF_jointAngles = data2(:,2);
    RKF_jointAngles = data2(:,3);
    RHF_torques = data2(:,4);
    RKF_torques = data2(:,5);
    RHF_jointVel = data2(:,6);
    RKF_jointVel = data2(:,7);
    RHF_accel = data2(:,8);
    RKF_accel = data2(:,9);
    
    x_vector = curr_percentage;
    
    subplot(9,1,1);
    plot(x_vector, RHF_jointAngles_pet)
    hold on
    plot(x_vector, RHF_jointAngles)
    legend('perturbed', 'unperturbed')
    if sigNum == 1
        title(['RHF joint angle: sig1, step: ' num2str(i)])
    else
        title(['RHF joint angle:sig2, step: ' num2str(i)])
    end
    set(gca, 'XTickLabel', []);

    subplot(9,1,2);
    plot(x_vector, RKF_jointAngles_pet)
    hold on
    plot(x_vector, RKF_jointAngles)
    legend('perturbed', 'unperturbed')
    title('RKF joint angle')
    set(gca, 'XTickLabel', []);

    subplot(9,1,3);
    plot(x_vector, RHF_torques_pet)
    hold on
    plot(x_vector, RHF_torques)
    legend('perturbed', 'unperturbed')
    title('RHF torques')
    set(gca, 'XTickLabel', []);

    subplot(9,1,4);
    plot(x_vector, RKF_torques_pet)
    hold on
    plot(x_vector, RKF_torques)
    legend('perturbed', 'unperturbed')
    title('RKF torques')
    set(gca, 'XTickLabel', []);

    subplot(9,1,5);
    plot(x_vector, pet_signal)
    hold on
    plot(x_vector, signal)
    legend('perturbed', 'unperturbed')
    title('Perturbation signal')
    set(gca, 'XTickLabel', []);
    
    subplot(9,1,6);
    plot(x_vector, RHF_jointVel_pet)
    hold on
    plot(x_vector, RHF_jointVel)
    legend('perturbed', 'unperturbed')
    title('RHF joint velocities')
    set(gca, 'XTickLabel', []);
        
    subplot(9,1,7);
    plot(x_vector, RKF_jointVel_pet)
    hold on
    plot(x_vector, RKF_jointVel)
    legend('perturbed', 'unperturbed')
    title('RKF joint velocities')
    set(gca, 'XTickLabel', []);
    
    subplot(9,1,8);
    plot(x_vector, RHF_accel_pet)
    hold on
    plot(x_vector, RHF_accel)
    legend('perturbed', 'unperturbed')
    title('RHF accelerations')
    set(gca, 'XTickLabel', []);

    subplot(9,1,9);
    plot(x_vector, RKF_accel_pet)
    hold on
    plot(x_vector, RKF_accel)
    legend('perturbed', 'unperturbed')
    title('RKF accelerations')
    xlabel('Percent gait cycle')
    

    x=1;
        
end

