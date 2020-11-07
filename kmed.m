% clust = @(X, k)kmedoids(X, k, 'Distance', 'euclidean', 'Options', statset('UseParallel', true));
% eva = evalclusters(pca_mat, clust, 'silhouette', 'KList', 18:3:36, 'Distance', 'euclidean', 'ClusterPriors', 'equal');
% this func tells us the best k is around 20

clear; clc;

% load('pca_mat.mat');
load('data_mat.mat');

a = 270; b = 719;

% [idx, ~, ~, ~, centroid_idx] = kmedoids(pca_mat(:, 1:38), 30, 'Distance', 'euclidean', 'Options', statset('UseParallel', true));
[idx, ~, ~, ~, centroid_idx] = kmedoids(data_mat(:, 1:76), 24, 'Distance', 'euclidean', 'Options', statset('UseParallel', true));

centroids = [0 0; data_mat(centroid_idx, 77:78)];
% centroids = [0 0; pca_mat(centroid_idx, 39:40)];

I = ones(a, b);
for i = 1:length(idx)
    %I(pca_mat(i, 39), pca_mat(i, 40)) = idx(i, 1) + 1;
    I(data_mat(i, 77), data_mat(i, 78)) = idx(i, 1) + 1;
end

res = struct('I', I, 'centroids', centroids);
save('res.mat', 'res');