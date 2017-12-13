global_configs;

x = 0:0.1:100;
VL = trapezoidal_shaped (x, VL_params, 1);
L = trapezoidal_shaped (x, L_params, 1);
M = trapezoidal_shaped (x, M_params, 1);
H = trapezoidal_shaped (x, H_params, 1);
VH = trapezoidal_shaped (x, VH_params, 1);
figure('Name', 'Membership Functions of Screen Brightness Fuzzy Sets', "Position", [0,0,1000,500], 'NumberTitle', 'off');
plot(x,VL, 'LineWidth', 2, ['r;Very Low fuzzy set params = '  mat2str(VL_params) ';']);
hold on;
plot(x,L, 'LineWidth', 2, ['g;Low fuzzy set params = '  mat2str(L_params) ';']);
hold on;
plot(x,M, 'LineWidth', 2, ['b;Moderate fuzzy set params = '  mat2str(M_params) ';']);
hold on;
plot(x,H, 'LineWidth', 2, ['c;High fuzzy set params = '  mat2str(H_params) ';']);
hold on;
plot(x,VH, 'LineWidth', 2, ['m;Very High fuzzy set params = '  mat2str(VH_params) ';']);
title('Membership Function of Screen Brightness Fuzzy Sets', 'fontsize', 16)
xlabel('Brightness Level (%)', 'FontWeight', 'bold', 'fontsize', 14);
ylabel('Degree of Membership', 'FontWeight', 'bold', 'fontsize', 14);
ylim([-0.00 1.25]);
grid;