clear; close all; clc;

load('ori_data.mat');
load('res.mat');
I = res.I;
[x, y] = size(I);
R = georefcells([-55 80], [-180 179.5], [x y], 'ColumnsStartFrom', 'north');
cats = categories(I);
num_categories = length(cats)-1;
 
axm = axesm('pcarree');
cm = turbo(num_categories+1);
geoshow(axm, double(I), cm, R);
bordersm('countries', 'k');
geoshow(axm, 'worldcities.shp', 'Marker', '.', 'MarkerEdgeColor', 'k');

set(gcf, 'WindowState', 'maximized');
exportgraphics(axm, 'globe.png', 'Resolution', 300);

% h = findobj(axm, 'HitTest', 'on');
% for i = 1:length(h)
%     set(h(i, 1), 'HitTest', 'off');
% end
% set(axm, 'HitTest', 'on');
% set(axm, 'ButtonDownFcn', {@my_callback, R, ori_data_map, I, cm});

for i = 1:num_categories    
    filter_show_(R, i, cats{i+1}, I, num_categories);
end

function filter_show_(R, i, cat, I, num_categories) 
    axm = axesm('pcarree');
    cm = turbo(num_categories+1);
    title(cat, 'Color', cm(i+1, :));
    if i > 1
        cm(2:i, :) = ones(i - 1, 3);
    end
    cm(i+2:end, :) = ones(num_categories - i, 3);
    geoshow(axm, double(I), cm, R);
    bordersm('countries', 'k');
    geoshow(axm, 'worldcities.shp', 'Marker', '.', 'MarkerEdgeColor', 'k');
    set(gcf, 'WindowState', 'maximized');
    exportgraphics(gcf, sprintf('%s.png', cat), 'Resolution', 300);
    close all;
end

% function my_callback(~, ~, R, climatologies, I, cm)
%     pt = gcpmap;
%     lat = pt(1, 1); x = round(latitudeToIntrinsicY(R, lat));
%     lon = pt(1, 2); y = round(longitudeToIntrinsicX(R, lon));
%     cat = I(x, y);
%     
%     chart(climatologies{x, y}, cat, lat, lon, cm(uint8(cat), :));
% end

% function chart(climatology, cat, lat, lon, color)
%     url = sprintf('https://nominatim.openstreetmap.org/reverse?format=json&lat=%f&lon=%f&zoom=8', lat, lon);
%     city = "";
%     try
%         city = webread(url).display_name;
%     catch
%     end
%     city = append(city, sprintf('(%s)', cat));
%     subt = {sprintf('lat: %.2f, lon: %.2f', lat, lon), ...
%         sprintf('grow season: %d d, snow cover: %d d', climatology.grow_season.length, climatology.grow_season.snow_cover_length)};
%      
%     fig = figure; ax = axes(fig);
%     climate_chart(ax, climatology.monthly, city, color, subt);
% 
% end