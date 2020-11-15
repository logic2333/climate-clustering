% This is just a demo readme; will be changed to a well formatted README.MD before final submission of the project.


borderdata.mat, bordersm.m, by Chad Greene, draw country borders on a map.

tif folder stores original data from CHELSA and TerraClimate.
preprocess.m under this folder collects the tifs and gives ori_data.mat.

koppen_29 holds plotted maps of the traditional Koppen-Geiger Climate Classification.

Clustering results are plotted in corresponding folders: xxmedoids, som_xxxx_xxxtop(with or without PCA).


standardize.m changes ori_data.mat to data_mat.mat by z-score standardization.
data_mat.csv is actually the same thing as data_mat.mat, header added.

som.m and kmed.m are code for training Self-Organizing Maps and K-Medoids.
Each outputs a res.mat, a 270*719 resolution matrix, which can be found under clustering results folders.

res.mat can be visualized with plot_categories.m and filter_show.m.
plot_categories.m plots all categories altogether on the globe. It also plots climate charts of the category representatives with climate_chart.m.
filter_show.m plots each category individually on the globe. Suppose there are 27 categories, it will output 27 images.
combine.m combines each category's global image and representative climate chart on one image, as is the Axx.png under clustering results folders.
