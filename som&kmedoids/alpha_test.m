% search for the best alpha for homogeneity metric
% note to modify dir_filter.m to only involve in kmedoids models
% alpha is best at 2.29

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
model_names = strings(l, 1);

load('res_vegetation.mat');
veg = res.I;


alphas = 0:0.01:5;
pca_res = [];
dat_res = [];
num_cats = [];
num_cats_pca = [];
slopes = zeros(length(alphas), 1);
slopes_pca = zeros(length(alphas), 1);


for i = 1:l
    model_names(i, 1) = string(listing(i).name);
    t = char(model_names(i, 1));
    num_categories = str2double(t(1:2));    
    load(append(model_names(i, 1), '/res.mat'));
    s = zeros(1, length(alphas));
    for j = 1:length(alphas)
        s(1, j) = homogeneity(veg, res.I, false, alphas(j));
    end
    if contains(model_names(i, 1), 'pca')
        pca_res = [pca_res; s];
        num_cats_pca = [num_cats_pca; num_categories];
    else
        dat_res = [dat_res; s];
        num_cats = [num_cats; num_categories];
    end
end

% [X, Y] = meshgrid(alphas, num_cats);
% mesh(X, Y, dat_res);

for i = 1:length(alphas)
    Y = dat_res(:, i);
    X = ones(length(num_cats), 2);
    X(:, 2) = num_cats;
    t = X \ Y;
    slopes(i, 1) = t(2);
end

for i = 1:length(alphas)
    Y = pca_res(:, i);
    X = ones(length(num_cats_pca), 2);
    X(:, 2) = num_cats_pca;
    t = X \ Y;
    slopes_pca(i, 1) = t(2);
end

% plot(alphas, slopes);
% hold on;
% plot(alphas, slopes_pca);
%legend('non pca', 'pca');
plot(alphas, (slopes + slopes_pca) / 2);