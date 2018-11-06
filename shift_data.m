function [curr_unpet] = shift_data(curr_unpet, curr_pet, windowSize, percent)
%shift data so that the perturbed and unperturbed have the same starting y-value
%shift the unperturbed array by the average of 10% of the first window size
    percent = percent/100;
    shift = mean(curr_unpet(windowSize-floor(windowSize*percent):windowSize,:) - curr_pet(windowSize-floor(windowSize*percent):windowSize,:));
    curr_unpet(:,:) = curr_unpet(:,:) - shift;
                    
end

