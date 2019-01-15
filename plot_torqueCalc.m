function [valid] = plot_torqueCalc(delt_error, RKFtorque_calc, RHFtorque_calc, corrRMSE_matrix, percent_calc, count_step, torque_delt_actual, RHFtorque_delt_calc, RKFtorque_delt_calc, torqueP_actual_curr, torqueU_actual_curr, currDate)
%Plots torque
    
%Make directory 

    figure('Name', 'Calculated Torques');
    subplot(6,1,1);
    plot(percent_calc, delt_error(1,:))
    ylabel('\Delta error')
    title(['RHF, correlation coefficient: ' num2str(corrRMSE_matrix(count_step,1,1)) ' for step No. ' num2str(count_step)])
    set(gca, 'XTickLabel', []);
    %title(corrRMSE_matrix(count_step,1,1))  

    subplot(6,1,2);
    plot(percent_calc, torque_delt_actual(1,:));
    hold on
    plot(percent_calc, RHFtorque_delt_calc);
    ylabel('\Delta Torque RHF')
    legend('actual', 'calculated');
    set(gca, 'XTickLabel', []);

    subplot(6,1,3);
    plot(percent_calc, torqueP_actual_curr(1,:));
    hold on
    plot(percent_calc, torqueU_actual_curr(1,:));
    hold on
    plot(percent_calc, RHFtorque_calc);
    legend('actual perturbed', 'actual unperturbed', 'calculated');
    ylabel('torque RHF')
    set(gca, 'XTickLabel', []);
    
    subplot(6,1,4);
    plot(percent_calc, delt_error(2,:))
    ylabel('\Delta error RKF')
    title(['RKF, correlation coefficient: ' num2str(corrRMSE_matrix(count_step,1,2)) ' for step No. ' num2str(count_step)])
    set(gca, 'XTickLabel', []);
    %title(corrRMSE_matrix(count_step,1,2))

    subplot(6,1,5);
    plot(percent_calc, torque_delt_actual(2,:));
    hold on
    plot(percent_calc, RKFtorque_delt_calc);
    ylabel('\Delta Torque RKF')
    legend('actual', 'calculated');
    set(gca, 'XTickLabel', []);

    subplot(6,1,6);
    plot(percent_calc, torqueP_actual_curr(2,:));
    hold on
    plot(percent_calc, torqueU_actual_curr(2,:));
    hold on
    plot(percent_calc, RKFtorque_calc);
    legend('actual perturbed', 'actual unperturbed', 'calculated');
    ylabel('torque RKF')
    xlabel('Percent gait cycle')
    
    filepath_name = ['/' currDate '/calcTorque_' num2str(count_step) '.fig'];
    saveas(figure(count_step),[pwd filepath_name]);
    valid = 1;
    
end

