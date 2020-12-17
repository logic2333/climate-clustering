function bulk_plot(res, ori_data_map, a, b, work_dir)
    R = georefcells([-55 80], [-180 179.5], [a b], 'ColumnsStartFrom', 'north');
    close all;
    
    I = res.I;
    centroids = geopoint(intrinsicYToLatitude(R, res.centroids(:, 1)), intrinsicXToLongitude(R, res.centroids(:, 2)));
    num_categories = length(centroids) - 1;
    invalid_cats = [];
    for i = 2:num_categories+1
        if isempty(I(I == i))
            invalid_cats = [invalid_cats i];
        end
    end

    axm = axesm('pcarree');
    %set(gcf, 'Visible', 'off');
    ocean_color = [0.1900 0.0718 0.2322];
    cm = [ocean_color; turbo(num_categories)];
    geoshow(axm, uint8(I), cm, R);
    bordersm('countries', 'k');
    geoshow(axm, 'worldcities.shp', 'Marker', '.', 'MarkerEdgeColor', 'k');
    for i = 2:num_categories+1
        if ~ismember(i, invalid_cats)
            color = [1 1 1] - cm(i, :);
            textm(centroids.Latitude(i), centroids.Longitude(i), sprintf('%d', i-1), 'Color', color, 'FontSize', 8);
            geoshow(axm, centroids(i), 'Marker', 'diamond', 'MarkerEdgeColor', color, 'MarkerSize', 6);
        end
    end

    set(gcf, 'WindowState', 'maximized');
    exportgraphics(axm, append(work_dir, 'globe.png'), 'Resolution', 300);
    close all;
    
    for i = 2:num_categories+1
        if ~ismember(i, invalid_cats)
            chart(ori_data_map{res.centroids(i, 1), res.centroids(i, 2)}, i, ...
                centroids.Latitude(i), centroids.Longitude(i), cm(i, :), true, work_dir);
            close all;
        end
    end
    
    for cat = 1:num_categories
        if ~ismember(cat+1, invalid_cats)
            filter_show(R, cat, res, work_dir);
        end
        % Below code doesn't work
        % Strangely it has to be an outside function
%         axm = axesm('pcarree');
%         %set(gcf, 'Visible', 'off');
%         cm = turbo(num_categories);
%         if cat > 1
%             cm(2:cat, :) = ones(cat - 1, 3);
%         end
%         cm(cat+2:end, :) = ones(num_categories - cat - 1, 3);
%         geoshow(axm, uint8(I), cm, R);
%         bordersm('countries', 'k');
%         geoshow(axm, 'worldcities.shp', 'Marker', '.', 'MarkerEdgeColor', 'k');
%         color = [1 1 1] - cm(cat+1, :);
%         textm(centroids.Latitude(cat+1), centroids.Longitude(cat+1), sprintf('%d', cat), 'Color', color, 'FontSize', 8);
%         geoshow(axm, centroids(cat+1), 'Marker', 'diamond', 'MarkerEdgeColor', color, 'MarkerSize', 6);
%         set(gcf, 'WindowState', 'maximized');
%         exportgraphics(gcf, append(work_dir, sprintf('%d_.png', cat)), 'Resolution', 300);
%         close all;
    end
    
    for i = 1:num_categories
        if ~ismember(i+1, invalid_cats)
            back = imread(append(work_dir, sprintf('%d_.png', i)));
            front = imread(append(work_dir, sprintf('%d.png', i)));
            height_back = size(back, 1);
            % width_back = size(back, 2);
            height_front = size(front, 1);
            width_front = size(front, 2);
            back(height_back - height_front + 1:end, 1:width_front, :) = front;
            delete(append(work_dir, sprintf('%d_.png', i)));
            delete(append(work_dir, sprintf('%d.png', i)));
            imwrite(back, append(work_dir, sprintf('A%d.png', i)));
        end
    end
end

function chart(climatology, cat, lat, lon, color, capture, work_dir)
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
        exportgraphics(fig, append(work_dir, sprintf('%d.png', cat-1)));
    else
        fig = figure; ax = axes(fig);
        climate_chart(ax, climatology.monthly, city, color, subt);
    end
end