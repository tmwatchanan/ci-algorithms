global_configs;
save_figure_name = "membership_function_light_level_fuzzy_sets.png";

x = 0:10:12000;
VD = trapezoidal_shaped (x, VeryDark_params, e);
D = trapezoidal_shaped (x, Dark_params, e);
M = trapezoidal_shaped (x, Medium_params, e);
B = trapezoidal_shaped (x, Bright_params, e);
VB = trapezoidal_shaped (x, VeryBright_params, e);
figure('Name', 'Membership Functions of Environment Light Level Fuzzy Sets', "Position", POSITION_FIGURE, 'NumberTitle', 'off');
plot(x,VD, 'LineWidth', 2, ['r;Very Dark fuzzy set params = '  mat2str(VeryDark_params) ';']);
hold on;
plot(x,D, 'LineWidth', 2, ['g;Dark fuzzy set params = '  mat2str(Dark_params) ';']);
hold on;
plot(x,M, 'LineWidth', 2, ['b;Medium fuzzy set params = '  mat2str(Medium_params) ';']);
hold on;
plot(x,B, 'LineWidth', 2, ['c;Bright fuzzy set params = '  mat2str(Bright_params) ';']);
hold on;
plot(x,VB, 'LineWidth', 2, ['m;Very Bright fuzzy set params = '  mat2str(VeryBright) ';']);
title('Membership Function of Environment Light Level Fuzzy Sets', 'fontsize', 16)
xlabel('Brightness Level (%)', 'FontWeight', 'bold', 'fontsize', 14);
ylabel('Degree of Membership', 'FontWeight', 'bold', 'fontsize', 14);
ylim([-0.00 1.25]);
grid;

% save figure as a file
print([SAVE_FIGURE_DIRNAME '\' save_figure_name],'-dpng', SAVE_FIGURE_SIZE);
