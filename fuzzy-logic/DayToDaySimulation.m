%clear all;
close all;
global_configs;

x = 8:0.0895:24;
illuminance_inputs = [0:100:9000 9000:-100:800 800:-200:0];
lwc_inputs = [zeros(1,170) 0.02:0.35:3];
y = [];
for i = 1:length(illuminance_inputs)
  out = abd_fuzzy_control (lwc_inputs(i), illuminance_inputs(i));
  y = [y out];
endfor

% plot figure
figure('Name', "Simulation from 8:00 to 24:00 -> Illuminance & Brightness", 'Position', POSITION_FIGURE, 'NumberTitle', 'off');
subplot (2, 1, 1)
[ax1, h1, h2] = plotyy (x, y, x, lwc_inputs);
title('Day-to-day simulation', 'fontsize', 16)
set(ax1(2),'ycolor','g')
set(h2,'Color','g')
set([h1 h2],'LineWidth',2);
xlabel('Time from 8:00 to 24:00', 'FontWeight', 'bold', 'fontsize', 14);
ylabel(ax1(1), 'Brightness Level (%)', 'FontWeight', 'bold', 'fontsize', 14);
ylabel(ax1(2), 'LWC (g/m^3)', 'FontWeight', 'bold', 'fontsize', 14);
axis ("tic", "labelx");
subplot (2, 1, 2)
[ax2, h3, h4] = plotyy (x, y, x, illuminance_inputs);
set(ax2(2),'ycolor','m')
set(h4,'Color','m')
set([h3 h4],'LineWidth',2);
xlabel('Time from 8:00 to 24:00', 'FontWeight', 'bold', 'fontsize', 14);
ylabel(ax2(1), 'Brightness Level (%)', 'FontWeight', 'bold', 'fontsize', 14);
ylabel(ax2(2), 'Light Level (lux)', 'FontWeight', 'bold', 'fontsize', 14);
axis ([8, 24]);

save_figure_name = "day-to-day-sim-8-to-24";
print([SAVE_SIMULATION_FIGURE_DIRNAME '\' save_figure_name],'-dpng', SAVE_FIGURE_SIZE);
