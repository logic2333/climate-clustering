import pandas as pd
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.mixture import GaussianMixture
from sklearn.metrics import silhouette_score, v_measure_score
import numpy as np
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
models.append(('Gaussian Mixture18', GaussianMixture(n_components=18, random_state=1),18))
models.append(('Gaussian Mixture20', GaussianMixture(n_components=20, random_state=1),20))
models.append(('Gaussian Mixture22', GaussianMixture(n_components=22, random_state=1),22))
models.append(('Gaussian Mixture24', GaussianMixture(n_components=24, random_state=1),24))
models.append(('Gaussian Mixture26', GaussianMixture(n_components=26, random_state=1),26))
models.append(('Gaussian Mixture29', GaussianMixture(n_components=29, random_state=1),29))
models.append(('Gaussian Mixture30', GaussianMixture(n_components=30, random_state=1),30))


data_frame = principalDf.copy()

for name, model,k in models:

    principalDf= data_frame.copy()
    model.fit(principalDf)
    labels = model.predict(principalDf)
    principalDf["Clusters"] = labels
    principalDf["Koppen_labels"]= koppen_labels

    df = principalDf.copy()
    plot_map('Gaussian Mixture',k,df,lonSeries,latSeries)

    if k ==29:
        plot_maps('Gaussian Mixture', k, df, lonSeries, latSeries)


    principalDf['veg_type'] = mapped_dataset['veg_type']
    principalDf = principalDf.loc[~(principalDf.veg_type == '0')]
    sil_df = principalDf.drop(['Clusters', 'veg_type','Koppen_labels'], axis=1)
    sil_pred = principalDf['Clusters']

    label_encoder = LabelEncoder()
    y = label_encoder.fit_transform(principalDf['veg_type'])
    principalDf['veg_encoded'] = y

    k1 = max(principalDf['veg_encoded']) + 1
    I1 = principalDf['veg_encoded'].replace({0: k1 + 1})
    k2 = max(principalDf['Koppen_labels']) + 1
    I2 = principalDf["Clusters"]
    I3 = principalDf['Koppen_labels'].replace({0: k2 + 1})

    sil_score= silhouette_score(sil_df,sil_pred)
    V_measure_score = v_measure_score(principalDf['Koppen_labels'], principalDf["Clusters"])

    print(f'Name: {name}, Homogenity: {homogeneity(I1, I2, False, alpha)}, Silhouette: {sil_score}, Similarity With Koppen : {V_measure_score}')
    principalDf = principalDf.drop(['Clusters','veg_type','veg_encoded','Koppen_labels'],axis = 1)

print("FINISHED")



