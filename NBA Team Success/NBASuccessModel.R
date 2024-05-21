library(MASS)
library(ggplot2)
library(car)
library(tidyverse)
library(broom)
library(glmnet)
library(plyr)
library(corrplot)

#Import dataset
data<-NBADATAMINING2
data

#Rename some columns
names(data)[10] ='FG %'
names(data)[11] ='3PM'
names(data)[12] ='3PA'
names(data)[13] ='3P %'
names(data)[16] ='FT %'
names(data)[27] ='Plus/Minus'
names(data)[31] ='Ast %'
names(data)[32] ='Ast/TO'
names(data)[33] ='Ast Ratio'
names(data)[34] ='OREB %'
names(data)[35] ='DREB %'
names(data)[36] ='REB %'
names(data)[37] ='TOV %'
names(data)[38] ='EFG %'
names(data)[39] ='TS %'

#Create train and test sets
data2 <- data[,-c(1,2,3,4,5,6)]

train  <- data2[1:300, ]
test   <- data[301:330, ]

#Correlation Matrix
CorMatrix <- cor(train)
par(mfrow=c(1,1))
corrplot(CorMatrix, method="color")

Correlation <- cor(train)
Correlation

library(Hmisc)
describe(train)

#Full model
Full_Model <- glm(TOP8 ~ ., data = train, family = "binomial")
summary(Full_Model)
AIC(Full_Model)
par(mfrow=c(2,2))
plot(Full_Model)
vif(Full_Model)

#Stepwise selection
Best_model <- stepAIC(Full_Model, direction = "both", trace = FALSE)
summary(Best_model)
AIC(Best_model)
par(mfrow=c(2,2))
plot(Best_model)
vif(Best_model)

#Model with only significant variables from previous stepwise selection
Model2 <- glm(formula = TOP8 ~ PTS + FGA + `3PA` + `3P %` + FTM + `FT %` + 
                `Plus/Minus` + OFFRTG + `Ast %` + `Ast Ratio` + `OREB %` + `TS %`
              , family = "binomial", data = train)
summary(Model2)
AIC(Model2)
vif(Model2)

#Stepwise selection from model 2
Best_model2 <- stepAIC(Model2, direction = "both", trace = FALSE)
summary(Best_model2)
AIC(Best_model2)
par(mfrow=c(2,2))
plot(Best_model2)
vif(Best_model2)

#Model with only significant variables from previous stepwise selection
Model3 <- glm(formula = TOP8 ~ PTS + `3P %` + FTM + `Plus/Minus` + 
                OFFRTG + `Ast %` + `Ast Ratio` + `OREB %`
              , family = "binomial", 
              data = train)
summary(Model3)
AIC(Model3)
vif(Model3)

#Stepwise selection from model 3
Best_model3 <- stepAIC(Model3, direction = "both", trace = FALSE)
summary(Best_model3)
AIC(Best_model3)
par(mfrow=c(2,2))
plot(Best_model3)
vif(Best_model3)

#Model with only significant variables from previous stepwise selection
Model4 <- glm(formula = TOP8 ~ `Plus/Minus` + `OREB %`, family = "binomial", 
              data = train)
summary(Model4)
AIC(Model4)
par(mfrow=c(2,2))
plot(Model4)
vif(Model4)

#Setting up predictions for final model
predictions <- predict(Model4, newdata = test)
predictions

predictionsODDS <- exp(predictions)
predictionsODDS

predictionsPROB <- predictionsODDS/(predictionsODDS+1)
predictionsPROB

TeamsTest <- test[c(2,3)]
TeamsTest[3] <- predictionsPROB
names(TeamsTest)[3] = "Top8"
print(TeamsTest, n = 30)

#Sort predictions by top-8 probability
TeamsTestSort <- TeamsTest[order(-TeamsTest$Top8),]
print(TeamsTestSort, n = 30)

write.csv(TeamsTestSort,"/Users/nathangonzalez/Desktop/finalpred.csv", row.names = FALSE)

#Setting up predictions for first stepwise model
badpredictions <- predict(Best_model, newdata = test)
badpredictions

badpredictionsODDS <- exp(badpredictions)
badpredictionsODDS

badpredictionsPROB <- badpredictionsODDS/(badpredictionsODDS+1)
badpredictionsPROB

InitialTeamsTest <- test[c(2,3)]
InitialTeamsTest[3] <- badpredictionsPROB
names(InitialTeamsTest)[3] = "Top8"
print(InitialTeamsTest, n = 30)

#Sort predictions by top-8 probability
InitialTeamsTestSort <- InitialTeamsTest[order(-InitialTeamsTest$Top8),]
print(InitialTeamsTestSort, n = 30)

write.csv(InitialTeamsTestSort,"/Users/nathangonzalez/Desktop/badpred.csv", row.names = FALSE)

#Plot AICs and VIFs
vifs = c(mean(vif(Full_Model)), mean(vif(Best_model)), mean(vif(Model2)),
         mean(vif(Best_model2)), mean(vif(Model3)), mean(vif(Best_model3)))
aics = c(AIC(Full_Model), AIC(Best_model), AIC(Model2),
         AIC(Best_model2), AIC(Model3), AIC(Best_model3))
order = c(0,1,2,3,4,5)

# Create a data frame to store this information
stepdata = data.frame(Order = factor(order), VIFs = vifs, AICs = aics)

# Separate plot for VIFs
vif_plot <- ggplot(stepdata, aes(x = Order, y = VIFs, group = 1)) +
  geom_line(color = "blue") +
  geom_point(color = "blue", size = 3) +
  labs(x = "Variable Filtration Step", y = "Average VIF", title = "Average VIF Across Variable Filtration Steps") +
  theme_minimal()

# Separate plot for AICs
aic_plot <- ggplot(stepdata, aes(x = Order, y = AICs, group = 1)) +
  geom_line(color = "red") +
  geom_point(color = "red", size = 3) +
  labs(x = "Variable Filtration Step", y = "AIC", title = "AIC Across Variable Filtration Steps") +
  theme_minimal()

# Display the plots
print(vif_plot)
print(aic_plot)

# Separate plot for VIFs
vif_plot2 <- ggplot(stepdata[2:6,], aes(x = Order, y = VIFs, group = 1)) +
  geom_line(color = "blue") +
  geom_point(color = "blue", size = 3) +
  labs(x = "Variable Filtration Step", y = "Average VIF", title = "Average VIF Across Variable Filtration Steps") +
  theme_minimal()

# Separate plot for AICs
aic_plot2 <- ggplot(stepdata[2:6,], aes(x = Order, y = AICs, group = 1)) +
  geom_line(color = "red") +
  geom_point(color = "red", size = 3) +
  labs(x = "Variable Filtration Step", y = "AIC", title = "AIC Across Variable Filtration Steps") +
  theme_minimal()

# Display the plots
print(vif_plot2)
print(aic_plot2)

trythis = stepdata[2:6,]
