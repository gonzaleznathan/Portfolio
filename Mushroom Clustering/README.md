# Clustering Mushroom Species

## Project Overview

This project utilizes k-Nearest Neighbors (kNN) to classify and cluster mushroom species. By applying kNN to the mushroom dataset, the project aims to explore patterns and relationships, distinguishing between edible and poisonous mushrooms—a classic example of a classification task in machine learning.

## Motivation

Clustering methods, such as kNN, are powerful tools for uncovering hidden relationships and organizing information in large datasets. This project aims to demonstrate the utility of kNN in classifying mushroom species, which has practical applications in fields like mycology and food safety.

## Methodology

### Data Collection and Preparation

The dataset consists of descriptions of 23 species of gilled mushrooms from the Agaricus and Lepiota families, with 8,124 observations of 22 features, including cap shape, cap color, and odor. The target variable is whether the mushroom is poisonous or edible. The data was split into training (80%) and testing (20%) sets, and all categorical variables were encoded using the LabelEncoder() function in Python.

### Building the Models

1. **kNN Classifier:** Built using the KNeighborsClassifier() function in Python, tested with different distance metrics (Euclidean, Manhattan, Cosine) and varying numbers of neighbors.
2. **Distance Metrics:** Euclidean, Manhattan, and Cosine distance metrics were used to calculate the nearest neighbors.
3. **Evaluation of k:** Different values of k were evaluated to determine the optimal number of neighbors for the classifier.

### Confusion Matrices

Confusion matrices were used to evaluate the accuracy of each kNN model, providing insights into true positives, true negatives, false positives, and false negatives.

## Results

### Euclidean Distance kNN

- **Accuracy:** 99.88%
- **Observations:** The Euclidean kNN model resulted in two false negatives (edible mushrooms classified as poisonous).

### Manhattan Distance kNN

- **Accuracy:** 100%
- **Observations:** The Manhattan kNN model had no false positives or negatives, achieving perfect classification.

### Cosine Distance kNN

- **Accuracy:** 99.88%
- **Observations:** Similar to the Euclidean kNN, the Cosine kNN model resulted in two false negatives.

## Key Findings

- **Best Distance Metric:** The Manhattan distance metric proved to be the most accurate for the kNN classifier.
- **Optimal Number of Neighbors:** Choosing k=3 avoided overfitting and provided general and comparable results.
- **Comparison with SVM:** The kNN classifiers outperformed the SVM model, with the Manhattan kNN achieving the highest accuracy.

## Conclusions

The kNN classifier, especially with the Manhattan distance metric, is highly effective in classifying mushroom species. Future research could explore the use of Principal Component Analysis (PCA) to reduce dimensionality and potentially improve the performance of kNN classifiers on this dataset.
