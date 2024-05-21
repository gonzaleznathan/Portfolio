#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Mar 23 03:38:17 2023

@author: nathangonzalez
"""

import pandas as pd
from surprise import Dataset, Reader
from surprise import SVD, KNNBasic
from surprise import accuracy
import seaborn as sns
import matplotlib.pyplot as plt


basefile_path = "/Users/nathangonzalez/Downloads/movielens_100k.base"
testfile_path = "/Users/nathangonzalez/Downloads/movielens_100k.test"

# Define column names
column_names = ['user_id', 'movie_id', 'rating', 'timestamp']

# Load the dataset into a Pandas dataframe
base_data1 = pd.read_csv(basefile_path, sep='\t', names=column_names)
test_data = pd.read_csv(testfile_path, sep='\t', names=column_names)

# Drop the timestamp column
base_data1 = base_data1.drop('timestamp', axis=1)
test_data = test_data.drop('timestamp', axis=1)

# Define the reader to parse the rating scale
reader = Reader(rating_scale=(1, 5))

# Load the data into Surprise's Dataset class
base_data = Dataset.load_from_df(base_data1[['user_id', 'movie_id', 'rating']], reader)

# Retrieve the trainset.
trainset = base_data.build_full_trainset()
testset = test_data.values.tolist()

# Define the model and fit it to the training data
model = KNNBasic()
model.fit(trainset)

# Generate predictions on the test data
predictions = model.test(testset)

# Compute RMSE on the test data
rmse = accuracy.rmse(predictions)

# Make a Table of predictions
userlist = []
movielist = []
ratinglist = []
estimatedlist = []

count = 0

for i in predictions:
    userid = predictions[count].uid
    movieid = predictions[count].iid
    rating = predictions[count].r_ui
    estimated = predictions[count].est

    userlist.append(userid)
    movielist.append(movieid)
    ratinglist.append(rating)
    estimatedlist.append(estimated)
    
    count = count + 1 

userdf = pd.DataFrame(userlist)
moviedf = pd.DataFrame(movielist)
ratingdf = pd.DataFrame(ratinglist)
estimateddf = pd.DataFrame(estimatedlist)

# Create the results table
results = pd.concat([userdf, moviedf, ratingdf, estimateddf], axis=1, ignore_index=True)
results.columns = ['User ID', 'Movie ID', 'Rating', 'Predicted Rating']	

results['Predicted Rounded'] = results['Predicted Rating'].round()
results

# Calculate the accuracies for each rating group
accuracies = []

results1 = results.loc[results['Rating'] == 1]
correct1 = results1.loc[results1['Predicted Rounded'] == 1]
accuracy1 = len(correct1) / len(results1)
accuracies.append(accuracy1)

results2 = results.loc[results['Rating'] == 2]
correct2 = results2.loc[results2['Predicted Rounded'] == 2]
accuracy2 = len(correct2) / len(results2)
accuracies.append(accuracy2)

results3 = results.loc[results['Rating'] == 3]
correct3 = results3.loc[results3['Predicted Rounded'] == 3]
accuracy3 = len(correct3) / len(results3)
accuracies.append(accuracy3)

results4 = results.loc[results['Rating'] == 4]
correct4 = results4.loc[results4['Predicted Rounded'] == 4]
accuracy4 = len(correct4) / len(results4)
accuracies.append(accuracy4)

results5 = results.loc[results['Rating'] == 5]
correct5 = results5.loc[results5['Predicted Rounded'] == 5]
accuracy5 = len(correct5) / len(results5)
accuracies.append(accuracy5)

#Creat a data frame of the accuracy scores
acc = pd.DataFrame(accuracies)
acc.columns = ['y']
acc.insert(0, 'x', range(1, 1 + len(acc)))

#Calculate the total accuracy
totalaccuracy = (len(correct1) + len(correct2) + len(correct3) + len(correct4) + len(correct5))/ len(results)
totalaccuracy

#Plots
ratingsplot = sns.countplot(x="Rating",data=results)
plt.xlabel("Ratings")
plt.ylabel("Frequency")
plt.title("Frequency of Ratings")

predictedplot = sns.countplot(x="Predicted Rounded",data=results)
plt.xlabel("Predicted Ratings")
plt.ylabel("Frequency")
plt.title("Frequency of Predicted Ratings")

accuraciesplot = sns.lineplot(x="x", y = 'y', data=acc)
plt.xlabel("Ratings")
plt.ylabel("Accuracy of Predictions")
plt.title("Accuracy of Predicted Ratings for Each Rating Group")
accuraciesplot.set_xticks(range(1,6))

ratinsandpredictedplot = sns.countplot(x="Rating",data=results, hue="Predicted Rounded")
plt.xlabel("Ratings")
plt.ylabel("Frequency")
plt.title("Frequency of Predicted Ratings by Ratings")
plt.legend(title = "Predicted Ratings", labels=['1', '2', '3', '4', '5'])

def getTop5(user):
    user_id = user
    first = base_data1.loc[base_data1['user_id'] == user_id]
    a = list(first['movie_id'])
    b = list(range(1,1683))
    c = [elem for elem in b if elem not in a ]
    d = [user_id] * len(c)
    e = [0] * len(c)
    f = pd.DataFrame(
        {'user_id': d,
         'movie_id': c,
         'rating': e
        })
    g = f.values.tolist()

    predictionsg = model.test(g)
    movielistg = []
    estimatedlistg = []

    count = 0

    for i in predictionsg:
        movieidg = predictionsg[count].iid
        estimatedg = predictionsg[count].est

        movielistg.append(movieidg)
        estimatedlistg.append(estimatedg)
        
        count = count + 1 

    h = pd.DataFrame(
        {'movie_id': movielistg,
         'predicted': estimatedlistg
        })
    j = h.sort_values('predicted', ascending = False)
    k = j.head(5)
    k['movie_id'] = k['movie_id'].astype(str)
    l = k.values.tolist()
    print(f"Top 5 recommended movies for user {user_id}:")
    for movie_id, rating in l:
        print(f"- Movie ID {movie_id}, predicted rating: {rating:.2f}")
    
getTop5(100)
