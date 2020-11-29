clear; clc;

dict = [0 32 13 14 7 2 1 19 33 20 8 28 15 3 4 9 34 22 16 30 35 17 23 29 10 12 5];
cats = ["", "Subarctic-Cold Temperate Oceanic/Oceanic Tundra", "Subarctic", "Cold Temperate", ...
    "Arctic Tundra(Continental)", "Arctic Icecap(Oceanic)", "Arctic Icecap(Continental)", ...
    "Subarctic-Cold Temperate Monsoonal", "Cool Temperate Oceanic", "Cool Temperate", ...
    "Cool and Wet Mediterranean/Cool Temperate Dry-summer", ...
    "Cool Temperate Suboceanic/Cool-warm Temperate Transitional(Oceanic)", ...
    "Cool Temperate Steppe", "Continental Mediterranean/Warm Temperate Steppe(Winter-rain)", ...
    "Classic Mediterranean/Subtropical Dry-summer", "Cold Desert/Cool Temperate Arid(Summer-rain)", ...
    "Warm Temperate Oceanic", "Warm Temperate", "Warm Temperate Monsoonal", "Subtropical Monsoonal(Humid)", ...
    "Tropical Rainforest", "Mild Savanna/Subtropical Dry-wet Season", "Tropical Monsoonal(Humid)", ...
    "Hot Savanna/Tropical Dry-wet Season", "Mild Hot Desert/Oasis/Subtropical Arid", ...
    "Hot Steppe/Tropical Semi-arid", "Hot Desert/Tropical Arid"];


T = readtable('stat_veg.xlsx', 'ReadRowNames', true, 'ReadVariableNames', true);
T(1, :) = [];
veg_names = T.Properties.RowNames;
subts = strings(1, 27);
for i = 2:27
    range = T{:, sprintf('x%d', dict(i))};
    [B, I] = maxk(range, 3);
    B(B < 0.1) = [];
    subt = "";
    for j = 1:length(B)
        subt = append(subt, veg_names{I(j), 1}, sprintf(' %.1f%%, ', 100 * B(j)));
    end
    subt = char(subt);
    subts(i) = subt(1:end-2);
end


load('res.mat');

dict = dict + 1;
I = res.I;
I(I ~= 1) = I(I ~= 1) + 40;
for i = 2:27
    I(I == 40 + dict(i)) = i;
end
res.I = I;

centroids = zeros(27, 2);
for i = 2:length(centroids)
    centroids(i, :) = res.centroids(dict(i), :);
end
res.centroids = centroids;
save('res_final.mat', 'res');


[x, y] = size(I);
R = georefcells([-55 80], [-180 179.5], [x y], 'ColumnsStartFrom', 'north');
centroids = geopoint(intrinsicYToLatitude(R, centroids(:, 1)), intrinsicXToLongitude(R, centroids(:, 2)));
num_categories = 26;
 
axm = axesm('pcarree');
cm = turbo(num_categories+1);
% Legend is too ugly; prefer not to show
% for i = 2:num_categories+1
%     scatter([], [], 1, cm(i, :), 'filled', 'DisplayName', cats(i));
% end
% legend('Location', 'southoutside', 'Orientation', 'horizontal');
geoshow(axm, I, cm, R);
bordersm('countries', 'k');
geoshow(axm, 'worldcities.shp', 'Marker', '.', 'MarkerEdgeColor', 'k');
for i = 2:num_categories+1
    color = [1 1 1] - cm(i, :);
    textm(centroids.Latitude(i), centroids.Longitude(i), sprintf('%d', i-1), 'Color', color, 'FontSize', 8);
    geoshow(axm, centroids(i), 'Marker', 'diamond', 'MarkerEdgeColor', color, 'MarkerSize', 6);
end
set(gcf, 'WindowState', 'maximized');
exportgraphics(axm, 'globe.png', 'Resolution', 300);
close all;
    
load('ori_data.mat');
for i = 2:num_categories+1
    chart(ori_data_map{res.centroids(i, 1), res.centroids(i, 2)}, i, ...
        centroids.Latitude(i), centroids.Longitude(i), cm(i, :));
    close all;
end
% h = findobj(axm, 'HitTest', 'on');
% for i = 1:length(h)
%     set(h(i, 1), 'HitTest', 'off');
% end
% set(axm, 'HitTest', 'on');
% set(axm, 'ButtonDownFcn', {@my_callback, R, ori_data_map, I, cm});

for i = 1:num_categories    
    filter_show_(R, i, cats(i+1), subts(i+1), I, centroids(i+1), num_categories);
end

for i = 1:num_categories        
    back = imread(sprintf('%d_.png', i));
    front = imread(sprintf('%d.png', i));
    height_back = size(back, 1);
    % width_back = size(back, 2);
    height_front = size(front, 1);
    width_front = size(front, 2);
    back(height_back - height_front + 1:end, 1:width_front, :) = front;
    delete(sprintf('%d_.png', i));
    delete(sprintf('%d.png', i));
    imwrite(back, sprintf('%d_%s.png', i, replace(cats(i+1), '/', '_')));
end


function filter_show_(R, i, cat, subt, I, centroid, num_categories) 
    axm = axesm('pcarree');
    cm = turbo(num_categories+1);
    title(cat, 'Color', cm(i+1, :));
    subtitle(subt);
    if i > 1
        cm(2:i, :) = ones(i - 1, 3);
    end
    cm(i+2:end, :) = ones(num_categories - i, 3);
    geoshow(axm, I, cm, R);
    bordersm('countries', 'k');
    geoshow(axm, 'worldcities.shp', 'Marker', '.', 'MarkerEdgeColor', 'k');
    text_color = [1 1 1] - cm(i+1, :);
    textm(centroid.Latitude, centroid.Longitude, sprintf('%d', i), 'Color', text_color, 'FontSize', 8);
    geoshow(axm, centroid, 'Marker', 'diamond', 'MarkerEdgeColor', text_color, 'MarkerSize', 6);
    set(gcf, 'WindowState', 'maximized');
    exportgraphics(gcf, sprintf('%d_.png', i), 'Resolution', 300);
    close all;
end


function chart(climatology, cat, lat, lon, color)
    url = sprintf('https://nominatim.openstreetmap.org/reverse?format=json&lat=%f&lon=%f&zoom=8', lat, lon);
    city = "";
    try
        city = webread(url).display_name;
    catch
    end
    city = append(city, sprintf('(%d)', cat-1));
    subt = {sprintf('lat: %.2f, lon: %.2f', lat, lon), ...
        sprintf('grow season: %d d, snow cover: %d d', climatology.grow_season.length, climatology.grow_season.snow_cover_length)};
    
    fig = figure('visible', 'off'); ax = axes(fig);
    climate_chart(ax, climatology.monthly, city, color, subt);
    exportgraphics(fig, sprintf('%d.png', cat-1));
end