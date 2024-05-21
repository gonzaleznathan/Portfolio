# Multiple Linear and Logistic Regression Analyses of COVID-19 & Transportation Data

## Project Overview

This project investigates the relationship between COVID-19 statistics and transportation data through multiple linear and logistic regression analyses. The aim is to identify significant predictors and patterns that can help understand the spread and impact of COVID-19 in relation to transportation behaviors.

## Motivation

Understanding how transportation patterns influence the spread of COVID-19 is crucial for public health planning and policy-making. This project seeks to provide insights into the variables that significantly affect COVID-19 confirmed cases and fatality rates, which can guide interventions to mitigate the spread of the virus.

## Methodology

### Data Collection and Preparation

- **Trips By Distance Data:** Data was sourced from the Bureau of Transportation Statistics, covering various trip distance categories.
- **COVID-19 Data:** Data was sourced from the CSSEGISandDATA repository on GitHub, containing confirmed cases and fatality statistics.

### Statistical Methods

1. **COVID-19 Statistics Calculation:** Calculated confirmed and fatality rates.
2. **Group Sorting & Analysis:** Grouped data into high, medium, and low confirmed and fatality groups based on quantiles.
3. **Regression Models:** Applied logistic and multiple linear regression models to identify significant predictors.
4. **Model Reduction:** Used `vif()` and `stepAIC()` functions to reduce multicollinearity and select the best models.

### Evaluation

The performance of the models was evaluated using AIC values and VIF to ensure the models were both strong and free of multicollinearity.

## Results

### Logistic Regression

- **High Confirmed Group:** Significant predictors were Trips7 and Trips8, with an AIC of 47.343.
- **Medium Confirmed Group:** No adequately performing model found.
- **Low Confirmed Group:** Significant predictors were Trips8 and the interaction between Trips4 & Trips8, with an AIC of 38.382.

### Multiple Linear Regression

- **High Confirmed Group:** No adequately performing model found.
- **Medium Confirmed Group:** Significant predictors were Trips1, Trips3, Trips4, Trips6, and Trips10, with an R-squared value of 0.71.
- **Low Confirmed Group:** Significant predictors were Trips1, Trips2, Trips3, Trips4, and Trips5, with an R-squared value of 0.69.

### Logistic Regression of Fatality Groups

- **High Fatality Group:** Significant predictors were Trips6 and Trips8, with an AIC of 50.681.
- **Medium Fatality Group:** No adequately performing model found.
- **Low Fatality Group:** Significant predictors were Trips3 and Confirmed Rate, with an AIC of 50.263.

### Multiple Linear Regression of Fatality Groups

- **High Fatality Group:** Significant predictors were Trips2, Trips3, Trips7, Trips9, and Trips10, with an R-squared value of 0.92.
- **Medium Fatality Group:** No adequately performing model found.
- **Low Fatality Group:** No adequately performing model found.

## Key Findings

- **Multicollinearity:** Many models exhibited high multicollinearity, indicating the need for further refinement.
- **Significant Variables:** Trips3, Trips4, and Trips8 were frequently significant predictors across multiple models.
- **Group Differences:** High and low confirmed and fatality groups produced more significant models compared to medium groups.

## Conclusions

This project demonstrates the complexity of modeling COVID-19 statistics with transportation data due to multicollinearity. While significant predictors were identified, further work is needed to refine the models and reduce collinearity. These findings can inform public health strategies and transportation policies to better manage the spread of COVID-19.

