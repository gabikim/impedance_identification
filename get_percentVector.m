function [percentVector] = get_percentVector(pet_percent, newSampleSize, windowSize)
%get vector of percent gait cyle for each sample in the window
    percent_perSample = (1/newSampleSize)*100; %percentage per sample
    percent_winStart = pet_percent -(windowSize*percent_perSample); %percentage at the beginning of window (ie sample 1)
    percent_winEnd = pet_percent + (windowSize+1)*percent_perSample; %percentage at end of the window (ie sampleSize*2+2)
    
    percentVector = [transpose(linspace(percent_winStart,pet_percent-percent_perSample,windowSize));
                     pet_percent;
                     transpose(linspace(pet_percent+percent_perSample, percent_winEnd, windowSize+1))];
end

