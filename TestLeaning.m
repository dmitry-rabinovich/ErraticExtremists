function [leaning] = TestLeaning(N, N_LEFT, N_RIGHT, epsilon, eps_left, eps_right)
    % check final core leaning : left = -1, center = 0 or right = 1
    
    % simulation parameters
    memory_length       = 1000;  % how long should we remember things
    initialRangeLeft    = -10;   % initial range left boundary of possible values 
    initialRangeRight   = 10;	% initial range right boundary of possible values

    modelParams = Objects.ModelParameters(N, epsilon, N_LEFT, eps_left, N_RIGHT, eps_right);
    simulationParams = Objects.SimulationParameters(memory_length, initialRangeLeft, initialRangeRight);

    points = Objects.Points(modelParams, simulationParams);

    collectedInitialSplit = false;
    for iter = 1:memory_length
        converged = points.Step();
        if(converged && ~collectedInitialSplit)
            collectedInitialSplit = true;
            % collect initial placement, so we can automatically decide the way the trend worked
            initialCore = GetCore(points, N_LEFT, N_RIGHT);
        end
    end
    
    finalCore = GetCore(points, N_LEFT, N_RIGHT);
    
    leaning = 0;
    if converged
        if finalCore > initialCore
            leaning = 1;
        else
            leaning = -1;
        end
    end
end

function [core_location] = GetCore(points, N_LEFT, N_RIGHT)
    history = points.GetHistory();
    currentState = history(:, end);
    lefties = mink(currentState, N_LEFT);
    righties = maxk(currentState, N_RIGHT);    

    total = sum(currentState);
    extremists = sum([lefties; righties]);
    
    core_location = (total - extremists) / (length(currentState) - N_LEFT - N_RIGHT);
end
