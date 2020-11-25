close all; clear; clc;

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
eval_res = zeros(l, 3);
model_names = strings(l, 1);

load('data_mat.mat');
load('pca_mat.mat');
load('ori_data.mat');
load('res_koppen.mat');
kp = res.I;
load('res_vegetation.mat');
veg = res.I;
a = 270; b = 719;
alpha = 2.29;

fprintf('Preparation done. %d model(s) to train\n', l);

for i = 1:l
    model_names(i, 1) = string(listing(i).name);
    disp(append(sprintf('\nTraining Model #%d: ', i), model_names(i, 1)));
    tic
    work_dir = append(model_names(i, 1), '/');
    I = ones(a, b);
    res = struct();
    data = data_mat;
    
    if contains(model_names(i, 1), 'medoids')
        if contains(model_names(i, 1), 'pca')
            data = pca_mat;
        end
        t = char(model_names(i, 1));
        num_categories = str2double(t(1:2));
        [idx, ~, ~, ~, centroid_idx] = kmedoids(data(:, 1:end-3), num_categories, 'Distance', 'euclidean', 'Options', statset('UseParallel', true), 'PercentNeighbors', 0.01);
        centroids = [0 0; data(centroid_idx, end-2:end-1)];
        for j = 1:length(idx)
            I(data(j, end-2), data(j, end-1)) = idx(j, 1) + 1;
        end
        res = struct('I', I, 'centroids', centroids);
        
    elseif contains(model_names(i, 1), 'som')
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
    eval_res(i, 1) = homogeneity(veg, res.I, false, alpha);
    eval_res(i, 2) = my_silhouette(data_mat, res.I, true);
    eval_res(i, 3) = homogeneity(kp, res.I, true, 0);
    fprintf('Model #%d %s score: %f %f %f\n', i, model_names(i, 1), eval_res(i, 1), eval_res(i, 2), eval_res(i, 3));
    toc
end


T = table(model_names, eval_res(:, 1), eval_res(:, 2), eval_res(:, 3), ...
    'VariableNames', {'Model', 'homogeneity with vegetation', 'silhouette', 'similarity with Koppen'});
T = sortrows(T, {'homogeneity with vegetation', 'silhouette', 'similarity with Koppen'}, {'descend', 'descend', 'descend'});
writetable(T, 'eval_res.xlsx');
fprintf('All done. Evaluation scores saved in eval_res.xlsx.\n');
