global_configs;
save_figure_name = "membership_function_screen_brightness_fuzzy_sets.png";

x = 0:0.1:100;
VL = trapezoidal_shaped (x, VeryLow_params, e);
L = trapezoidal_shaped (x, Low_params, e);
M = trapezoidal_shaped (x, Moderate_params, e);
H = trapezoidal_shaped (x, High_params, e);
VH = trapezoidal_shaped (x, VeryHigh_params, e);
figure('Name', 'Membership Functions of Screen Brightness Fuzzy Sets', "Position", POSITION_FIGURE, 'NumberTitle', 'off');
plot(x,VL, 'LineWidth', 2, ['r;Very Low fuzzy set params = '  mat2str(VeryLow_params) ';']);
hold on;
plot(x,L, 'LineWidth', 2, ['g;Low fuzzy set params = '  mat2str(Low_params) ';']);
hold on;
plot(x,M, 'LineWidth', 2, ['b;Moderate fuzzy set params = '  mat2str(Moderate_params) ';']);
hold on;
plot(x,H, 'LineWidth', 2, ['c;High fuzzy set params = '  mat2str(High_params) ';']);
hold on;
plot(x,VH, 'LineWidth', 2, ['m;Very High fuzzy set params = '  mat2str(VeryHigh_params) ';']);
title('Membership Function of Screen Brightness Fuzzy Sets', 'fontsize', 16)
xlabel('Brightness Level (%)', 'FontWeight', 'bold', 'fontsize', 14);
ylabel('Degree of Membership', 'FontWeight', 'bold', 'fontsize', 14);
ylim([-0.00 1.25]);
grid;

% save figure as a file
print([SAVE_FIGURE_DIRNAME '\' save_figure_name],'-dpng', SAVE_FIGURE_SIZE);
