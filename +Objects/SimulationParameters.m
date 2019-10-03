classdef SimulationParameters < handle
    %SIMULATIONPARAMETERS holds the properties of CURRENT simulation
    
    properties
        memory_length;  % how long should we remember things
        timeStep;       % time step number
        
        initialRangeLeft;   % initial range left boundary of possible values 
        initialRangeRight;	% initial range right boundary of possible values 
    end
    
    methods
        % initialize simulation parameters
        function obj = SimulationParameters(memory_length, range_min, range_max)
            obj.memory_length = memory_length;
            obj.initialRangeLeft = range_min;
            obj.initialRangeRight = range_max;
            obj.timeStep = 0;
        end
    end
end

