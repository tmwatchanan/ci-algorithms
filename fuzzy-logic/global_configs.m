clear all;

% max membership value of all fuzzy sets
global e = 1;

% membership functions of light level fuzzy sets
global LightLevel;
global LightLevelFuzzySets = {"VeryDark"; "Dark"; "Medium"; "Bright"; "VeryBright"};
LightLevel.VeryDark.params = [0 0 50 200];
LightLevel.VeryDark.mode = get_center_of_trapezoidal_shaped(LightLevel.VeryDark.params);
LightLevel.Dark.params = [100 150 900 950];
LightLevel.Dark.mode = get_center_of_trapezoidal_shaped(LightLevel.Dark.params);
LightLevel.Medium.params = [900 950 2000 2100];
LightLevel.Medium.mode = get_center_of_trapezoidal_shaped(LightLevel.Medium.params);
LightLevel.Bright.params = [2000 2100 10000 11000];
LightLevel.Bright.mode = get_center_of_trapezoidal_shaped(LightLevel.Bright.params);
LightLevel.VeryBright.params = [10000 11000 12000 12001];
LightLevel.VeryBright.mode = get_center_of_trapezoidal_shaped(LightLevel.VeryBright.params);
LightLevel.Modes = zeros(size(LightLevelFuzzySets,1), 1);
for j = 1:size(LightLevelFuzzySets,1)
  LightLevelModes(j) = LightLevel.(LightLevelFuzzySets{j}).mode;
endfor

% membership functions of fog density fuzzy sets
global FogDensity;
global FogDensityFuzzySets = {"Thin"; "Medium"; "Thick"};
FogDensity.Thin.params = [0 0 0.02 0.05];
FogDensity.Thin.mode = get_center_of_trapezoidal_shaped(FogDensity.Thin.params);
FogDensity.Medium.params = [0.03 0.08 0.25 0.3];
FogDensity.Medium.mode = get_center_of_trapezoidal_shaped(FogDensity.Medium.params);
FogDensity.Thick.params = [0.20 0.3 3.0 3.1];
FogDensity.Thick.mode = get_center_of_trapezoidal_shaped(FogDensity.Thick.params);
FogDensity.Modes = zeros(size(FogDensityFuzzySets,1), 1);
for j = 1:size(FogDensityFuzzySets,1)
  FogDensity.Modes(j) = FogDensity.(FogDensityFuzzySets{j}).mode;
endfor

% membership functions of brightness fuzzy sets
global Brightness;
global BrightnessFuzzySets = {"VeryLow"; "Low"; "Moderate"; "High"; "VeryHigh"};
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
Brightness.Modes = zeros(size(FogDensityFuzzySets,1), 1);
for j = 1:size(BrightnessFuzzySets,1)
  Brightness.Modes(j) = Brightness.(BrightnessFuzzySets{j}).mode;
endfor

% file configs
global SAVE_FIGURE_DIRNAME = 'figures';
global POSITION_FIGURE = [0,0,1000,500];
global SAVE_FIGURE_SIZE = '-S1000,500';
