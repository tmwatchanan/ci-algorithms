global_configs;
save_figure_name = "membership_function_screen_brightness_fuzzy_sets.png";

x = 0:0.1:100;
VL = trapezoidal_shaped (x, Brightness.VeryLow.params, e);
L = trapezoidal_shaped (x, Brightness.Low.params, e);
M = trapezoidal_shaped (x, Brightness.Moderate.params, e);
H = trapezoidal_shaped (x, Brightness.High.params, e);
VH = trapezoidal_shaped (x, Brightness.VeryHigh.params, e);
figure('Name', 'Membership Functions of Screen Brightness Fuzzy Sets', "Position", POSITION_FIGURE, 'NumberTitle', 'off');
plot(x,VL, 'LineWidth', 2, ['r;Very Low fuzzy set params = '  mat2str(Brightness.VeryLow.params) ';']);
hold on;
plot(x,L, 'LineWidth', 2, ['g;Low fuzzy set params = '  mat2str(Brightness.Low.params) ';']);
hold on;
plot(x,M, 'LineWidth', 2, ['b;Moderate fuzzy set params = '  mat2str(Brightness.Moderate.params) ';']);
hold on;
plot(x,H, 'LineWidth', 2, ['c;High fuzzy set params = '  mat2str(Brightness.High.params) ';']);
hold on;
plot(x,VH, 'LineWidth', 2, ['m;Very High fuzzy set params = '  mat2str(Brightness.VeryHigh.params) ';']);
title('Membership Function of Screen Brightness Fuzzy Sets', 'fontsize', 16)
xlabel('Brightness Level (%)', 'FontWeight', 'bold', 'fontsize', 14);
ylabel('Degree of Membership', 'FontWeight', 'bold', 'fontsize', 14);
ylim([-0.00 1.25]);
grid;

% save figure as a file
print([SAVE_FIGURE_DIRNAME '\' save_figure_name],'-dpng', SAVE_FIGURE_SIZE);
