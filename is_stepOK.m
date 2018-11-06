function [valid] = is_stepOK(perturb, stepNum, petStepNum, newSampleSize)
%see if the windows are ok
    startWindow1 = perturb(petStepNum,3);
    endWindow2 = perturb(petStepNum,6);
    valid = 0;
    %if startWindow1 is less than 1 and the startwindow+samplesize is greater than the previous step's ending window
    %Or the start window is more than 1 and the previous step's ending window is smaller than the sample size (ie not continuing into curr window)
    if (startWindow1 < 1 && (startWindow1+newSampleSize > perturb(stepNum-1,6))) || (startWindow1 > 1 && perturb(stepNum-1,6)<newSampleSize)%if startWindow1 is smaller than 1 and 
        %if the ending window is going into the next step and is still greater than the next step's start window
        %or if the ending window is smaller than the new sample size 
        if ((endWindow2 > newSampleSize && (endWindow2-newSampleSize)>perturb(stepNum+1,4)) || (endWindow2 < newSampleSize))
            valid = 1;
        end
    end 
end

