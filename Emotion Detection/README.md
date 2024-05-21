# Emotion Recognition with a PCA Classifier

## Project Overview

This project focuses on recognizing human emotions from speech using a Principal Component Analysis (PCA) classifier. The aim is to classify the emotion of speech signals accurately by leveraging PCA, which is widely used for pattern recognition problems.

## Motivation

Human speech is a crucial medium for emotional expression, and accurately classifying emotions through speech can enhance various applications in technology and communication. This project explores the strengths and limitations of PCA in recognizing emotions from speech data.

## Methodology

### Data Collection and Preparation

The project uses the CREMA-D dataset, which includes 7,442 voice recordings from 91 actors of different ages, sexes, races, and ethnicities. The data was processed and analyzed using the Julia programming language.

### Building the Models

1. **PCA Classifier:**
   - Calculated the covariance matrix of the training data.
   - Found and sorted the eigenvalues to compute the projection matrix.
   - Created the projection matrix using the top two eigenvectors.
   - Generated projections and built a decision tree using the NearestNeighbors package.

2. **Kernel PCA (KPCA):**
   - Applied three kernels (cosine distance, Chebyshev distance, Jaccard distance) to the PCA method.

3. **Reduced Models:**
   - Created models with only two emotions as classes to understand relationships and differences better.

### Evaluation

The performance of the models was evaluated using accuracy metrics and confusion matrices.

## Results

### Basic PCA

- **Accuracy:** 37.31% (kNN = 25)
- **Observations:** Basic PCA struggled with classifying emotions, performing better for anger, neutral, and sad emotions, while poorly recognizing disgust and fear.

### Applying Kernels (KPCA)

- **Cosine Distance KPCA:** 23.58% (kNN = 25)
- **Chebyshev Distance KPCA:** 31.94% (kNN = 25)
- **Jaccard Distance KPCA:** 39.10% (kNN = 25)

### Reduced Models

To further investigate the classification abilities of PCA, reduced emotion models were proposed. These models focused on pairs of emotions to understand the relationships better. The accuracies for each pair are listed below:

| Pair of Emotions     | Accuracy (kNN = 25) |
|----------------------|----------------------|
| Anger, Sad           | 92.06%               |
| Happy, Sad           | 84.75%               |
| Sad, Neutral         | 83.02%               |
| Anger, Neutral       | 80.68%               |
| Anger, Disgust       | 76.19%               |
| Happy, Fear          | 68.75%               |
| Fear, Neutral        | 68.42%               |
| Anger, Fear          | 67.16%               |
| Happy, Anger         | 65.76%               |
| Fear, Sad            | 63.89%               |
| Disgust, Neutral     | 62.26%               |
| Happy, Disgust       | 62.12%               |
| Sad, Disgust         | 61.76%               |
| Happy, Neutral       | 60.71%               |
| Fear, Disgust        | 50.12%               |

## Key Findings

- **PCA Limitations:** Basic PCA was insufficient for accurate emotion classification.
- **KPCA Improvement:** The Jaccard distance kernel marginally improved classification accuracy.
- **Emotion Relationships:** Reduced models highlighted how PCA perceives relationships between different emotions.

## Conclusions

PCA alone may not be sufficient for building an accurate emotion classifier from speech. Introducing kernels improved the model marginally, but significant gains were seen with reduced emotion models. Future advancements could explore integrating PCA with additional machine learning layers to account for demographic differences before emotion classification.

