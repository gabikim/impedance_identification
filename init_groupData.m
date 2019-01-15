function [torque_delt_curr, X_h_curr, percent_curr, percent_arr_curr, torque_curr_pet, torque_curr_unpet, Hacc_curr] = init_groupData(group_sizeCurr, p_size, p_end)
%preallocate necessary vectors for the group

    torque_delt_curr = zeros(2,group_sizeCurr,p_size); %preallocate necessary vectors
    X_h_curr = zeros(4,group_sizeCurr,p_size);
    percent_curr = zeros(1, group_sizeCurr, p_size);
    Hacc_curr = zeros(2, group_sizeCurr, p_size);
    
    percent_arr_curr = zeros(1, group_sizeCurr, p_end);
    torque_curr_pet = zeros(2, group_sizeCurr, p_end);
    torque_curr_unpet = zeros(2, group_sizeCurr, p_end);
    
end

