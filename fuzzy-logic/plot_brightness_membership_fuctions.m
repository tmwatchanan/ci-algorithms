x = 0:0.1:100;
VL_params = [0 0 5 20];
L_params = [5 20 30 45];
M_params = [30 45 55 70];
H_params = [55 70 80 95];
VH_params = [80 95 100 101];
VL = trapezoidal_shaped (x, VL_params, 1);
L = trapezoidal_shaped (x, L_params, 1);
M = trapezoidal_shaped (x, M_params, 1);
H = trapezoidal_shaped (x, H_params, 1);
VH = trapezoidal_shaped (x, VH_params, 1);
figure('Name', 'Membership Functions of Brightness Fuzzy Sets', "Position", [0,0,1000,500], 'NumberTitle', 'off');
plot(x,VL, 'LineWidth', 2, ['r;Thin fuzzy set params = '  mat2str(VL_params) ';']);
hold on;
plot(x,L, 'LineWidth', 2, ['g;Medium fuzzy set params = '  mat2str(L_params) ';']);
hold on;
plot(x,M, 'LineWidth', 2, ['b;Thick fuzzy set params = '  mat2str(M_params) ';']);
hold on;
plot(x,H, 'LineWidth', 2, ['c;Thick fuzzy set params = '  mat2str(H_params) ';']);
hold on;
plot(x,VH, 'LineWidth', 2, ['m;Thick fuzzy set params = '  mat2str(VH_params) ';']);
title('Membership Function of Brightness Fuzzy Sets', 'fontsize', 16)
xlabel('Brightness Level (%)', 'FontWeight', 'bold', 'fontsize', 14);
ylabel('Degree of Membership', 'FontWeight', 'bold', 'fontsize', 14);
ylim([-0.00 1.25]);
grid;