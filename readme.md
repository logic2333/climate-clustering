
## Climate Classification: A data-driven approach

Climate and vegetation, directly and indirectly, influence each other, where the question arises if there is a mapping between climate and vegetation. To discover the humidity-heat conditions for different vegetation types, which is a vital goal of climate classification, we are pursuing a purely data-controlled approach for climate classification. The Köppen-Geiger classic climate classification system is based on heuristic and empirical rules, which may appear arbitrary and subjective.  Although these have been used dating from the 1900s, they have heuristic deficiencies, prompting various versions of modification.

### Directory Structure

.
|-- Future Work                                         # (.py) files for each model mentioned
|        |-- Affinity Propagation Clustering Algorithm            
         |-- Optics Clustering Algorithm
         |-- Spectral Clustering Algorithm
|-- Supervised Models Code                              # (.py) files for each model mentioned along with evaluate.py
|        |-- Decision Tree Classifier Algorithm
         |-- Gaussian MD Algorithm
         |-- K Neighbors Classifier Algorithm
         |-- Linear Discriminant Analysis Algorithm
         |-- Logistic Regression Algorithm
         |-- Random Forest Classifer Algorithm
         |-- Support Vector Machines Algorithm
|-- Testing results for supervised & unsupervised models  # excel sheets for each model along with different cluster numbers
|        |-- Supervised Model Results.xlsx
         |-- Unsupervised Clustering Model Results.xlsx
|-- Unsupervised Models Code                            # (.py) files for each model mentioned along with map_plot.py & homegeneity_score.py
|        |-- Agglomerative Clustering Algorithm
         |-- BIRCH Clustering Algorithm
         |-- Gaussian Mixture Clustering Algorithm
         |-- K-Means Clustering Algorithm
         |-- Mini Batch K-Means Clustering Algorithm
|-- Unsupervised Models Plots                           # 36 (.png) files for each cluster for each model
|        |-- Agglomerative Clustering Algorithm Plots
         |-- BIRCH Clustering Algorithm Plots
         |-- Gaussian Mixture Clustering Algorithm Plots
         |-- K-Means Clustering Algorithm Plots
         |-- Mini Batch K-Means Clustering Algorithm Plots
|-- koppen_29
|-- literatures
|-- som&kmediods
|-- tif
|-- vegetation_14
|-- data_mat.csv
|-- eval_res.xlsx
|-- readme.md                                        # repository's readme
|__ report.pdf                                       # report specifying details of the project

    .
    |-- doc                           # Project report(.pdf), project proposal(.txt) and figures(.png)
    |    |-- figs                           # Expected 15 output graphs on Dash(UI)
              |-- Visual Graphs                    # 15 (.png) files       
         |-- Project Proposal               # Proposed project proposal
         |-- Project Report                 # Project Report
    |-- src                           # CSV files and code
    |    |-- csv_files                      # 16 CSV files generated after running the pyspark code 
         |-- code files(.py)                # python files for generating (.csv) files and the UI
         |-- requirements.txt               # libraries required for compiling the project
    |-- README.md                     # repository's readme
    |__ RUNNING.MD                    # instructions on running the project

### Features
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
- Each res.mat can be loaded with interactive_map.m. This code starts an interactive map where users click on the map, and it will show the climate chart of the clicked place.

### Notes
This project is submitted as the final project for CMPT 726: Machine Learning
- Code running instructions can be found in RUNNING.MD
- Project details can be found in report.pdf

### Contributors
- Bilal Hussain
- Ji Luo
- Sakina Patanwala



