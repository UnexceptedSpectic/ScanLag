function [out, outStruct] = optimal_pixel_range(path_vectors)
% - optimal_pixel_range finds the pixel range along the colony area (pixels) vs time
%   curve that results in the minimum standard deviation
% - path_vectors is a string vector of directories to plates of the same strain

%singles = 0:200;
%doubles = 0:2:400;
%window_maxes = doubles(singles >= 25);
%window_mins = singles(singles >= 25);
window_mins = [25 50 75 100];
window_maxes = window_mins * 2;
min_percent_std = inf;

for ind = 1:length(window_maxes)
    window_max = window_maxes(ind);
    window_min = window_mins(ind);
    data = getAppearanceGrowth(path_vectors, window_min, window_max);
    stdev = std(rmoutliers(data.growth));
    growth_mean = mean(rmoutliers(data.growth));
    percent_std = stdev/growth_mean;
    if percent_std < min_percent_std
        min_percent_std = percent_std;
        ideal_min = window_min;
        ideal_max = window_max;
        ideal_mean = growth_mean;
        ideal_std = stdev;        
        growth = rmoutliers(data.growth);
        n = length(rmoutliers(data.growth));
    end
end

out = ["min std" "growth mean (doubling time (days))" "pixel min" "pixel max" "percent std" "number of colonies used"; ideal_std ideal_mean ideal_min ideal_max min_percent_std n];
outStruct = struct;
outStruct.minStd = ideal_std;
outStruct.growthMean = ideal_mean;
outStruct.pixelMin = ideal_min;
outStruct.pixelMax = ideal_max;
outStruct.percentStd = min_percent_std;
outStruct.growth = growth; 

end
