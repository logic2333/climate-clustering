
###Climate Classification: A data-driven approach

Climate and vegetation, directly and indirectly, influence each other, where the question arises if there is a mapping between climate and vegetation. To discover the humidity-heat conditions for different vegetation types, which is a vital goal of climate classification, we are pursuing a purely data-controlled approach for climate classification. The Köppen-Geiger classic climate classification system is based on heuristic and empirical rules, which may appear arbitrary and subjective.  Although these have been used dating from the 1900s, they have heuristic deficiencies, prompting various versions of modification.

##Directory Structure

##Features
- borderdata.mat, bordersm.m, by Chad Greene, draw country borders on a map.
- tif folder stores original data from CHELSA, TerraClimate. preprocess.m under this folder collects the tifs and gives ori_data.mat.
- koppen_29 holds plotted maps of the traditional Koppen-Geiger Climate Classification.
- vegetation_14 saves MODIS land cover type(https://lpdaac.usgs.gov/products/mcd12c1v006/).
- Clustering results are plotted in corresponding folders: xxmedoids, som_xxxx_xxxtop(with or without PCA).
- Finalized and interpreted clustering results are under the final folder.
- standardize.m changes ori_data.mat to data_mat.mat by z-score standardization and tanh activation.
- data_mat.csv is actually the same thing as data_mat.mat, header added.
- bulk_process.m trains clustering models, plots the result on the globe and evaluates the model. It picks models(Self-Organizing Maps and K-Medoids) according to the folders' names under this directory and saves the plotted maps and clustering results(res.mat) under corresponding folders.
- merge.m detects feasible merges in the clustering results to improve homogeneity with vegetation, and saves merged clusterings in '_merged' folders.
- Evaluation scores of the models are in eval_res.xlsx. 
- Each res.mat can be loaded with interactive_map.m.
- This code starts an interactive map where users click on the map, and it will show the climate chart of the clicked place.

##Notes
This project is submitted as the final project for CMPT 732: Programming for Big Data Lab 1.
- Code running instructions can be found in RUNNING.MD
- Project details can be found in report.pdf

###Contributors
- Bilal Hussain
- Ji Luo
- Sakina Patanwala



