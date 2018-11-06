function [W_train] = init_paramMatrix(shifted_petSize, grouping_size_curr)
%preallocate vectors for the final amswers
    W_train = zeros(grouping_size_curr*2,4,shifted_petSize);
end

