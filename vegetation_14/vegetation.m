clear; clc;

I = imread('vegetation.tif');
I = I(8:277, :);
I = categorical(I, 0:16, ...
    {'0', 'Evergreen Needleleaves', 'Evergreen Broadleaves', 'Deciduous Needleleaves', 'Deciduous Broadleaves', ...
    'Mixed leaves', 'Closed Shrubs', 'Open Shrubs', 'Woody Savannas', 'Savannas', 'Grassland', 'Wetland', 'Cropland Mosaics', ...
    '0', 'Cropland Mosaics', 'Ice', 'Barren'});
res = struct('I', I);
save('res.mat', 'res');
