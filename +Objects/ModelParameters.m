classdef ModelParameters < handle
    %MODELPARAMETERS the object holds all the CURRENT parameters of the model
    
    properties
        N;          % the number of agents
        N_LEFT;     % the number of left extremists (default: 1)
        N_RIGHT;	% the number of right extremists (default: 1)
        eps_left;	% the probability of left extremists to become even more radical
        eps_right;	% the probability of right extremists to become even more radical
        stepSize;   % the absolute value in opinion change (default: 1)
    end
    
    methods
        function obj = ModelParameters(n, epsilon, n_left, eps_left, n_right, eps_right)
            %MODELPARAMETERS Construct an instance of this class
            %   see relevant parameters in class properties
            if (nargin > 3)
                obj.eps_left = eps_left;
            else
                obj.eps_left = epsilon;
            end
            if (nargin > 5)
                obj.eps_right = eps_right;
            else
                obj.eps_right = epsilon;
            end
            if (nargin > 2)
                obj.N_LEFT = n_left;
            else
                obj.N_LEFT = 1;
            end
            if (nargin > 4)
                obj.N_RIGHT = n_right;
            else
                obj.N_RIGHT = 1;
            end
            obj.N = n;
            obj.stepSize = 1;
        end
    end
end

