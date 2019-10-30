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
            matlab2tikz('filename', filename, 'floatFormat', '%.3f');
        end
        
        function [] = SaveDirectlyToTex(this, filename, points)
            fileID = fopen(filename, 'w');
            
            haxis = findobj(gcf, 'type', 'axe');
            xsizes = xlim;
            ysizes = ylim;
            x_label = get(get(haxis, 'xlabel'), 'string');
            y_label = get(get(haxis, 'ylabel'), 'string');
            x_ticks = sprintf('%.3f,', xticks);
            x_ticks = x_ticks(1:end-1);
            x_ticklabels_arr = xticklabels;
            x_ticklabels = sprintf('{%s},', x_ticklabels_arr{:});
            x_ticklabels = x_ticklabels(1:end-1);
            
            history = points.GetHistory();
            ap_times = kron(ones(this.modelParams.N, 1), (1:size(history, 2)));
            colors = kron(ones(size(history, 2), 1), this.markerColor);
            dataToPrint = [ap_times(:)'; history(:)'; colors(:, 1)'; colors(:, 2)'; colors(:, 3)']';
            
            fprintf(fileID, '%%\n%% This file is a direct dump of the collected data\n%%\n\n');
            fprintf(fileID, '\\begin{tikzpicture}\n\n');
            fprintf(fileID, '\t\\begin{axis}[%%\n');
            fprintf(fileID, '\t\twidth=4.521in,\n');
            fprintf(fileID, '\t\theight=3.566in,\n');
            fprintf(fileID, '\t\tat={(0.758in,0.481in)},\n');
            fprintf(fileID, '\t\tscale only axis,\n');
            fprintf(fileID, '\t\txmin=%.3f,\n', xsizes(1));
            fprintf(fileID, '\t\txmax=%.3f,\n', xsizes(2));
            fprintf(fileID, '\t\txtick={%s},\n', x_ticks);
            fprintf(fileID, '\t\txticklabels={%s},\n', x_ticklabels);
            fprintf(fileID, '\t\txlabel style={font=\\color{white!15!black}},\n');
            fprintf(fileID, '\t\txlabel={%s},\n', x_label);
            fprintf(fileID, '\t\tymin=%.3f,\n', ysizes(1));
            fprintf(fileID, '\t\tymax=%.3f,\n', ysizes(2));
            fprintf(fileID, '\t\tylabel style={font=\\color{white!15!black}},\n');
            fprintf(fileID, '\t\tylabel={%s},\n', y_label);
            fprintf(fileID, '\t\taxis background/.style={fill=white},\n');
            fprintf(fileID, '\t\taxis x line*=bottom,\n');
            fprintf(fileID, '\t\taxis y line*=left\n');
            fprintf(fileID, '\t\t]\n');
            fprintf(fileID, '\t\t\\addplot[scatter,%%\n');
            fprintf(fileID, '\t\t\tscatter/@pre marker code/.code={%%\n');
            fprintf(fileID, '\t\t\t\t\\edef\\temp{\\noexpand\\definecolor{mapped color}{rgb}{\\pgfplotspointmeta}}%%\n');
            fprintf(fileID, '\t\t\t\t\\temp\n');
            fprintf(fileID, '\t\t\t\t\\scope[draw=mapped color!80!black,fill=mapped color]%%\n');
            fprintf(fileID, '\t\t\t},%%\n');
            fprintf(fileID, '\t\t\tscatter/@post marker code/.code={%%\n');
            fprintf(fileID, '\t\t\t\t\\endscope\n');
            fprintf(fileID, '\t\t\t},%%\n');
            fprintf(fileID, '\t\t\tonly marks,\n');    
            fprintf(fileID, '\t\t\tmark=*,\n');
            fprintf(fileID, '\t\t\tpoint meta={TeX code symbolic={%%\n');
            fprintf(fileID, '\t\t\t\t\\edef\\pgfplotspointmeta{\\thisrow{R},\\thisrow{G},\\thisrow{B}}%%\n');
            fprintf(fileID, '\t\t\t}},\n');
            fprintf(fileID, '\t\t\t]\n');
            fprintf(fileID, '\t\t\ttable[row sep=crcr]{%%\n');
            fprintf(fileID, '\t\t\tx	y	R	G	B\\\\\n');
            fprintf(fileID, '\t\t\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\\\\\n', dataToPrint');
            fprintf(fileID, '\t\t\t};\n\n');
            fprintf(fileID, '\t\\end{axis}\n');
            fprintf(fileID, '\\end{tikzpicture}%%\n');
            
            fclose(fileID);
        end        
    end
end

