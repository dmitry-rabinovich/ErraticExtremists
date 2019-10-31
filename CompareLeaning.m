% model parameters
N           = 1024;   % the number of agents
N_LEFT      = 20;    % the number of left extremists (default: 1)
epsilon     = 0.1;
eps_left    = epsilon;	% the probability of left extremists to become even more radical

num_iterations = 100;
num_eps_steps = 50;
eps_step = 2 / num_eps_steps;

results = zeros(2 * N_LEFT, num_eps_steps);

for N_RIGHT = 1:(2 * N_LEFT)
    fprintf('N_RIGHT = %d\n', N_RIGHT);
    for n_step = 1:num_eps_steps
        fprintf('\tn_step = %d\t', n_step);
        tic;
        for iter = 1:num_iterations
            results(N_RIGHT, n_step) = results(N_RIGHT, n_step) + ...
                TestLeaning(N, N_LEFT, N_RIGHT, epsilon, eps_left, n_step * eps_step * eps_left);
        end
        toc;
    end
end

results = results / num_iterations;
results(abs(results) <= 0.5) = 0;
results = sign(results);

figure;
sfig = pcolor(results);
set(sfig, 'EdgeColor', 'none');
%sfig.FaceColor = 'interp';
colormap(prism(5));

xticklabels(cellstr(num2str(cellfun(@(x) str2double(x), xticklabels) * eps_step)));
yticklabels(cellstr(num2str(cellfun(@(x) str2double(x), yticklabels) / N_LEFT)));

xlabel('Right-to-left stubbornness ratio');
ylabel('Right-to-left abundance ratio');
title('Society opinion leaning : to the right ( blue ) or to the left ( red )');
hLegend = legend;
set(hLegend, 'visible', 'off');

modelParams = Objects.ModelParameters(N, epsilon, N_LEFT, epsilon, N_LEFT, epsilon);
simulationParams = Objects.SimulationParameters(1000, -10, 10);

plotter = Objects.Plotter(modelParams, simulationParams);
plotter.Save('images/eps.ratio.vs.extremists.ratio.tex');

% expected output
figure;

ratio_N_resolution = 1 / 100;
ratio_eps_resolution = 1 / 200;
ratio_N = (ratio_N_resolution:ratio_N_resolution:2)';
ratio_eps = (ratio_eps_resolution:ratio_eps_resolution:2)';
[X, Y] = meshgrid(ratio_eps, ratio_N);
exp_results = 1 - Y .* (1 - 2 * X * eps_left) / (1 - 2 * eps_left);
arbitrary_low_value = 0.01;
exp_results(abs(exp_results) <= arbitrary_low_value) = 0;
exp_results = sign(exp_results);

sfig = pcolor(exp_results);
set(sfig, 'EdgeColor', 'none');
% could use draw=none on shader in tex manually
%sfig.FaceColor = 'interp';
colormap(prism(5));

xticklabels(cellstr(num2str(cellfun(@(x) str2double(x), xticklabels) * ratio_eps_resolution)));
yticklabels(cellstr(num2str(cellfun(@(x) str2double(x), yticklabels) * ratio_N_resolution)));

xlabel('Right-to-left stubbornness ratio');
ylabel('Right-to-left abundance ratio');
title('Society opinion leaning : to the right ( blue ) or to the left ( red )');
hLegend = legend;
set(hLegend, 'visible', 'off');
plotter.Save('images/eps.ratio.vs.extremists.ratio.expected.tex');
