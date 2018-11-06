function [stepArray] = resample_tostep(newSampleSize,stepCount, startCycles, sampleSize, dataArray)
    stepArray = zeros(newSampleSize,stepCount);
    for i=1:stepCount %go through each step
        x = dataArray(startCycles(i):startCycles(i+1)-1); %take the data for one gait cycle
        stepArray(:,i) = resample(x, newSampleSize, sampleSize(i)); %resample this data and put it into the stepArray
    end
end

