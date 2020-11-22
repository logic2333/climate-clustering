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

fprintf('Preparation done. %d model(s) to merge\n', l);

for i = 1:l
    model_names(i, 1) = string(listing(i).name);
    disp(append(sprintf('\nMerging Model #%d: ', i), model_names(i, 1)));
    tic
    
    load(append(model_names(i, 1), '/res.mat'));
    num_cats = max(res.I, [], 'all');
    data = data_mat;
    if contains(model_names(i, 1), 'pca')
        data = pca_mat;
    end
    
    class_score = my_silhouette(data, res.I, false);    
    centers = zeros(num_cats-1, size(data, 2) - 3);
    for j = 2:num_cats
        centers(j-1, :) = data(data(:, end-2) == res.centroids(j, 1) & data(:, end-1) == res.centroids(j, 2), 1:end-3);
    end
    clust_dists = pdist(centers);
    med_clust_dists = median(clust_dists);
    weights_1 = max(0, squareform(1 - 2 * inverse_quantile(clust_dists, clust_dists)));
    clust_dists = squareform(clust_dists);
    % thresh1 = quantile(clust_dists, 0.2);  % important parameter
    % weights = -tanh(zscore(clust_dists, 1, 'all'));    
    veg_score = homogeneity(veg, res.I, false, true);
    fprintf('Homogeneity score before merging is %f\n', veg_score);
    fprintf('Calinski-Harabasz score before merging is %f\n', class_score);
    toc
    
    fprintf('Preparing optimization matrix...\n');
    optim_mat = zeros(num_cats, num_cats);
    weights_ = [];
    for j = 2:num_cats-1
        for k = j+1:num_cats
            temp_I = res.I;
            temp_I(temp_I == j) = k;     
            new_veg_score = homogeneity(veg, temp_I, false, true);
            weights_ = [weights_ my_silhouette(data, temp_I, false) / class_score];  
            optim_mat(j, k) = max(0, new_veg_score - veg_score);        
        end
    end
    weights = max(0, squareform(2 * inverse_quantile(weights_, weights_) - 1));
    optim_mat(2:end, 2:end) = optim_mat(2:end, 2:end) .* weights .* weights_1;
    optim_mat(1, :) = 1:num_cats; optim_mat(:, 1) = 1:num_cats;
    toc

    fprintf('Finding feasible merges...');
    merges = [];
    [M, I] = max(optim_mat(2:end, 2:end), [], 'all', 'linear');
    thresh = 0.0005;  % important parameter
    while M > thresh    
        [row, col] = ind2sub(size(optim_mat) - 1, I);
        to_del_1 = optim_mat(row+1, 1); to_del_2 = optim_mat(1, col+1);
        merges = [merges; to_del_1 to_del_2 M clust_dists(to_del_1-1, to_del_2-1) med_clust_dists];
        veg_score = veg_score + M;
        optim_mat(optim_mat(:, 1) == to_del_1 | optim_mat(:, 1) == to_del_2, :) = [];
        optim_mat(:, optim_mat(1, :) == to_del_1 | optim_mat(1, :) == to_del_2) = [];
        [M, I] = max(optim_mat(2:end, 2:end), [], 'all', 'linear');
    end
    fprintf('%d feasible merge(s) detected.\n', size(merges, 1));
    fprintf('Homogeneity score after merging is at least %f\n', veg_score);

    if size(merges, 1) > 0
        model_names(i, 1) = append(model_names(i, 1), '_merged');
        work_dir = append(model_names(i, 1), '/');
        mkdir(work_dir);
        merges_ = merges;
        merges_(:, 1:2) = merges_(:, 1:2) - 1;
        writematrix(merges_, append(work_dir, 'merge_info.txt'));
        toc
        fprintf('Merging...\n');    
        for j = 1:size(merges, 1)
            cnt_1 = sum(res.I == merges(j, 1), 'all');
            cnt_2 = sum(res.I == merges(j, 2), 'all');
            res.I(res.I == merges(j, 2)) = merges(j, 1);
            centroid_idx_1 = res.centroids(merges(j, 1), :);
            centroid_idx_2 = res.centroids(merges(j, 2), :);
            centroid_1 = data(data(:, end-2) == centroid_idx_1(1, 1) & data(:, end-1) == centroid_idx_1(1, 2), 1:end-3);
            centroid_2 = data(data(:, end-2) == centroid_idx_2(1, 1) & data(:, end-1) == centroid_idx_2(1, 2), 1:end-3);
            new_centroid = (centroid_1 .* cnt_1 + centroid_2 .* cnt_2) / (cnt_1 + cnt_2);
            for k = 1:length(data)
                data(k, end) = res.I(data(k, end-2), data(k, end-1));
            end
            subset = data(data(:, end) == merges(j, 1), :);
            new_centroid_idx = knnsearch(subset(:, 1:end-3), new_centroid);
            res.centroids(merges(j, 1), :) = subset(new_centroid_idx, end-2:end-1);
        end

        save(append(work_dir, 'res.mat'), 'res');
        fprintf('Clusters saved. Plotting...\n');
        toc

        bulk_plot(res, ori_data_map, 270, 719, work_dir);
        toc

        fprintf('Evaluating...\n');
        eval_res(i, 1) = homogeneity(veg, res.I, false, true);
        eval_res(i, 2) = my_silhouette(data_mat, res.I, true);
        eval_res(i, 3) = homogeneity(kp, res.I, true, false);
        fprintf('Scores after merging are %f %f %f\n', eval_res(i, 1), eval_res(i, 2), eval_res(i, 3));
        fprintf('Calinski-Harabasz score after merging is %f\n', my_silhouette(data_mat, res.I, false));
    end
    toc
end

T = table(model_names, eval_res(:, 1), eval_res(:, 2), eval_res(:, 3), ...
    'VariableNames', {'Model', 'homogeneity with vegetation', 'silhouette', 'similarity with Koppen'});
T = sortrows(T, {'homogeneity with vegetation', 'silhouette', 'similarity with Koppen'}, {'descend', 'descend', 'descend'});
writetable(T, 'eval_res_merged.xlsx');
fprintf('All done. Evaluation scores saved in eval_res_merged.xlsx.\n');


function s = inverse_quantile(X, y)
    sortedX = sort(X);
    listCumProb = (1/length(X))*(0.5:1:length(X)-0.5);
    s = interp1(sortedX, listCumProb, y);
end