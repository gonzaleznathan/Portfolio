import numpy as np 
import pandas as pd
data=pd.read_csv("/Users/nathangonzalez/Downloads/mushrooms.csv")
data

from sklearn.preprocessing import LabelEncoder
encoded= data.apply(LabelEncoder().fit_transform)   
encoded

import matplotlib.pyplot as plt
import seaborn as sns
for i in range(2,len(encoded.columns)):
    plt.subplot(5,5,i-1)
    sns.countplot(x=encoded[encoded.columns[i]],hue=encoded['class'], palette='Paired')

plt.figure(figsize=(10,10))
sns.countplot(x=encoded[encoded.columns[1]],hue=encoded['class'], palette='Paired')

from sklearn.model_selection import train_test_split
X = encoded.drop(['class'] , axis = 1)
Y = encoded['class']
X_train, X_test, Y_train, Y_test = train_test_split(X,Y, test_size = 0.20, random_state = 6283)

from sklearn.neighbors import KNeighborsClassifier
eucKNN = KNeighborsClassifier(metric='euclidean',n_neighbors=3)
eucKNN.fit(X_train,Y_train)
Y_pred = eucKNN.predict(X_test)

x_axis_labels = ["Edible", "Poisonous"]
y_axis_labels = ["Edible", "Poisonous"]
f, ax = plt.subplots(figsize =(10,10))
sns.heatmap(confusion_matrix(Y_test, Y_pred), annot = True, linewidths=0.01, linecolor="grey", fmt = ".0f", ax=ax, 
            cmap="GnBu", xticklabels=x_axis_labels, yticklabels=y_axis_labels)
plt.xlabel("Predicted")
plt.ylabel("True")
plt.title('Confusion Matrix for Euclidean kNN (K = 3)')
plt.show()


from sklearn.metrics import confusion_matrix, precision_score, recall_score, f1_score, accuracy_score
eucacc = accuracy_score(Y_test, Y_pred)
eucpre = precision_score(Y_test, Y_pred)
eucrec = recall_score(Y_test, Y_pred)
eucF1 = f1_score(Y_test, Y_pred)

manKNN = KNeighborsClassifier(metric='manhattan',n_neighbors=3)
manKNN.fit(X_train,Y_train)
Y_pred = manKNN.predict(X_test)

x_axis_labels = ["Edible", "Poisonous"]
y_axis_labels = ["Edible", "Poisonous"]
f, ax = plt.subplots(figsize =(10,10))
sns.heatmap(confusion_matrix(Y_test, Y_pred), annot = True, linewidths=0.01, linecolor="grey", fmt = ".0f", ax=ax, 
            cmap="GnBu", xticklabels=x_axis_labels, yticklabels=y_axis_labels)
plt.xlabel("Predicted")
plt.ylabel("True")
plt.title('Confusion Matrix for Manhattan kNN (K = 3)')
plt.show()

manacc = accuracy_score(Y_test, Y_pred)
manpre = precision_score(Y_test, Y_pred)
manrec = recall_score(Y_test, Y_pred)
manF1 = f1_score(Y_test, Y_pred)

cosKNN = KNeighborsClassifier(metric='cosine',n_neighbors=3)
cosKNN.fit(X_train,Y_train)
Y_pred = cosKNN.predict(X_test)

x_axis_labels = ["Edible", "Poisonous"]
y_axis_labels = ["Edible", "Poisonous"]
f, ax = plt.subplots(figsize =(10,10))
sns.heatmap(confusion_matrix(Y_test, Y_pred), annot = True, linewidths=0.01, linecolor="grey", fmt = ".0f", ax=ax, 
            cmap="GnBu", xticklabels=x_axis_labels, yticklabels=y_axis_labels)
plt.xlabel("Predicted")
plt.ylabel("True")
plt.title('Confusion Matrix for Cosine kNN (K = 3)')
plt.show()

cosacc = accuracy_score(Y_test, Y_pred)
cospre = precision_score(Y_test, Y_pred)
cosrec = recall_score(Y_test, Y_pred)
cosF1 = f1_score(Y_test, Y_pred)

euclidean = {'Accuracy' : eucacc, 'Precision' : eucpre, 'Recall' : eucrec, 'F1-Score' : eucF1}
manhattan = {'Accuracy' : manacc, 'Precision' : manpre, 'Recall' : manrec, 'F1-Score' : manF1}
cosine = {'Accuracy' : cosacc, 'Precision' : cospre, 'Recall' : cosrec, 'F1-Score' : cosF1}

compare = pd.DataFrame({'Euclidean' : euclidean, 'Manhattan' : manhattan, 'Cosine' : cosine})
compare
