# Python Part

## Prerequisites:
python -m venv env
env/Scripts/activate
pip install -r requirements.txt 

OR

conda create --name <env> --file requirements.txt

### STEP 1: Steps for compiling the supervised and unsupervised codes.

Download the data_mat.csv, mapped_data.csv, koppen_data.csv data sets from this repository and store into directory named dataset. This directory will be used by Unsupervised Models Code and Supervised Models Code.

#### Step 1.1: 

- cd Unsupervised Models Code
- cd <Directory with model name>
- Directory for each model should contain Map_Plot.py, <file_with_model_name.py> and homogenity_score.py
- python3 <file_with_model_name.py> 

#### Step 1.2: 

- cd Supervised Models Code
- cd <Directory with model name>
- Directory for each model should contain evaluate.py and <file_with_model_name.py>
- python3 <file_with_model_name.py>

# Matlab Part

**For Training SOM and K-medoids models, running interactive map**

## Software
- Matlab R2020b, or above
- Mapping toolbox(map plotting)
- Statistics and Machine Learning Toolbox(K-medoids)
- Deep Learning Toolbox(SOM)

## Files
All the files mentioned here are under `som&kmedoids` folder. Download the necessary files as listed below.

### Executables
- `interactive_map.m`: starts an interactive map based on a `res.mat`. Users click on the map, and it will show the climate chart of the clicked place 
- `bulk_process.m`: main entry to train the models. trains the models according to folder names(xxmedoids, xxmedoids_pca, som_xx_xxxtop) under current directory
***create empty folders or rename existing model folders before running this code***, otherwise existing results would be overwritten
- `bulk_plot.m`: make map plots of clustering results(res.mat). bulk_process.m calls this code, but it can also be run manually
- `merge.m`: execute the merging algorithm on the clustering results. manually run it after running `bulk_process.m`

### Dependencies
- `dir_filter.m`: parses folder names and controls `bulk_process.m`, `merge.m` react to which folders. Edit it to cater to your needs
- `borderdata.mat`, `bordersm.m`: By [Chad Greene](https://www.mathworks.com/matlabcentral/fileexchange/50390-borders), plots country borders on map
- `climate_chart.m`, `filter_show.m`: helper functions for map and climate chart plotting
- `homogeneity.m`, `my_silhouette.m`, `inverse_quantile.m`: helper functions for metric calculation
- `data_mat.mat`, `pca_mat.mat`, `ori_data.mat`, `res_koppen.mat`, `res_vegetation.mat`: necessary dataset files
- `res.mat`: same as `/final/res_final.mat`. serves as an example of clustering results. You may use outputs of other models or train your own model with `bulk_process.m`

