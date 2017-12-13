% max membership value of all fuzzy sets
global e = 1;

% membership functions of light level fuzzy sets
global VeryDark_params = [0 0 50 200];
global Dark_params = [100 150 900 950];
global Medium_params = [900 950 2000 2100];
global Bright_params = [2000 2100 10000 11000];
global VeryBright_params = [10000 11000 12000 12001];

% membership functions of fog density fuzzy sets
global Thin_params = [0 0 0.02 0.05];
global Medium_params = [0.03 0.08 0.25 0.3];
global Thick_params = [0.20 0.3 3.0 3.1];

% membership functions of brightness fuzzy sets
global VeryLow_params = [0 0 5 20];
global Low_params = [5 20 30 45];
global Moderate_params = [30 45 55 70];
global High_params = [55 70 80 95];
global VeryHigh_params = [80 95 100 101];

% file configs
global SAVE_FIGURE_DIRNAME = 'figures';
global POSITION_FIGURE = [0,0,1000,500];
global SAVE_FIGURE_SIZE = '-S1000,500';
