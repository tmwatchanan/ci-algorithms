clear all; % for re-define global variables

% max membership value of all fuzzy sets
global e = 1;

% membership functions of light level fuzzy sets
global LightLevel;
LightLevel.fuzzy_sets = {"VeryDark"; "Dark"; "Medium"; "Bright"; "VeryBright"};
LightLevel.VeryDark.params = [0 0 50 200];
LightLevel.Dark.params = [100 150 900 950];
LightLevel.Medium.params = [900 950 2000 2100];
LightLevel.Bright.params = [2000 2100 10000 11000];
LightLevel.VeryBright.params = [10000 11000 12000 12001];

% membership functions of fog density fuzzy sets
global FogDensity;
FogDensity.fuzzy_sets = {"Thin"; "Medium"; "Thick"};
FogDensity.Thin.params = [0 0 0.02 0.05];
FogDensity.Medium.params = [0.03 0.08 0.25 0.3];
FogDensity.Thick.params = [0.20 0.3 3.0 3.1];

% membership functions of brightness fuzzy sets
global Brightness;
Brightness.fuzzy_sets = {"VeryLow"; "Low"; "Moderate"; "High"; "VeryHigh"};
Brightness.VeryLow.params = [0 0 5 20];
Brightness.VeryLow.mode = get_center_of_trapezoidal_shaped(Brightness.VeryLow.params);
Brightness.Low.params = [5 20 30 45];
Brightness.Low.mode = get_center_of_trapezoidal_shaped(Brightness.Low.params);
Brightness.Moderate.params = [30 45 55 70];
Brightness.Moderate.mode = get_center_of_trapezoidal_shaped(Brightness.Moderate.params);
Brightness.High.params = [55 70 80 95];
Brightness.High.mode = get_center_of_trapezoidal_shaped(Brightness.High.params);
Brightness.VeryHigh.params = [80 95 100 101];
Brightness.VeryHigh.mode = get_center_of_trapezoidal_shaped(Brightness.VeryHigh.params);

% file configs
global SAVE_FIGURE_DIRNAME = 'figures';
global POSITION_FIGURE = [0,0,1000,500];
global SAVE_FIGURE_SIZE = '-S1000,500';
