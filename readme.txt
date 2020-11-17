% This is just a demo readme; will be changed to a well formatted README.MD before final submission of the project.


borderdata.mat, bordersm.m, by Chad Greene, draw country borders on a map.

tif folder stores original data from CHELSA, TerraClimate.
preprocess.m under this folder collects the tifs and gives ori_data.mat.

koppen_29 holds plotted maps of the traditional Koppen-Geiger Climate Classification.
vegetation_14 saves MODIS land cover type(https://lpdaac.usgs.gov/products/mcd12c1v006/).

Clustering results are plotted in corresponding folders: xxmedoids, som_xxxx_xxxtop(with or without PCA).


standardize.m changes ori_data.mat to data_mat.mat by z-score standardization.
data_mat.csv is actually the same thing as data_mat.mat, header added.

bulk_process.m trains clustering models, plots the result on the globe and evaluates the model.
It picks models(Self-Organizing Maps and K-Medoids) according to the folders' names under this directory,
and saves the plotted maps and clustering results(res.mat) under corresponding folders.

Each res.mat can be loaded with interactive_map.m.
This code starts an interactive map where users click on the map, and it will show the climate chart of the clicked place.
