function [delt] = get_delt(perturb_data_3d, colU, colP, p_start, p_end)
%Get the delta vector in
delt = permute(perturb_data_3d(p_start:p_end,colU,:)- perturb_data_3d(p_start:p_end,colP,:), [2, 3, 1]);

end

