function [valid] = plot_KB(W_trainRHF, W_trainRKF, RKFtorque_calc, RHFtorque_calc, percent_calc)
%Plot K matrix values

    figure('Name', 'KB matrix values')
    subplot(4,2,1)
    plot(percent_calc, RHFtorque_calc)
    hold on
    plot(percent_calc, W_trainRHF(:,1))
    ylabel('RHF torque vs. K_h_h')
    legend('torque', 'parameter')
    title('K values')
    set(gca, 'XTickLabel', []);
    
    subplot(4,2,3)
    plot(percent_calc, RHFtorque_calc)
    hold on
    plot(percent_calc, W_trainRHF(:,2))
    ylabel('RHF torque vs. K_h_k')
    set(gca, 'XTickLabel', []);

    subplot(4,2,5)
    plot(percent_calc, RKFtorque_calc)
    hold on
    plot(percent_calc, W_trainRKF(:,2))
    ylabel('RKF torque vs. K_k_k')
    set(gca, 'XTickLabel', []);

    subplot(4,2,7)
    plot(percent_calc, RKFtorque_calc)
    hold on
    plot(percent_calc, W_trainRKF(:,1))
    ylabel('RKF torque vs. K_k_h')
    xlabel('percent gait cycle')

    subplot(4,2,2)
    plot(percent_calc, RHFtorque_calc)
    hold on
    plot(percent_calc, W_trainRHF(:,3))
    ylabel('RHF torque vs. B_h_h')
    title('B values')
    set(gca, 'XTickLabel', []);

    subplot(4,2,4)
    plot(percent_calc, RHFtorque_calc)
    hold on
    plot(percent_calc, W_trainRHF(:,4))
    ylabel('RHF torque vs. B_h_k')
    set(gca, 'XTickLabel', []);

    subplot(4,2,6)
    plot(percent_calc, RKFtorque_calc)
    hold on
    plot(percent_calc, W_trainRKF(:,4))
    ylabel('RKF torque vs. B_k_k')
    set(gca, 'XTickLabel', []);

    subplot(4,2,8)
    plot(percent_calc, RKFtorque_calc)
    hold on
    plot(percent_calc, W_trainRKF(:,3))
    ylabel('RKF torque vs. B_k_h')
    xlabel('percent gait cycle')
    
    valid = 1;
end

