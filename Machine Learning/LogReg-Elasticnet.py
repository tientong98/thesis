#!/usr/bin/env python3

import os
import random
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.model_selection import GridSearchCV
from sklearn.model_selection import KFold
from sklearn.model_selection import cross_val_score
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import Pipeline
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
from sklearn.linear_model import LogisticRegression
from sklearn.svm import SVC
from sklearn.decomposition import PCA
from sklearn.feature_selection import SelectKBest
from sklearn.pipeline import FeatureUnion
from sklearn.ensemble import RandomForestClassifier
from sklearn.tree import DecisionTreeClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import roc_auc_score

# Read in data into a dataframe 
os.chdir('/Users/tientong/ml_abcd/')

data = pd.read_csv('fs.txt', sep="\t")
data["group"] = data["group"].astype('category')
data.drop(columns=['lh.aparc.thickness', 'rh.aparc.thickness'], inplace=True)

# separate train-heldout sets
fhp_orig = data[data["group"]=='fhp']
fhn_orig = data[data["group"]=='fhn']

def train_heldout_split(percent, df, outfile):
    k = round(percent * len(df))
    random.seed(4)
    heldout_index = random.sample(list(df.index), k)
    heldout_df = df.loc[heldout_index,:]
    heldout_df.to_csv(outfile, index = False, sep="\t")
    
    train_index = []
    for i in range(len(list(df.index))):
        if list(df.index)[i] not in list(heldout_df.index):
            train_index.append(list(df.index)[i])
    train_df = df.loc[train_index,:]
    
    return(train_df)
    
fhp_df = train_heldout_split(.2, fhp_orig, "heldout_fhp.txt")
fhn_df = train_heldout_split(.2, fhn_orig, "heldout_fhn.txt")

finaldf = fhp_df.merge(fhn_df, how='outer')

X = finaldf.iloc[:,3:]
Y = finaldf["group"]
Y = finaldf["group"].cat.codes

import sys
from nested_cv import NestedCV
import pandas as pd
import numpy as np
from sklearn.datasets import load_boston, load_iris, load_breast_cancer
from sklearn.ensemble import RandomForestRegressor, RandomForestClassifier
from sklearn.model_selection import KFold

# When using Random Search, we get a user warning with this little number of hyperparameters
# Suppress it
import warnings
warnings.simplefilter(action='ignore', category=UserWarning)
warnings.simplefilter(action='ignore', category=FutureWarning)


from sklearn.metrics import roc_auc_score
from sklearn.metrics import accuracy_score
from sklearn.model_selection import RepeatedStratifiedKFold
from sklearn.model_selection import StratifiedKFold

# Binary classification
y = finaldf["group"].cat.codes

scaler = StandardScaler()
features =  [ var for var in  list(finaldf.columns[3:]) if var not in ['lh_MeanThickness_thickness', 
                                                         'rh_MeanThickness_thickness', 
                                                         'BrainSegVolNotVent', 'eTIV'] ]
finaldf[features] = scaler.fit_transform(finaldf[features])
X = finaldf[features]


param_grid = {'C': np.logspace(-10, 10, 100000)}

NCV = NestedCV(model=LogisticRegression(penalty='elasticnet', solver='saga', l1_ratio=0.5),
               params_grid=param_grid, n_jobs = -1, 
               outer_cv=StratifiedKFold(n_splits=5), 
               inner_cv=RepeatedStratifiedKFold(n_splits=5, n_repeats=20, random_state=1), 
               cv_options={'metric':roc_auc_score, 
                           'metric_score_indicator_lower':False,
                           'randomized_search':False})

NCV.fit(X=X,y=y)

print(NCV.outer_scores)
print('LogReg elasticnet: ', np.mean(NCV.outer_scores))
