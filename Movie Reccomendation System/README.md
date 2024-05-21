# Movie Recommendation System

## Project Overview

This project aims to build a movie recommendation system using Python. The goal is to analyze user ratings on movies and utilize recommendation system models to provide the best possible movie suggestions. The project compares two methods, KNN and SVD, to determine which produces the best model for movie recommendations.

## Motivation

Recommendation systems are valuable tools in the entertainment industry, enabling companies to enhance customer experiences by providing personalized movie suggestions. This project combines my interest in data analytics and movies to develop a robust recommendation system.

## Methodology

### Data Collection

The dataset contains 100,000 ratings on a scale of 1 to 5 for 1,682 movies, rated by 943 users. The dataset was pre-split into training and testing sets.

### Building the Models

1. **KNN (K-Nearest Neighbors):** This item-based collaborative filtering method clusters data points based on item similarity to make recommendations.
2. **SVD (Singular Value Decomposition):** This method decomposes the user-movie rating matrix to infer missing ratings and provide recommendations.

### Model Evaluation

The models were evaluated using RMSE (Root Mean Squared Error) to measure prediction accuracy.

## Results

### KNN Model

- **RMSE:** 0.9889
- The KNN model predicted ratings of 3 and 4 most frequently, with a lower accuracy in predicting ratings 1, 2, and 5.

### SVD Model

- **RMSE:** 0.9518
- The SVD model also predicted ratings of 3 and 4 most frequently but showed a higher overall accuracy compared to the KNN model.

## Key Findings

- **Model Performance:** The SVD model outperformed the KNN model in terms of RMSE and accuracy.
- **Rating Predictions:** Both models were more accurate in predicting ratings 3 and 4.
- **Recommended Movies:** The recommended movies varied between the two models, indicating that each model has its strengths in identifying user preferences.

## Conclusions

The project demonstrates that while both KNN and SVD models can be used to build movie recommendation systems, the SVD model performs slightly better in terms of accuracy. This finding highlights the importance of model selection in developing effective recommendation systems.

