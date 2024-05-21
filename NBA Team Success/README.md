# Modeling True NBA Competitors

## Project Overview

This project aims to model the on-court success of NBA teams using advanced statistical methods. By leveraging logistic regression and various analytical techniques, I predict the likelihood of NBA teams finishing the season as genuine contenders for the NBA championship. This project underscores the increasing reliance on quantitative analysis in sports, particularly within the NBA, where statistics play a pivotal role in strategic decision-making.

## Motivation

As an avid follower of the NBA, I have always been intrigued by the dynamics of the playoffs, where teams often defy expectations. This project merges my interests in basketball and data analytics to develop a predictive model that identifies true championship contenders. Understanding these factors can significantly impact team strategies and expectations.

## Methodology

### Data Collection

The dataset was sourced from the NBA official website, covering the last 10 NBA regular seasons with 300 observations across 35 predictor variables. The primary variable of interest, the target variable, was created by classifying teams with a top-8 win percentage as true contenders. This top-8 win percentage is very intuitive as 76 out of the 77 NBA Championships have been clinched by teams ranking within the top-8 in league-wide win percentage.

### Logistic Regression

I employed logistic regression in R to predict the top-8 variable. The modeling process involved using stepAIC() and vif() functions to refine the model by reducing multicollinearity and selecting the most significant predictors.

### Model Refinement

1. **Initial Model:** Included all predictor variables, resulting in high multicollinearity.
2. **Stepwise Selection:** Reduced to a model with 13 predictor variables.
3. **Final Model:** Further refined to include only two significant predictors - "Plus/Minus" and "OREB %."

## Results

The final model, with an AIC of 110.423, effectively predicts true contenders with a high degree of accuracy. It highlights the importance of point differentials and offensive rebound percentages in determining team success.

### Key Findings

- **Plus/Minus:** Positively correlates with championship potential.
- **OREB %:** Negatively correlates, indicating potential defensive vulnerabilities.

## Conclusions

The project successfully demonstrates that logistic regression can model the likelihood of NBA teams being true contenders based on historical win percentages. The final model's simplicity, featuring just two predictors, underscores the value of focused statistical analysis in sports analytics.
