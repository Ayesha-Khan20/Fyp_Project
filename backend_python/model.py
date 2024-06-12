import tensorflow as tf
import pandas as pd

from sklearn.model_selection import train_test_split     #modules of scikitlearn
from sklearn.metrics import accuracy_score
from sklearn.neighbors import KNeighborsClassifier       #algo
from sklearn.feature_selection import RFE                #recursice feature elimination
from sklearn.tree import DecisionTreeClassifier          #algo
from sklearn.pipeline import Pipeline

import pickle  #use for serializing and deserializing 



pathdf = 'Stress-Lysis.csv'  # Path of the file pandas using dataframe 
Yvar = 'Stress Level'  # Name of the variable Y to predict
aggtype = ['mean', 'std']
palette = 'flare'

seed = 49
test_size = 0.30  # % size of test which is 30 percent

df = pd.read_csv(pathdf)  #dataframe read the file 
df = df.drop(['Humidity'],axis=1) #remove humidity coloumn 


X_train, X_test, y_train, y_test = train_test_split(df.drop(                            #dataset split into 2 parts , training and testing 
    Yvar, axis=1), df[Yvar], test_size=test_size, stratify=df[Yvar], random_state=seed)   


knn = KNeighborsClassifier(n_neighbors=3) #selecting nearest three object 
knn.fit(X_train, y_train)   #fit function into training data


rfe = RFE(estimator=DecisionTreeClassifier(), n_features_to_select=2)


pipeline = Pipeline(steps=[('RFE', rfe), ('KNN', knn)])
pipeline.fit(X_train, y_train)

pickle.dump(rfe,open('model.pkl','wb'))
model = pickle.load(open('model.pkl','rb'))