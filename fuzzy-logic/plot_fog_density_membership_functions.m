global_configs;
save_figure_name = "membership_function_fog_density_fuzzy_sets.png";

x = 0:0.1:3;
Thin = trapezoidal_shaped (x, FogDensity.Thin.params, e);
Medium = trapezoidal_shaped (x, FogDensity.Medium.params, e);
Thick = trapezoidal_shaped (x, FogDensity.Thick.params, e);
figure('Name', 'Membership Functions of Fog Density Fuzzy Sets', "Position", POSITION_FIGURE, 'NumberTitle', 'off');
plot(x,Thin, 'LineWidth', 2, ['r;Thin fuzzy set params = '  mat2str(FogDensity.Thin.params) ';']);
hold on;
plot(x,Medium, 'LineWidth', 2, ['g;Medium fuzzy set params = '  mat2str(FogDensity.Medium.params) ';']);
hold on;
plot(x,Thick, 'LineWidth', 2, ['b;Thick fuzzy set params = '  mat2str(FogDensity.Thick.params) ';']);
title('Membership Function of Fog Density Fuzzy Set', 'fontsize', 16)
xlabel('LWC (g/m^3)', 'FontWeight', 'bold', 'fontsize', 14);
ylabel('Degree of Membership', 'FontWeight', 'bold', 'fontsize', 14);
ylim([-0.00 1.15]);
grid;

% save figure as a file
print([SAVE_FIGURE_DIRNAME '\' save_figure_name],'-dpng', SAVE_FIGURE_SIZE);
