classdef Plotter < handle
    %PLOTTER Class to represent the results of the simulations
    
    properties (Access = private)
        modelParams;
        simulationParams;
        
        markerColor;
    end
    
    methods
        function obj = Plotter(modelParams, simulationParams)
            obj.modelParams = modelParams;
            obj.simulationParams = simulationParams;
            obj.markerColor = hsv(modelParams.N);
        end
        
        function [] = Show(this, points)
            history = points.GetHistory();
            ap_times = kron(ones(this.modelParams.N, 1), (1:size(history, 2)));
            colors = kron(ones(size(history, 2), 1), this.markerColor);
            scatter(ap_times(:), history(:), [], colors, '.');
            xlim([0, this.simulationParams.memory_length]);
            ylabel('Opinion range');
            xlabel('Past');
            xticklabels(flip(xticklabels));
            hLegend = legend;
            set(hLegend, 'visible', 'off');
        end
        
        function [] = Save(~, filename)
            cleanfigure('targetResolution', 200);
            matlab2tikz('filename', filename);
        end
    end
end

