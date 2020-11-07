function filter_show(cat, res)
    R = georefcells([-55 80], [-180 179.5], [270 719], 'ColumnsStartFrom', 'north');
    I = res.I;
    centroid = geopoint(intrinsicYToLatitude(R, res.centroids(cat+1, 1)), intrinsicXToLongitude(R, res.centroids(cat+1, 2)));
    num_categories = max(I, [], 'all');
    
    axm = axesm('pcarree');
    cm = turbo(num_categories);
    if cat > 1
        cm(2:cat, :) = ones(cat - 1, 3);
    end
    cm(cat+2:end, :) = ones(num_categories - cat - 1, 3);
    geoshow(axm, I, cm, R);
    bordersm('countries', 'k');
    geoshow(axm, 'worldcities.shp', 'Marker', '.', 'MarkerEdgeColor', 'k');
    text_color = [1 1 1] - cm(cat+1, :);
    textm(centroid.Latitude, centroid.Longitude, sprintf('%d', cat), 'Color', text_color, 'FontSize', 8);
    geoshow(axm, centroid, 'Marker', 'diamond', 'MarkerEdgeColor', text_color, 'MarkerSize', 6);
    set(gcf, 'WindowState', 'maximized');
    exportgraphics(gcf, sprintf('%d_.png', cat), 'Resolution', 300);
    close all;
end