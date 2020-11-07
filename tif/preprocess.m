clear; clc;

% under tif folder
% acc_temp_10 = imread('acc_temp_10.tif');
annual_pr = imread('annual_pr.tif');
annual_pr = annual_pr(8:277, :);
annual_temp = imread('annual_temp.tif');
annual_temp = annual_temp(8:277, :);
annual_temp_range = imread('annual_temp_range.tif');
annual_temp_range = annual_temp_range(8:277, :);
diurnal_temp = imread('diurnal_temp_range.tif');
diurnal_temp = diurnal_temp(8:277, :);
grow_season_length = imread('grow_season_length.tif');
grow_season_length = grow_season_length(8:277, :);
% grow_season_pr = imread('grow_season_pr.tif');
% grow_season_temp = imread('grow_season_temp.tif');
pr_seasonal = imread('pr_seasonal.tif');
pr_seasonal = pr_seasonal(8:277, :);
snow_cover = imread('snow_cover.tif');
snow_cover = snow_cover(8:277, :);
summer_pr = imread('summer_pr.tif');
summer_pr = summer_pr(8:277, :);
summer_temp = imread('summer_temp.tif');
summer_temp = summer_temp(8:277, :);
temp_seasonal = imread('temp_seasonal.tif');
temp_seasonal = temp_seasonal(8:277, :);
winter_pr = imread('winter_pr.tif');
winter_pr = winter_pr(8:277, :);
winter_temp = imread('winter_temp.tif');
winter_temp = winter_temp(8:277, :);
wet_temp = imread('wet_temp.tif');
wet_temp = wet_temp(8:277, :);
dry_temp = imread('dry_temp.tif');
dry_temp = dry_temp(8:277, :);
wet_pr = imread('wet_pr.tif');
wet_pr = wet_pr(8:277, :);
dry_pr = imread('dry_pr.tif');
dry_pr = dry_pr(8:277, :);

[x, y] = size(annual_pr);

ori_data_map = cell(x, y);

t = zeros(x, y, 12);
pet = zeros(x, y, 12);
pr = zeros(x, y, 12);
tmax = zeros(x, y, 12);
tmin = zeros(x, y, 12);

for i = 1:12
    tt = imread(sprintf('t%d.tif', i));
    t(:, :, i) = tt(8:277, :);
    tt = imread(sprintf('pet_%d.tif', i));
    pet(:, :, i) = tt(8:277, :);
    tt = imread(sprintf('pr_%d.tif', i));
    pr(:, :, i) = tt(8:277, :);
    tt = imread(sprintf('tmax_%d.tif', i));
    tmax(:, :, i) = tt(8:277, :);
    tt = imread(sprintf('tmin_%d.tif', i));
    tmin(:, :, i) = tt(8:277, :);
end

count = 0;
for i = 1:x
    for j = 1:y
        if any(pet(i, j, :) < 0)
            % the place is sea
            ori_data_map{i, j} = NaN;
        else
            count = count + 1;
            sprintf('%d, %d', i, j)
            t_annual = struct('mean_temperature', temp(annual_temp(i, j)), 'total_precipitation', single(annual_pr(i, j)) / 10);
            t_grow_season = struct('length', cut(grow_season_length(i, j)), 'snow_cover_length', cut(snow_cover(i, j)));
            t_seasonality = struct('annual_temperature_range', single(annual_temp_range(i, j)) / 10, 'diurnal_temperature_range', single(diurnal_temp(i, j)) / 10, ...
                'monthly_temperature_variance', temp_seasonal(i, j), 'monthly_precipitation_variance', pr_seasonal(i, j));
            t_summer = struct('mean_temperature', temp(summer_temp(i, j)), 'monthly_mean_precipitation', single(summer_pr(i, j)) / 10);
            t_winter = struct('mean_temperature', temp(winter_temp(i, j)), 'monthly_mean_precipitation', single(winter_pr(i, j)) / 10);
            t_dry = struct('mean_temperature', temp(dry_temp(i, j)), 'monthly_mean_precipitation', single(dry_pr(i, j)) / 10);
            t_wet = struct('mean_temperature', temp(wet_temp(i, j)), 'monthly_mean_precipitation', single(wet_pr(i, j)) / 10);
            vartypes = cell(1, 12);
            vartypes(:) = {'single'};
            t_monthly_data = table('Size', [5 12], 'VariableTypes', vartypes, ...
                'VariableNames', {'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'}, ...
                'RowNames', {'max_temperature', 'mean_temperature', 'min_temperature', 'precipitation', 'potential_evapotranspiration'});
            for month = 1:12
                t_monthly_data{'max_temperature', month} = temp(tmax(i, j, month));
                t_monthly_data{'mean_temperature', month} = t(i, j, month);
                t_monthly_data{'min_temperature', month} = temp(tmin(i, j, month));
                t_monthly_data{'precipitation', month} = single(pr(i, j, month)) / 10;
                t_monthly_data{'potential_evapotranspiration', month} = pet(i, j, month);
                % aridity index is defined in this way but it's hard to use due
                % to infinity values, may have ways to get around
                % t_monthly_data{'aridity', month} = t_monthly_data{'precipitation', month} / t_monthly_data{'potential_evapotranspiration', month};
            end
            ori_data_map{i, j} = struct('annual', t_annual, 'grow_season', t_grow_season, 'seasonality', t_seasonality, ...
                'summer', t_summer, 'winter', t_winter, 'dry_season', t_dry, 'wet_season', t_wet, 'monthly', t_monthly_data);
        end
    end
end

count
save('ori_data.mat', 'ori_data_map');

function t = cut(t1)
    t = min(t1, 365);
end

function t = temp(t1)
    t = single(t1) / 10 - 273.15;
end