import pandas as pd
from sklearn.model_selection import cross_val_score
from sklearn.model_selection import StratifiedKFold
from sklearn.tree import DecisionTreeClassifier
from sklearn.preprocessing import LabelEncoder
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA
from Supervised_models.evaluate import evaluate_predictions as ep

mapped_dataset = pd.read_csv('dataset/mapped_data.csv')
mapped_dataset= mapped_dataset[mapped_dataset.veg_type != '0']
data = mapped_dataset.drop(['veg_type', 'lat', 'lon'], axis=1)
labels = mapped_dataset['veg_type']

label_encoder = LabelEncoder()
y = label_encoder.fit_transform(labels)


#Standardize

sc=StandardScaler()
X_train = sc.fit_transform(data)

#PCA
pca = PCA(.99)
principalComponents = pca.fit_transform(X_train) # 13 dimensions
principalDf = pd.DataFrame(data = principalComponents
             , columns = [f"col{x}" for x in range(len(principalComponents[0]))])
training_data = principalDf.copy()
principalDf['target']= y

#
shuffled_df = principalDf.sample(frac=1)
X = shuffled_df.drop('target',axis=1)
Y = shuffled_df['target']


train_split = round(0.7 * len(shuffled_df)) # 70% of data
valid_split = round(train_split + 0.15 * len(shuffled_df))
X_train, y_train = X[:train_split], Y[:train_split]
X_valid, y_valid =X[train_split:valid_split], Y[train_split:valid_split]
X_test, y_test = X[valid_split:], Y[valid_split:]

# # Spot Check Algorithms
models = []
models.append(('CART', DecisionTreeClassifier(random_state=1)))
models.append(('CART', DecisionTreeClassifier(criterion='entropy',random_state=1)))


# evaluate each model in turn
results = []
names = []
for name, model in models:

    clf = model.fit(X_train,y_train)
    y_preds = clf.predict(X_valid)
    baseline_metrics = ep(y_valid, y_preds)
    kfold = StratifiedKFold(n_splits=10, random_state=1, shuffle=True)
    cv_results = cross_val_score(model, training_data, y, cv=kfold, scoring='accuracy')
    results.append(cv_results)
    names.append(name)
    print('Cross_val_score: ','%s: %f (%f)' % (name, cv_results.mean(), cv_results.std()))