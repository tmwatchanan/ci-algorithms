global_configs;

x = 0:10:12000;
VD = trapezoidal_shaped (x, VD_params, 1);
D = trapezoidal_shaped (x, D_params, 1);
M = trapezoidal_shaped (x, M_params, 1);
B = trapezoidal_shaped (x, B_params, 1);
VB = trapezoidal_shaped (x, VB_params, 1);
figure('Name', 'Membership Functions of Environment Light Level Fuzzy Sets', "Position", [0,0,1000,500], 'NumberTitle', 'off');
plot(x,VD, 'LineWidth', 2, ['r;Very Dark fuzzy set params = '  mat2str(VD_params) ';']);
hold on;
plot(x,D, 'LineWidth', 2, ['g;Dark fuzzy set params = '  mat2str(D_params) ';']);
hold on;
plot(x,M, 'LineWidth', 2, ['b;Medium fuzzy set params = '  mat2str(M_params) ';']);
hold on;
plot(x,B, 'LineWidth', 2, ['c;Bright fuzzy set params = '  mat2str(B_params) ';']);
hold on;
plot(x,VB, 'LineWidth', 2, ['m;Very Bright fuzzy set params = '  mat2str(VB_params) ';']);
title('Membership Function of Environment Light Level Fuzzy Sets', 'fontsize', 16)
xlabel('Brightness Level (%)', 'FontWeight', 'bold', 'fontsize', 14);
ylabel('Degree of Membership', 'FontWeight', 'bold', 'fontsize', 14);
ylim([-0.00 1.25]);
grid;