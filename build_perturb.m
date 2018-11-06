function [perturb] = build_perturb(stepCount, perturbSig_1, perturbSig_2, windowSize)
    %%%%%%%%%%%%%builds perturbation array%%%%%%%%%%%%%%
    %Col 1: Signal 1
    %Col 2: Signal 2
    %Col 3: Start Window 1
    %Col 4: End Window 1
    %Col 5: Start Window 2
    %Col 6: End Window 2
    %Col 7: Closest step
    %Col 8: percent gait cycle (accurate)
    %Col 9: percent gait cycle group:
    %0-9%, 10-19%, 20-29%, 30-39%, 40-49%, 50-59%, 60-69%, 70-79%, 80-89%, 90-99%
    
    newSampleSize = size(perturbSig_1,1);
    
    %Find cycles with perturbations
    perturb = zeros(stepCount,9);
    for i=1:stepCount
        for j=1 : newSampleSize
            if (perturbSig_1(j,i) ~=0) 
                perturb(i,1) = 1; 
            end
            if (perturbSig_2(j,i) ~=0)
                perturb(i,2) = 1;
            end
        end     
    end
    
    %Generate windows for perturbations
    for i=1:stepCount
        if perturb(i,1) == 1 && perturbSig_1(1,i) == 0 
        % make sure that the first sample in the cycle is not in the midst of already being perturbed
            for j=1:newSampleSize
                if perturbSig_1(j,i)~=0
                    perturb(i,4) = j-1; %end of window 1, ie right before the start of the perturbation
                    break
                end
            end
            perturb(i,3) = perturb(i,4) - windowSize; %start of window 1
            perturb(i,5) = perturb(i,4) + 1; %start of window 2
            perturb(i,6) = perturb(i,5) + windowSize; %end of window 2
        end
        
        if perturb(i,2) == 1 && perturbSig_2(1,i) == 0 
        % make sure that the first sample in the cycle is not in the midst of already being perturbed
            for j=1:newSampleSize
                if perturbSig_2(j,i)~=0
                    perturb(i,4) = j-1; %end of window 1, ie right before the start of the perturbation
                    break
                end
            end
            perturb(i,3) = perturb(i,4) - windowSize; %start of window 1
            perturb(i,5) = perturb(i,4) + 1; %start of window 2
            perturb(i,6) = perturb(i,5) + windowSize; %end of window 2
        end
    end

    perturb(:, 8) = (perturb(:,4)./newSampleSize)*100; 
    %end of window 1 divided by the sample size(which is one full cycle) gives the % of gait cycle that the perturbation begins at
    %each consecutive sample is 1/2595 of the gait cycle = 3.8536e-04
    perturb(:, 9) = floor(perturb(:, 8)./10)+ 1;

end

