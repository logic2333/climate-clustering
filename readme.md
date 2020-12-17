![alt text](https://github.com/logic2333/climate-clustering/blob/master/som%26kmedoids/final/globe2.png?raw=true)

## Climate Classification: A data-driven approach

Climate and vegetation, directly and indirectly, influence each other, where the question arises if there is a mapping between climate and vegetation. To discover the humidity-heat conditions for different vegetation types, which is a vital goal of climate classification, we are pursuing a purely data-controlled approach for climate classification. The Köppen-Geiger classic climate classification system is based on heuristic and empirical rules, which may appear arbitrary and subjective.  Although these have been used dating from the 1900s, they have heuristic deficiencies, prompting various versions of modification.

### Directory Structure
    .
    |-- Future Work                                            # (.py) files for each model mentioned
    |    |-- Affinity Propagation Clustering Algorithm                           
         |-- Optics Clustering Algorithm
         |-- Spectral Clustering Algorithm 
    |-- Supervised Models Code                                 # (.py) files for each model mentioned along with evaluate.py
    |    |--  Decision Tree Classifier Algorithm
         |-- Gaussian MD Algorithm
         |-- K Neighbors Classifier Algorithm
         |-- Linear Discriminant Analysis Algorithm
         |-- Logistic Regression Algorithm
         |-- Random Forest Classifer Algorithm
         |-- Support Vector Machines Algorithm
    |-- Testing results for supervised & unsupervised models   # excel sheets for each model along with different cluster numbers
    |    |-- Supervised Model Results.xlsx
         |-- Unsupervised Clustering Model Results.xlsx
    |-- Unsupervised Models Code                               # (.py) files for each model mentioned along with map_plot.py & homegeneity_score.py
    |    |-- Agglomerative Clustering Algorithm
         |-- BIRCH Clustering Algorithm
         |-- Gaussian Mixture Clustering Algorithm
         |-- K-Means Clustering Algorithm
         |-- Mini Batch K-Means Clustering Algorithm
    |-- Unsupervised Models Plots                              # 36 (.png) files for each cluster for each model
    |    |-- Agglomerative Clustering Algorithm Plots
         |-- BIRCH Clustering Algorithm Plots
         |-- Gaussian Mixture Clustering Algorithm Plots
         |-- K-Means Clustering Algorithm Plots
         |-- Mini Batch K-Means Clustering Algorithm Plots
    |-- koppen_29
        |-- (.png) maps of individual Koppen climate types
        |-- koppen.m                                           # calculate the Koppen classification on the dataset
        |-- koppen.csv                                         # global Koppen classification map in csv
    |-- literatures                                            # (.pdf) related published articles of this project
    |-- som&kmediods
        |-- figures                                            # figures used in the reports to compare the performance of different models
        |-- (all other folders)                                # results from various models. /final is the finalized result
            |-- (.png) maps of individual climate types
            |-- merge_info.txt                                 # if the result has gone through merging, this file specifies which cluster pairs are merged and other details
            |                                                  # merged_cluster_1, merged_cluster_2, priority_for_merging(entry in optimization matrix), 
            |                                                  # distance_between_cluster_centroids, median_of_distances
            |-- res.mat                                        # ***global climate classification map given by the model, can be loaded by bulk_plot.m and interactive_map.m***
        |-- eval_res.xlsx                                      # scores of SOM and K-medoids models
        |-- bulk_process.m                                     # main entry to train the models
        |-- bulk_plot.m                                        # make map plots of clustering results(res.mat)
        |-- merge.m                                            # execute the merging algorithm on the clustering results
        |-- interactive_map.m                                  # starts an interactive map based on res.mat
        |-- dir_filter.m                                       # parses folder names and controls bulk_process.m, merge.m react to which folders
        |-- alpha_test.m                                       # used to decide the optimal alpha for harmonized homogeneity
        |-- standardization.m                                  # reads ori_data.mat, standardizes and activates the data, gives data_mat.mat
        |-- (other helper functions)
        |-- homogeneity.m                                      # calculates harmonized homogeneity score        
    |-- tif                                                    
        |-- (.tif) files of aligned and downsampled climate variables
        |-- preprocess.m                                       # reorganizes the tifs as som&kmedoids/ori_data.mat
        |-- CHELSA_tech_specification.pdf                      # documentation of CHELSA dataset       
    |-- vegetation_14
        |-- (.png) maps of individual vegetation types
        |-- vegetation.tif                                     # aligned and downsampled vegetation dataset
        |-- MCD12_User_Guide_V6.pdf                            # documentation of MCD12C1, the vegetation dataset
    |-- Running.md                                             # instructions on running the project
    |-- data_mat.csv                                           # climate dataset after standardization and activation, which can be directly put to model training
    |                                                          # same as som&kmedoids/data_mat.mat with headers
    |-- README.MD                                              
    |-- report.pdf                                             # report specifying details of the project  
    |-- requirements.txt                                       # libraries required for compiling the project

### Highlights
- tanh activation on climate data
- harmonized homogeneity metric for unsupervised clustering
- objective merging postprocessing to improve goodness of fit with natural vegetation
- optimal result interpreted, climate clusters named, centroid depicted
- run the interactive map and explore climate of different places around the world!

### Notes
This project is submitted as the final project for CMPT 726: Machine Learning
- Code running instructions can be found in RUNNING.MD
- Project details can be found in report.pdf

### Contributors
- Bilal Hussain
- Ji Luo
- Sakina Patanwala



