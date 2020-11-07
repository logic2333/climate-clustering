close all; clear; clc;

a = 270; b = 719;
R = georefcells([-55 80], [-180 179.5], [a b], 'ColumnsStartFrom', 'north');

load('res.mat');
load('ori_data.mat');

I = res.I;
centroids = geopoint(intrinsicYToLatitude(R, res.centroids(:, 1)), intrinsicXToLongitude(R, res.centroids(:, 2)));
num_categories = length(centroids) - 1;

axm = axesm('pcarree');
cm = turbo(num_categories+1);
geoshow(axm, uint8(I), cm, R);
bordersm('countries', 'k');
geoshow(axm, 'worldcities.shp', 'Marker', '.', 'MarkerEdgeColor', 'k');
for i = 2:num_categories+1
    color = [1 1 1] - cm(i, :);
    textm(centroids.Latitude(i), centroids.Longitude(i), sprintf('%d', i-1), 'Color', color, 'FontSize', 8);
    geoshow(axm, centroids(i), 'Marker', 'diamond', 'MarkerEdgeColor', color, 'MarkerSize', 6);
end

set(gcf, 'WindowState', 'maximized');
exportgraphics(axm, 'globe.png', 'Resolution', 300);

h = findobj(axm, 'HitTest', 'on');
for i = 1:length(h)
    set(h(i, 1), 'HitTest', 'off');
end
set(axm, 'HitTest', 'on');
set(axm, 'ButtonDownFcn', {@my_callback, R, ori_data_map, I, cm});

for i = 2:num_categories+1
    chart(ori_data_map{res.centroids(i, 1), res.centroids(i, 2)}, i, ...
        centroids.Latitude(i), centroids.Longitude(i), cm(i, :), true);
end


function my_callback(~, ~, R, climatologies, I, cm)
    pt = gcpmap;
    lat = pt(1, 1); x = round(latitudeToIntrinsicY(R, lat));
    lon = pt(1, 2); y = round(longitudeToIntrinsicX(R, lon));
    cat = I(x, y);
    
    chart(climatologies{x, y}, cat, lat, lon, cm(cat, :), false);
end

function chart(climatology, cat, lat, lon, color, capture)
    url = sprintf('https://nominatim.openstreetmap.org/reverse?format=json&lat=%f&lon=%f&zoom=8', lat, lon);
    city = "";
    try
        city = webread(url).display_name;
    catch
    end
    city = append(city, sprintf('(%d)', cat-1));
    subt = {sprintf('lat: %.2f, lon: %.2f', lat, lon), ...
        sprintf('grow season: %d d, snow cover: %d d', climatology.grow_season.length, climatology.grow_season.snow_cover_length)};
    
    if capture
        fig = figure('visible', 'off'); ax = axes(fig);
        climate_chart(ax, climatology.monthly, city, color, subt);
        exportgraphics(fig, sprintf('%d.png', cat-1));
    else
        fig = figure; ax = axes(fig);
        climate_chart(ax, climatology.monthly, city, color, subt);
    end
end