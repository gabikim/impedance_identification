function [windowData] = gather_windowData(perturb, stepNum, newSampleSize, signal)
%gather the data based on window size
    startWindow1 = perturb(1,3);
    endWindow1 = perturb(1,4);
    startWindow2 = perturb(1,5);
    endWindow2 = perturb(1,6);
    
        %for window 1
    if startWindow1 < 1 %% if the startWindow is negative, take  data from previous step
        %from step i-1 to start of step i
        windowData = signal(newSampleSize+startWindow1:newSampleSize,stepNum-1);
        %from start of step stepNum to end of window 1
        windowData = [windowData ; signal(1:endWindow1,stepNum)];
    else
        windowData = signal(startWindow1:endWindow1,stepNum);
    end
    
    %for window 2
    if endWindow2 > newSampleSize %% if the end of window2 is in the next step, take data from next step
        %from start of window 2 to end of step stepNum
        windowData = [windowData ; signal(startWindow2:newSampleSize, stepNum)];
        %from start of step stepNum+1 to end of window 2
        windowData = [windowData ; signal(1:(endWindow2-newSampleSize),stepNum+1)];
    else
        windowData = [windowData ; signal(startWindow2:endWindow2, stepNum)];
    end

end

