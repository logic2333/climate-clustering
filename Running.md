# Prerequisites:
python -m venv env
env/Scripts/activate
pip install -r requirements.txt 

OR

conda create --name <env> --file requirements.txt

## STEP 1: Steps for compiling the supervised and unsupervised codes.

Download the data_mat.csv, mapped_data.csv, koppen_data.csv data sets from this repository and store into directory named dataset. This directory will be used by Unsupervised Models Code and Supervised Models Code.

### Step 1.1: 

- cd Unsupervised Models Code
- cd <Directory with model name>
- Directory for each model should contain Map_Plot.py, <file_with_model_name.py> and homogenity_score.py
- python3 <file_with_model_name.py> 

### Step 1.2: 

- cd Supervised Models Code
- cd <Directory with model name>
- Directory for each model should contain evaluate.py and <file_with_model_name.py>
- python3 <file_with_model_name.py>
