function [startCycle, sampleSize, stepCount] = find_gaitData(gaitPhase)
%This function returns a vector containing the index of the start of each the gait cycle
%-1 error, 0 error, 1 double stance left front, 2 right swing, 3 doublestance right in front, 4 left swing
%Each phase starts 2-3, finish by next 2-3
%The index of the end of each cycle is (startCycles(n+1))-1 
%Note, will not count the last cycle as a complete cycle 

index = 0; 

for i = 2:size(gaitPhase)
    if (gaitPhase(i) == 3) && (gaitPhase(i-1) == 2)
        index = index + 1;
        startCycle(index,1) = i; %The index of the start of each cycle is in the vector startCycle. 
    end
end

stepCount = size(startCycle, 1) - 1 ; %number of steps
sampleSize = zeros(stepCount, 1); %Create a vector to hold the sample size of each step

for i=1:stepCount
    sampleSize(i,1)=(startCycle(i+1)-startCycle(i));
end    

end

