import pandas as pd
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.cluster import KMeans
from sklearn.metrics import silhouette_score, v_measure_score
import numpy as np
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
principalDf = pd.DataFrame(data= data)

models = []
models.append(('Kmeans18', KMeans(n_clusters=18, random_state=1),18))
models.append(('Kmeans20', KMeans(n_clusters=20, random_state=1),20))
models.append(('Kmeans22', KMeans(n_clusters=22, random_state=1),22))
models.append(('Kmeans24', KMeans(n_clusters=24, random_state=1),24))
models.append(('Kmeans26', KMeans(n_clusters=26, random_state=1),26))
models.append(('Kmeans29', KMeans(n_clusters=29, random_state=1),29))
models.append(('Kmeans30', KMeans(n_clusters=30, random_state=1),30))

data_frame = principalDf.copy()

for name, model,k in models:

    principalDf= data_frame.copy()
    model.fit(principalDf)
    labels = model.labels_
    principalDf["Clusters"] = labels
    principalDf.to_csv('/Users/bilalhussain/Downloads/Plotly CSV/kmeans.csv',index=False)
    principalDf["Koppen_labels"]= koppen_labels

    df = principalDf.copy()
    plot_map('KMeans',k,df,lonSeries,latSeries)

    if k ==29:
        plot_maps('KMeans', k, df, lonSeries, latSeries)

    principalDf['veg_type'] = mapped_dataset['veg_type']
    principalDf = principalDf.loc[~(principalDf.veg_type == '0')]
    sil_df = principalDf.drop(['Clusters', 'veg_type','Koppen_labels'], axis=1)
    sil_pred = principalDf['Clusters']

    label_encoder = LabelEncoder()
    y = label_encoder.fit_transform(principalDf['veg_type'])
    principalDf['veg_encoded'] = y

    I1 = principalDf['veg_encoded']
    I2 = principalDf["Clusters"]
    I3 = principalDf['Koppen_labels']

    sil_score= silhouette_score(sil_df,sil_pred)
    V_measure_score = v_measure_score(principalDf['Koppen_labels'], principalDf["Clusters"])

    print(f'Name: {name}, Homogenity: {homogeneity(I1, I2, False, alpha)}, Silhouette: {sil_score}, Similarity With Koppen : {V_measure_score}')
    principalDf = principalDf.drop(['Clusters','veg_type','veg_encoded','Koppen_labels'],axis = 1)

print("FINISHED")

