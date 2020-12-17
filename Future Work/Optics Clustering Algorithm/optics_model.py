import pandas as pd
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.cluster import OPTICS
from sklearn.metrics import silhouette_score, v_measure_score
import numpy as np
from numpy import unique
from matplotlib import pyplot
import cartopy.crs as ccrs
import cartopy.feature as cfeature
from sklearn.decomposition import PCA
from ML_Project.homogenity_score import homogeneity
from ML_Project.Map_Plot import plot_map,plot_maps
alpha = 2.29
np.random.seed(1)

# loading the climatology dataset
climate_dataset = pd.read_csv('datasets/data_mat.csv')
mapped_dataset = pd.read_csv('datasets/mapped_data.csv')
koppen_dataset = pd.read_csv('datasets/koppen_data.csv')
print('Dataset loaded successfully')

#Encode koppen labels
label_encoder = LabelEncoder()
koppen_labels = label_encoder.fit_transform(koppen_dataset['koppen_labels'])

# removing the last column from the climatology dataset
latSeries = climate_dataset['lat']
lonSeries = climate_dataset['lon']
climate_dataset = climate_dataset.iloc[:,:-1]

# making an array of the dataset
array = climate_dataset.values
data = array[:,:]

#scaling the dataset using StandardScaler
scale = StandardScaler()
data = scale.fit_transform(data)

#PCA
pca = PCA(.99)
principalComponents = pca.fit_transform(data)
principalDf = pd.DataFrame(data = principalComponents
             , columns = [f"col{x}" for x in range(len(principalComponents[0]))])

models =[]
models.append(('OPTICS1', OPTICS(eps=0.1,min_samples=6)))
models.append(('OPTICS2', OPTICS(eps=0.4,min_samples=10)))
models.append(('OPTICS3', OPTICS(eps=0.6,min_samples=8)))
models.append(('OPTICS4', OPTICS(eps=0.5,min_samples=12)))
models.append(('OPTICS5', OPTICS(eps=0.2,min_samples=18)))
models.append(('OPTICS6', OPTICS(eps=0.1,min_samples=4)))
models.append(('OPTICS7', OPTICS(eps=0.4,min_samples=4)))
models.append(('OPTICS8', OPTICS(eps=0.1,min_samples=2)))
models.append(('OPTICS9', OPTICS(eps=0.4,min_samples=2)))
models.append(('OPTICS10', OPTICS(eps=0.2,min_samples=4)))
models.append(('OPTICS11', OPTICS(eps=0.2,min_samples=6)))
models.append(('OPTICS12', OPTICS(eps=0.3,min_samples=10)))

data_frame = principalDf.copy()

for name, model in models:

    principalDf= data_frame.copy()
    model.fit(principalDf)
    labels = model.labels_
    n_clusters_ = len(set(labels)) - (1 if -1 in labels else 0)
    n_noise_ = list(labels).count(-1)
    print("CLUSTERS:", n_clusters_)
    principalDf["Clusters"] = labels
    principalDf["Koppen_labels"]= koppen_labels
    principalDf = principalDf[principalDf['Clusters'] != -1]
    k = max(unique(principalDf["Clusters"]))
    df = principalDf.copy()
    plot_map('OPTICS',k,df,lonSeries,latSeries)

    principalDf['veg_type'] = mapped_dataset['veg_type']
    principalDf = principalDf.loc[~(principalDf.veg_type == '0')]
    sil_df = principalDf.drop(['Clusters', 'veg_type','Koppen_labels'], axis=1)
    sil_pred = principalDf['Clusters']

    label_encoder = LabelEncoder()
    y = label_encoder.fit_transform(principalDf['veg_type'])
    principalDf['veg_encoded'] = y
    principalDf = principalDf[principalDf['Clusters'] != -1]

    k1 = max(principalDf['veg_encoded']) + 1
    I1 = principalDf['veg_encoded'].replace({0: k1})
    k2 = max(principalDf['Koppen_labels']) + 1
    I2 = principalDf["Clusters"]
    I3 = principalDf['Koppen_labels'].replace({0: k2 + 1})

    sil_score= silhouette_score(sil_df,sil_pred)
    V_measure_score = v_measure_score(principalDf['Koppen_labels'], principalDf["Clusters"])

    print(f'Name: {name}, Homogenity: {homogeneity(I1, I2, False, alpha)}, Silhouette: {sil_score}, Similarity With Koppen : {V_measure_score}')
    principalDf = principalDf.drop(['Clusters','veg_type','veg_encoded','Koppen_labels'],axis = 1)

print("FINISHED")



