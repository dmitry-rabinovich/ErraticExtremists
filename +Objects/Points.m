classdef Points < handle
    %POINTS The class implements simultaneous decision making by all the agents at once
    
    properties (Access = private)
        modelParams;        % model parameters
        simulationParams;	% simulation parameters

        agents;             % historical location of agents. CURRENT is at simulationParams.timeStep mod simulationParams.memory_length
    end
    
    methods
        function obj = Points(modelParams, simulationParams)
            obj.modelParams = modelParams;
            obj.simulationParams = simulationParams;
            
            obj.agents = zeros(modelParams.N, simulationParams.memory_length);
            % randomly set initial locations ([0,1] -> [left, right])
            obj.agents(:, 1) = (simulationParams.initialRangeRight - simulationParams.initialRangeLeft) * rand(modelParams.N, 1) + ...
                simulationParams.initialRangeLeft;
        end
        
        % iterate the simulation one time step
        % Output: the flag denoting if core agents (non-exteremists) are inside the same unit interval (model.stepSize)
        function [coreConverged] = Step(this)
            % proceed to the next time step
            this.simulationParams.timeStep = this.simulationParams.timeStep + 1;
            
            currentIndex = mod(this.simulationParams.timeStep - 1, this.simulationParams.memory_length) + 1;
            nextIndex = mod(this.simulationParams.timeStep, this.simulationParams.memory_length) + 1;
            
            % detect curretn extremists
            [~, I_RIGHT] = maxk(this.agents(:, currentIndex), this.modelParams.N_RIGHT);
            [~, I_LEFT] = mink(this.agents(:, currentIndex), this.modelParams.N_LEFT);
            
            % left extremists move left if become more radical, while right ones to the right
            left_decisions = (-2 * (rand(this.modelParams.N_LEFT, 1) < this.modelParams.eps_left) + 1) * this.modelParams.stepSize;
            right_decisions = (2 * (rand(this.modelParams.N_RIGHT, 1) < this.modelParams.eps_right) - 1) * this.modelParams.stepSize;
            
            % set new coordinates
            this.agents(:, nextIndex) = this.agents(:, currentIndex);
            this.agents(I_LEFT, nextIndex) = this.agents(I_LEFT, nextIndex) + left_decisions;
            this.agents(I_RIGHT, nextIndex) = this.agents(I_RIGHT, nextIndex) + right_decisions;
            
            % detect if core agents are already in tight formation
            right_values = maxk(this.agents(:, nextIndex), this.modelParams.N_RIGHT + 1);
            left_values = maxk(this.agents(:, nextIndex), this.modelParams.N_LEFT + 1);
            coreConverged = right_values(end, 1) - left_values(end, 1) <= this.modelParams.stepSize;        
        end
        
        function [historical_values] = GetHistory(this)
            if(this.simulationParams.timeStep >= this.simulationParams.memory_length)
                historical_values = zeros(size(this.agents));
                % get the index of the curretn state
                currentIndex = mod(this.simulationParams.timeStep, this.simulationParams.memory_length) + 1;
                if(currentIndex == this.simulationParams.memory_length)
                    historical_values = this.agents;
                else
                    historical_values(:, 1:this.simulationParams.memory_length - currentIndex) = ...
                        this.agents(:, currentIndex + 1:this.simulationParams.memory_length);
                    historical_values(:, this.simulationParams.memory_length - currentIndex + 1:end) = ...
                        this.agents(:, 1:currentIndex);
                end
            else
                historical_values = this.agents(:, 1:this.simulationParams.timeStep + 1);
            end
        end
    end
end

