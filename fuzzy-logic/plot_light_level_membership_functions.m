x = 0:10:12000;
VD_params = [0 0 50 200];
D_params = [100 150 900 950];
M_params = [900 950 2000 2100];
B_params = [2000 2100 10000 11000];
VB_params = [10000 11000 12000 12001];
VL = trapezoidal_shaped (x, VD_params, 1);
L = trapezoidal_shaped (x, D_params, 1);
M = trapezoidal_shaped (x, M_params, 1);
H = trapezoidal_shaped (x, B_params, 1);
VH = trapezoidal_shaped (x, VB_params, 1);
figure('Name', 'Membership Functions of Environment Light Level Fuzzy Sets', "Position", [0,0,1000,500], 'NumberTitle', 'off');
plot(x,VL, 'LineWidth', 2, ['r;Thin fuzzy set params = '  mat2str(VD_params) ';']);
hold on;
plot(x,L, 'LineWidth', 2, ['g;Medium fuzzy set params = '  mat2str(D_params) ';']);
hold on;
plot(x,M, 'LineWidth', 2, ['b;Thick fuzzy set params = '  mat2str(M_params) ';']);
hold on;
plot(x,H, 'LineWidth', 2, ['c;Thick fuzzy set params = '  mat2str(B_params) ';']);
hold on;
plot(x,VH, 'LineWidth', 2, ['m;Thick fuzzy set params = '  mat2str(VB_params) ';']);
title('Membership Function of Environment Light Level Fuzzy Sets', 'fontsize', 16)
xlabel('Brightness Level (%)', 'FontWeight', 'bold', 'fontsize', 14);
ylabel('Degree of Membership', 'FontWeight', 'bold', 'fontsize', 14);
ylim([-0.00 1.25]);
grid;