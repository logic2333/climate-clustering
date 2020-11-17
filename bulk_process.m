
clear; clc;

listing = dir;
l = length(listing);
mask = [];
for i = 1:l
    if dir_filter(listing(i, 1))
        mask = [mask i];
    end
end
listing = listing(mask);

l = length(listing);
eval_res = zeros(l, 4);
model_names = strings(l, 1);

load('data_mat.mat');
load('pca_mat.mat');
load('ori_data.mat');
load('res_koppen.mat');
kp = res.I;
load('res_vegetation.mat');
veg = res.I;
a = 270; b = 719;

fprintf('Preparation done. %d models to train\n', l);

for i = 1:l
    tic
    model_names(i, 1) = string(listing(i).name);
    disp(append(sprintf('\nTraining Model #%d: ', i), model_names(i, 1)));
    work_dir = append(model_names(i, 1), '/');
    I = ones(a, b);
    res = struct();
    
    if contains(model_names(i, 1), 'medoids')
        continue
%         data = data_mat;
%         if contains(model_names(i, 1), 'pca')
%             data = pca_mat;
%         end
%         t = char(model_names(i, 1));
%         num_categories = str2double(t(1:2));
%         [idx, ~, ~, ~, centroid_idx] = kmedoids(data(:, 1:end-3), num_categories, 'Distance', 'euclidean', 'Options', statset('UseParallel', true));
%         centroids = [0 0; data(centroid_idx, end-2:end-1)];
%         for j = 1:length(idx)
%             I(data(j, end-2), data(j, end-1)) = idx(j, 1) + 1;
%         end
%         res = struct('I', I, 'centroids', centroids);
        
    elseif contains(model_names(i, 1), 'som')
        data = data_mat;
        if contains(model_names(i, 1), 'pca')
            data = pca_mat;
        end
        data_train = data(:, 1:end-3);
        x = data_train';
        num_records = size(data_train, 1);   % 61784
        t = split(model_names(i, 1), '_');
        t = char(t(2));
        neurons = [];
        for j = 1:length(t)
            neurons = [neurons str2double(t(j))];
        end
        num_categories = prod(neurons, 'all');
        net = selforgmap(neurons);
        if contains(model_names(i, 1), 'grid')
            net = selforgmap(neurons, 100, 3, 'gridtop');
        end
        net.plotFcns = {};
        net.trainParam.epochs = 1000;
        net.trainParam.show = NaN;
        net = train(net, x);
        y = net(x);
        
        cats = 2:1+num_categories;

        centers = net.IW{1, 1};
        centroids = zeros(1+num_categories, 2);
        
        for j = 1:num_records
            cat = cats * y(:, j);
            I(data(j, end-2), data(j, end-1)) = cat;
            data(j, end) = cat;
        end
        
        for j = 2:1+num_categories
            subset = data(data(:, end) == j, :);
            idx = knnsearch(subset(:, 1:end-3), centers(j-1, :));
            centroids(j, :) = subset(idx, end-2:end-1);
        end
        
        res = struct('I', I, 'centroids', centroids);

    end
    
    save(append(work_dir, 'res.mat'), 'res');
    
    disp(append('Model ', model_names(i, 1), ' trained. Plotting...'));
    toc
    bulk_plot(res, ori_data_map, a, b, work_dir);

    disp(append('Model ', model_names(i, 1), ' plotted. Evaluating...'));
    toc
    eval_res(i, 1) = homogeneity(veg, res.I, false, true);
    eval_res(i, 2) = my_silhouette(data_mat, res.I);
    eval_res(i, 3) = homogeneity(kp, res.I, true, false);
    fprintf('Model #%d %s score: %f %f %f\n', i, model_names(i, 1), eval_res(i, 1), eval_res(i, 2), eval_res(i, 3));
    toc
end

eval_res(:, 4) = eval_res(:, 1) * 2 + eval_res(:, 2);
T = table(model_names, eval_res(:, 1), eval_res(:, 2), eval_res(:, 3), eval_res(:, 4), ...
    'VariableNames', {'Model', 'homogeneity with vegetation', 'silhouette', 'similarity with Koppen', 'total score'});
T = sortrows(T, {'total score', 'homogeneity with vegetation', 'silhouette', 'similarity with Koppen'}, {'descend', 'descend', 'descend', 'descend'});
save('eval_res.mat', 'T');


function val = my_silhouette(dat, I)
    X = dat(:, 1:end-3);
    num_records = size(X, 1);
    clust = zeros(num_records, 1);
    for i = 1:num_records
        clust(i, 1) = I(dat(i, end-2), dat(i, end-1));
    end
    eva = evalclusters(X, clust, 'silhouette', 'Distance', 'Euclidean', 'ClusterPriors', 'equal');
    val = eva.CriterionValues(1);
end

function bulk_plot(res, ori_data_map, a, b, work_dir)
    R = georefcells([-55 80], [-180 179.5], [a b], 'ColumnsStartFrom', 'north');
    close all;
    
    I = res.I;
    centroids = geopoint(intrinsicYToLatitude(R, res.centroids(:, 1)), intrinsicXToLongitude(R, res.centroids(:, 2)));
    num_categories = length(centroids) - 1;

    axm = axesm('pcarree');
    %set(gcf, 'Visible', 'off');
    ocean_color = [0.1900 0.0718 0.2322];
    cm = [ocean_color; turbo(num_categories)];
    geoshow(axm, uint8(I), cm, R);
    bordersm('countries', 'k');
    geoshow(axm, 'worldcities.shp', 'Marker', '.', 'MarkerEdgeColor', 'k');
    for i = 2:num_categories+1
        color = [1 1 1] - cm(i, :);
        textm(centroids.Latitude(i), centroids.Longitude(i), sprintf('%d', i-1), 'Color', color, 'FontSize', 8);
        geoshow(axm, centroids(i), 'Marker', 'diamond', 'MarkerEdgeColor', color, 'MarkerSize', 6);
    end

    set(gcf, 'WindowState', 'maximized');
    exportgraphics(axm, append(work_dir, 'globe.png'), 'Resolution', 300);
    close all;
    
    for i = 2:num_categories+1
        chart(ori_data_map{res.centroids(i, 1), res.centroids(i, 2)}, i, ...
            centroids.Latitude(i), centroids.Longitude(i), cm(i, :), true, work_dir);
        close all;
    end
    
    for cat = 1:num_categories
        filter_show(R, cat, res, work_dir);
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