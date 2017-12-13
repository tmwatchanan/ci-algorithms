global_configs;

x = 0:0.1:3;
Thin = trapezoidal_shaped (x, Thin_const, 1);
Medium = trapezoidal_shaped (x, Medium_const, 1);
Thick = trapezoidal_shaped (x, Thick_const, 1);
figure('Name', 'Membership Functions of Fog Fuzzy Sets', "Position", [0,0,1000,500], 'NumberTitle', 'off');
plot(x,Thin, 'LineWidth', 2, ['r;Thin fuzzy set params = '  mat2str(Thin_params) ';']);
hold on;
plot(x,Medium, 'LineWidth', 2, ['g;Medium fuzzy set params = '  mat2str(Medium_params) ';']);
hold on;
plot(x,Thick, 'LineWidth', 2, ['b;Thick fuzzy set params = '  mat2str(Thick_params) ';']);
title('Membership Function of Thin, Medium and Thick Fog Fuzzy Set', 'fontsize', 16)
xlabel('LWC (g/m^3)', 'FontWeight', 'bold', 'fontsize', 14);
ylabel('Degree of Membership', 'FontWeight', 'bold', 'fontsize', 14);
ylim([-0.00 1.15]);
grid;