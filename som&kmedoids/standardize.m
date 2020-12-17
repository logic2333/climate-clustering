clear; clc; 

load('ori_data.mat');
[x, y] = size(ori_data_map);
data_mat = zeros(61784, 75);

% draw data from ori_data_map into data_mat
count = 0;
for i = 1:x
    for j = 1:y
        if isstruct(ori_data_map{i, j})
            disp([i j])
            count = count + 1;
           
            t_monthly = ori_data_map{i, j}.monthly{:, :};
            % precipitation-PET correlation
            [data_mat(count, 67), data_mat(count, 68), data_mat(count, 69)] = my_xcorr(t_monthly(4, :), t_monthly(5, :));
            % how many month avg temp >= 10, < 0
            data_mat(count, 70) = sum(t_monthly(2, :) >= 10);
            data_mat(count, 71) = sum(t_monthly(2, :) < 0);
            
            % sort the months against temperature to ignore
            % hemisphere of the place
            t_monthly = sortrows(t_monthly.', 2).';
            
            data_mat(count, 1) = ori_data_map{i, j}.seasonality.annual_temperature_range;
            data_mat(count, 2) = ori_data_map{i, j}.seasonality.diurnal_temperature_range;
            data_mat(count, 3) = ori_data_map{i, j}.grow_season.length;
            data_mat(count, 4) = ori_data_map{i, j}.grow_season.snow_cover_length;
            data_mat(count, 5) = ori_data_map{i, j}.seasonality.monthly_precipitation_variance;
            data_mat(count, 6) = ori_data_map{i, j}.seasonality.monthly_temperature_variance;
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
            data_mat(count, 24) = max(data_mat(count, 12:23));
            data_mat(count, 25) = min(data_mat(count, 12:23));
            % aridity
            data_mat(count, 26:37) = data_mat(count, 12:23) - t_monthly(5, :);
            % how many arid months
            data_mat(count, 72) = sum(data_mat(count, 26:37) < 0);
            
            data_mat(count, 38) = ori_data_map{i, j}.annual.mean_temperature;
            data_mat(count, 39) = ori_data_map{i, j}.summer.mean_temperature;
            data_mat(count, 40) = ori_data_map{i, j}.winter.mean_temperature;
            data_mat(count, 41) = ori_data_map{i, j}.wet_season.mean_temperature;
            data_mat(count, 42) = ori_data_map{i, j}.dry_season.mean_temperature;

            % mean temp
            data_mat(count, 43:54) = t_monthly(2, :);
            % data_mat(count, 55:66) left blank here
%             % max temp
%             data_mat(count, 55:66) = t_monthly(1, :);
%             % min temp
%             data_mat(count, 67:78) = t_monthly(3, :);
            % month categories
            % data_mat(count, 73:81) = res.month_count(count, 3:11);
            % geo coordinates
            data_mat(count, 73) = i;
            data_mat(count, 74) = j;
        end
    
    end
end

% data_mat = data_mat(any(data_mat, 2), :);

% standardize in groups by data category

for i = 1:6
    data_mat(:, i) = sigmoid(zscore(data_mat(:, i), 1), 0, 1);
end

% summer/winter/wet/dry precipitation percentage, enforce center 0.25
sigma = std(data_mat(:, 7:10), 1, 'all');
data_mat(:, 7:10) = sigmoid(data_mat(:, 7:10), 0.25, sigma);

% precipitation
%data_mat(:, 12:23) = sigmoid(zscore(data_mat(:, 12:23), 1, 'all'), 0, 1);
%data_mat(:, 11) = sigmoid(zscore(data_mat(:, 11), 1), 0, 1);
%data_mat(:, 24) = sigmoid(zscore(data_mat(:, 24), 1), 0, 1);
%data_mat(:, 25) = sigmoid(zscore(data_mat(:, 25), 1), 0, 1);
% This may not be appropriate?
data_mat(:, 11:25) = sigmoid(zscore(data_mat(:, 11:25), 1, 'all'), 0, 1);

% aridity, enforce center 0
sigma = std(data_mat(:, 26:37), 1, 'all');
data_mat(:, 26:37) = sigmoid(data_mat(:, 26:37), 0, sigma);

% possibly we can do something more here?
% activate these five temperatures with 0C and 10C?
% no! may duplicate features
% mean of the temperatures may be close to 0 or 10
for i = 38:42
    data_mat(:, i) = sigmoid(zscore(data_mat(:, i), 1), 0, 1);
end

% monthly mean temperature, enforce center 0 and 10
sigma = std(data_mat(:, 43:54), 1, 'all');
data_mat(:, 55:66) = sigmoid(data_mat(:, 43:54), 10, sigma);
data_mat(:, 43:54) = sigmoid(data_mat(:, 43:54), 0, sigma);

% precipitation-PET correlation
for i = 67:68
    data_mat(:, i) = sigmoid(zscore(data_mat(:, i), 1), 0, 1);
end

% month count, enforce center 6 and variance 1
data_mat(:, 70:72) = sigmoid(data_mat(:, 70:72), 6, 1);


% % temperature variance
% data_mat(:, 1:2) = zscore(data_mat(:, 1:2), 1, 'all');
% 
% % grow/snow season length
% data_mat(:, 3:4) = zscore(data_mat(:, 3:4), 1, 'all');
% 
% for i = 5:6
%     data_mat(:, i) = zscore(data_mat(:, i), 1);
% end
% 
% 
% data_mat(:, 7:10) = zscore(data_mat(:, 7:10), 1, 'all');
% 
% 
% % data_mat(:, 11) = zscore(data_mat(:, 11), 1);
% data_mat(:, 11:25) = zscore(data_mat(:, 11:25), 1, 'all');
% 
% 
% data_mat(:, 26:37) = zscore(data_mat(:, 26:37), 1, 'all');
% 
% % temperature
% data_mat(:, 38:78) = zscore(data_mat(:, 38:78), 1, 'all');
% 
% % precipitation-PET correlation
% for i = 79:80
%     data_mat(:, i) = zscore(data_mat(:, i), 1);
% end
% % month categories
% % data_mat(:, 73:81) = zscore(data_mat(:, 73:81), 0, 'all');
% 
% % month count by temperature
% data_mat(:, 82:83) = zscore(data_mat(:, 82:83), 1, 'all');
% % month count by aridity
% data_mat(:, 84) = zscore(data_mat(:, 84), 1);


save('data_mat.mat', 'data_mat');
writematrix(data_mat);

function s = sigmoid(x, u, sigma)
    s = tanh((x - u) / sigma);
end

function [corr0, corr_std, phase_diff] = my_xcorr(p1, p2)
    corrs = zeros(12, 1);
    corrs(6, 1) = p1 * p2';
    for i = 1:6
        p1t = p1;
        p2t = [p2(13-i:12) p2(1:12-i)];
        corrs(6+i, 1) = p1t * p2t';
    end
    for i = 1:5
        p1t = p1;
        p2t = [p2(i+1:12) p2(1:i)];
        corrs(6-i, 1) = p1t * p2t';
    end
    if xcorr(p1, 0) ~= 0 && xcorr(p2, 0) ~= 0
        corrs = corrs / sqrt(xcorr(p1, 0) * xcorr(p2, 0));
    end
    corr0 = corrs(6, 1);
    corr_std = std(corrs, 1);
    [~, I] = max(corrs);
    phase_diff = cos(I*pi/6);
end