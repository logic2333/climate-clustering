clear; clc; 
load('ori_data.mat');
% load('res_month.mat');
[x, y] = size(ori_data_map);
data_mat = zeros(61784, 79);

% draw data from ori_data_map into data_mat
count = 0;
for i = 1:x
    for j = 1:y
        if isstruct(ori_data_map{i, j})
            sprintf('%d, %d', i, j)
            count = count + 1;
            
            % sort the months against temperature to ignore
            % hemisphere of the place
            t_monthly = ori_data_map{i, j}.monthly{:, :};
            t_monthly = sortrows(t_monthly.', 2).';
            
            data_mat(count, 1) = ori_data_map{i, j}.seasonality.annual_temperature_range;
            data_mat(count, 2) = ori_data_map{i, j}.seasonality.diurnal_temperature_range;
            %data_mat(count, 3) = ori_data_map{i, j}.grow_season.accumulated_temperature_10;
            data_mat(count, 3) = ori_data_map{i, j}.grow_season.length;
            data_mat(count, 4) = ori_data_map{i, j}.grow_season.snow_cover_length;
            %data_mat(count, 6) = ori_data_map{i, j}.grow_season.total_precipitation;
            %data_mat(count, 7) = ori_data_map{i, j}.grow_season.mean_temperature;
            data_mat(count, 5) = ori_data_map{i, j}.seasonality.monthly_precipitation_variance;
            data_mat(count, 6) = ori_data_map{i, j}.seasonality.monthly_temperature_variance;
            % summer/winter precipitation percentage in year
            if ori_data_map{i, j}.annual.total_precipitation == 0
                data_mat(count, 7) = (ori_data_map{i, j}.summer.monthly_mean_precipitation > 0);
                data_mat(count, 8) = (ori_data_map{i, j}.winter.monthly_mean_precipitation > 0);
                data_mat(count, 9) = (ori_data_map{i, j}.wet_season.monthly_mean_precipitation > 0);
                data_mat(count, 10) = (ori_data_map{i, j}.dry_season.monthly_mean_precipitation > 0);
            else
                data_mat(count, 7) = single(ori_data_map{i, j}.summer.monthly_mean_precipitation) / single(ori_data_map{i, j}.annual.total_precipitation);
                data_mat(count, 8) = single(ori_data_map{i, j}.winter.monthly_mean_precipitation) / single(ori_data_map{i, j}.annual.total_precipitation);
                data_mat(count, 9) = single(ori_data_map{i, j}.wet_season.monthly_mean_precipitation) / single(ori_data_map{i, j}.annual.total_precipitation);
                data_mat(count, 10) = single(ori_data_map{i, j}.dry_season.monthly_mean_precipitation) / single(ori_data_map{i, j}.annual.total_precipitation);
            end
            % potential evapotranspiration
            % data_mat(count, 11:22) = t_monthly(5, :);            
            data_mat(count, 11) = single(ori_data_map{i, j}.annual.total_precipitation) / 12;
            % precipitation by month
            % ****Months are sorted by temperature, so it does not follow the order of Jan, Feb, Mar, ... 
            data_mat(count, 12:23) = t_monthly(4, :);
            % aridity
            data_mat(count, 24:35) = t_monthly(4, :) - t_monthly(5, :);
            
            data_mat(count, 36) = ori_data_map{i, j}.annual.mean_temperature;
            data_mat(count, 37) = ori_data_map{i, j}.summer.mean_temperature;
            data_mat(count, 38) = ori_data_map{i, j}.winter.mean_temperature;
            data_mat(count, 39) = ori_data_map{i, j}.wet_season.mean_temperature;
            data_mat(count, 40) = ori_data_map{i, j}.dry_season.mean_temperature;

            % mean temp
            data_mat(count, 41:52) = t_monthly(2, :);
            % max temp
            data_mat(count, 53:64) = t_monthly(1, :);
            % min temp
            data_mat(count, 65:76) = t_monthly(3, :);
            % month categories
            % data_mat(count, 73:81) = res.month_count(count, 3:11);
            % geo coordinates
            data_mat(count, 77) = i;
            data_mat(count, 78) = j;
        end
    
    end
end

% data_mat = data_mat(any(data_mat, 2), :);

% standardize in groups by data category

% temperature variance
data_mat(:, 1:2) = zscore(data_mat(:, 1:2), 0, 'all');

% grow/snow season length
data_mat(:, 3:4) = zscore(data_mat(:, 3:4), 0, 'all');

for i = 5:6
    data_mat(:, i) = zscore(data_mat(:, i));
end

% summer/winter/wet/dry precipitation percentage
data_mat(:, 7:10) = zscore(data_mat(:, 7:10), 0, 'all');

% precipitation and evapotranspiration
data_mat(:, 11:23) = zscore(data_mat(:, 11:23), 0, 'all');

data_mat(:, 24:35) = zscore(data_mat(:, 24:35), 0, 'all');

% temperature
data_mat(:, 36:76) = zscore(data_mat(:, 36:76), 0, 'all');

% month categories
% data_mat(:, 73:81) = zscore(data_mat(:, 73:81), 0, 'all');

save('data_mat.mat', 'data_mat');