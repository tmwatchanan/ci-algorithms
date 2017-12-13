% max membership value of all fuzzy sets
e = 1;

% membership functions of light level fuzzy sets
VD_params = [0 0 50 200];
D_params = [100 150 900 950];
M_params = [900 950 2000 2100];
B_params = [2000 2100 10000 11000];
VB_params = [10000 11000 12000 12001];

% membership functions of fog density fuzzy sets
Thin_params = [0 0 0.02 0.05];
Medium_params = [0.03 0.08 0.25 0.3];
Thick_params = [0.20 0.3 3.0 3.1];

% membership functions of brightness fuzzy sets
VL_params = [0 0 5 20];
L_params = [5 20 30 45];
M_params = [30 45 55 70];
H_params = [55 70 80 95];
VH_params = [80 95 100 101];
