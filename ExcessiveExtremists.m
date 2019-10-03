% model parameters
N           = 61;   % the number of agents
N_LEFT      = 5;    % the number of left extremists (default: 1)
N_RIGHT     = 4;	% the number of right extremists (default: 1)
epsilon     = 0.1;
eps_left    = epsilon;	% the probability of left extremists to become even more radical
eps_right   = epsilon;	% the probability of right extremists to become even more radical

% simulation parameters
memory_length       = 400;  % how long should we remember things
initialRangeLeft    = -10;   % initial range left boundary of possible values 
initialRangeRight   = 10;	% initial range right boundary of possible values

% ui parameters
pause_length = 0.001; % in seconds
show_final_only = true; % save time by running simulation to the end first, then UIing

modelParams = Objects.ModelParameters(N, epsilon, N_LEFT, eps_left, N_RIGHT, eps_right);
simulationParams = Objects.SimulationParameters(memory_length, initialRangeLeft, initialRangeRight);

points = Objects.Points(modelParams, simulationParams);

close all;
figure;

plotter = Objects.Plotter(modelParams, simulationParams);

for iter = 1:memory_length
    if ~show_final_only
        plotter.Show(points);
    end
    points.Step();
    if ~show_final_only
        pause(pause_length);
    end
end

if show_final_only
    plotter.Show(points);
end

plotter.Save('images/excessive.extremists.tex');
