covid19 <- read.csv("~/Downloads/10-31-2020.csv")
#confirmed_rate of 2020
confirmed_rate <- (covid19$Confirmed) / (covid19$People_Tested)
confirmed_rate
confirmed_per <- (covid19$Confirmed) / (covid19$People_Tested) * 100
fatality_rate <- (covid19$Deaths) / (covid19$Confirmed)
fatality_per <- (covid19$Deaths) / (covid19$Confirmed) * 100

# data with data_confirmed
data_confirmed <- data.frame(
  State = covid19$Province_State,
  confirmed_rate = confirmed_rate,
  confirmed_per = confirmed_per,
  fatality_rate = fatality_rate,
  fatality_per = fatality_per
)
data_confirmed

#travel data
trip <- read.csv("~/Downloads/Trips_by_Distance.csv")
trip

# delete the county observations
tripdata <- trip[which(trip$Level == "State"),]

# 1.Pick up trip data of 2020
# 2.Aggregate the transportation data by 2020
require('tidyverse')
trip_1 <- as_tibble(tripdata)
trip_2020 <- trip_1 %>%
  filter(str_detect(tolower(Date), pattern = "2020")) %>%
  group_by(State.Postal.Code) %>%
  summarise_at(vars(Number.of.Trips..1:Number.of.Trips...500), ~sum(.))
trip_2020

#change the variable name of State
names(trip_2020)[1] <- "State"

# Get state names of the data
State <- trip_2020$State
State

# Delete the row of DC
data_name <- trip_2020[-8,]
data_name

# Changing abbreviated state names to full names
state_names <- character(50)
for (i in 1:50) {
  state_names[i] <- state.name[which(state.abb == data_name$State[i])]
}
state_names

#data frame with full state name and "stay at home changed rate" in 2020
data_2 <- data.frame(State = state_names, data_name[2:11])
head(data_2)

# merge data 1 and data 2 to get a new data with interested variables
data <- merge(data_confirmed, data_2, by = "State")
head(data)
str(data)

#FINDING H, L, M
High_confirmed <- data[data$confirmed_rate > quantile(data$confirmed_rate, prob = 1 - 33 / 100),]
High_confirmed
Low_confirmed <- data[data$confirmed_rate < quantile(data$confirmed_rate, prob = 33 / 100),]
Low_confirmed
M_confirmed <- data[data$confirmed_rate < quantile(data$confirmed_rate, prob = 66 / 100),]
M_confirmed
Medium_confirmed <- M_confirmed[M_confirmed$confirmed_rate > quantile(M_confirmed$confirmed_rate, prob = 1 - 50 / 100),]
Medium_confirmed

#Create 3 groups
H_confirmed <- data.frame(Confirmed = High_confirmed$confirmed_per, group = "High")
L_confirmed <- data.frame(Confirmed = Low_confirmed$confirmed_per, group = "Low")
M_confirmed <- data.frame(Confirmed = Medium_confirmed$confirmed_per, group = "Medium")

# combine 3 groups together
ConfirmedPerANOVA <- rbind(H_confirmed, L_confirmed, M_confirmed)
ConfirmedPerANOVA
str(ConfirmedPerANOVA)

#ANOVA for Confirmed Per
ConfirmedPerANOVA_model <- aov(Confirmed ~ group, data = ConfirmedPerANOVA)
summary(ConfirmedPerANOVA_model)
ConfirmedPerANOVA_model

#TUKEYHSD for Confirmed Per
summary(ConfirmedPerANOVA_model)
TukeyHSD(ConfirmedPerANOVA_model, conf.level = 0.95)
plot(TukeyHSD(ConfirmedPerANOVA_model, conf.level = 0.95))

Hcon_data <- data.frame(
  ConfirmedRate = High_confirmed$confirmed_rate,
  ConfirmedPer = High_confirmed$confirmed_per,
  FatalityRate = High_confirmed$fatality_rate,
  FatalityPer = High_confirmed$fatality_per,
  Trips1 = High_confirmed$Number.of.Trips..1,
  Trips2 = High_confirmed$Number.of.Trips.1.3,
  Trips3 = High_confirmed$Number.of.Trips.3.5,
  Trips4 = High_confirmed$Number.of.Trips.5.10,
  Trips5 = High_confirmed$Number.of.Trips.10.25,
  Trips6 = High_confirmed$Number.of.Trips.25.50,
  Trips7 = High_confirmed$Number.of.Trips.50.100,
  Trips8 = High_confirmed$Number.of.Trips.100.250,
  Trips9 = High_confirmed$Number.of.Trips.250.500,
  Trips10 = High_confirmed$Number.of.Trips...500,
  A = 1, B = 0, C = 0
)

Mcon_data <- data.frame(
  ConfirmedRate = Medium_confirmed$confirmed_rate,
  ConfirmedPer = Medium_confirmed$confirmed_per,
  FatalityRate = Medium_confirmed$fatality_rate,
  FatalityPer = Medium_confirmed$fatality_per,
  Trips1 = Medium_confirmed$Number.of.Trips..1,
  Trips2 = Medium_confirmed$Number.of.Trips.1.3,
  Trips3 = Medium_confirmed$Number.of.Trips.3.5,
  Trips4 = Medium_confirmed$Number.of.Trips.5.10,
  Trips5 = Medium_confirmed$Number.of.Trips.10.25,
  Trips6 = Medium_confirmed$Number.of.Trips.25.50,
  Trips7 = Medium_confirmed$Number.of.Trips.50.100,
  Trips8 = Medium_confirmed$Number.of.Trips.100.250,
  Trips9 = Medium_confirmed$Number.of.Trips.250.500,
  Trips10 = Medium_confirmed$Number.of.Trips...500,
  A = 0, B = 1, C = 0
)

Lcon_data <- data.frame(
  ConfirmedRate = Low_confirmed$confirmed_rate,
  ConfirmedPer = Low_confirmed$confirmed_per,
  FatalityRate = Low_confirmed$fatality_rate,
  FatalityPer = Low_confirmed$fatality_per,
  Trips1 = Low_confirmed$Number.of.Trips..1,
  Trips2 = Low_confirmed$Number.of.Trips.1.3,
  Trips3 = Low_confirmed$Number.of.Trips.3.5,
  Trips4 = Low_confirmed$Number.of.Trips.5.10,
  Trips5 = Low_confirmed$Number.of.Trips.10.25,
  Trips6 = Low_confirmed$Number.of.Trips.25.50,
  Trips7 = Low_confirmed$Number.of.Trips.50.100,
  Trips8 = Low_confirmed$Number.of.Trips.100.250,
  Trips9 = Low_confirmed$Number.of.Trips.250.500,
  Trips10 = Low_confirmed$Number.of.Trips...500,
  A = 0, B = 0, C = 1
)

# combine 3 groups together
ConfirmedHML_data <- rbind(Hcon_data, Lcon_data, Mcon_data)
ConfirmedHML_data

#FATALITY SPLITS
High_fatality <- data[data$fatality_rate > quantile(data$fatality_rate, prob = 1 - 33 / 100),]
High_fatality
Low_fatality <- data[data$fatality_rate < quantile(data$fatality_rate, prob = 33 / 100),]
Low_fatality
M_fatality <- data[data$fatality_rate < quantile(data$fatality_rate, prob = 66 / 100),]
M_fatality
Medium_fatality <- M_fatality[M_fatality$fatality_rate > quantile(M_fatality$fatality_rate, prob = 1 - 50 / 100),]
Medium_fatality

#Create 3 groups
H_fatality <- data.frame(Dead = High_fatality$fatality_per, group = "High")
L_fatality <- data.frame(Dead = Low_fatality$fatality_per, group = "Low")
M_fatality <- data.frame(Dead = Medium_fatality$fatality_per, group = "Medium")

# combine 3 groups together
FatalityPerANOVA <- rbind(H_fatality, L_fatality, M_fatality)
FatalityPerANOVA
str(FatalityPerANOVA)

#ANOVA for Confirmed Per
FatalityPerANOVA_model <- aov(Dead ~ group, data = FatalityPerANOVA)
summary(FatalityPerANOVA_model)
FatalityPerANOVA_model

#TUKEYHSD for Confirmed Per
summary(FatalityPerANOVA_model)
TukeyHSD(FatalityPerANOVA_model, conf.level = 0.95)
plot(TukeyHSD(FatalityPerANOVA_model, conf.level = 0.95))

Hfat_data <- data.frame(
  ConfirmedRate = High_fatality$confirmed_rate,
  ConfirmedPer = High_fatality$confirmed_per,
  FatalityRate = High_fatality$fatality_rate,
  FatalityPer = High_fatality$fatality_per,
  Trips1 = High_fatality$Number.of.Trips..1,
  Trips2 = High_fatality$Number.of.Trips.1.3,
  Trips3 = High_fatality$Number.of.Trips.3.5,
  Trips4 = High_fatality$Number.of.Trips.5.10,
  Trips5 = High_fatality$Number.of.Trips.10.25,
  Trips6 = High_fatality$Number.of.Trips.25.50,
  Trips7 = High_fatality$Number.of.Trips.50.100,
  Trips8 = High_fatality$Number.of.Trips.100.250,
  Trips9 = High_fatality$Number.of.Trips.250.500,
  Trips10 = High_fatality$Number.of.Trips...500,
  A = 1, B = 0, C = 0
)

Mfat_data <- data.frame(
  ConfirmedRate = Medium_fatality$confirmed_rate,
  ConfirmedPer = Medium_fatality$confirmed_per,
  FatalityRate = Medium_fatality$fatality_rate,
  FatalityPer = Medium_fatality$fatality_per,
  Trips1 = Medium_fatality$Number.of.Trips..1,
  Trips2 = Medium_fatality$Number.of.Trips.1.3,
  Trips3 = Medium_fatality$Number.of.Trips.3.5,
  Trips4 = Medium_fatality$Number.of.Trips.5.10,
  Trips5 = Medium_fatality$Number.of.Trips.10.25,
  Trips6 = Medium_fatality$Number.of.Trips.25.50,
  Trips7 = Medium_fatality$Number.of.Trips.50.100,
  Trips8 = Medium_fatality$Number.of.Trips.100.250,
  Trips9 = Medium_fatality$Number.of.Trips.250.500,
  Trips10 = Medium_fatality$Number.of.Trips...500,
  A = 0, B = 1, C = 0
)

Lfat_data <- data.frame(
  ConfirmedRate = Low_fatality$confirmed_rate,
  ConfirmedPer = Low_fatality$confirmed_per,
  FatalityRate = Low_fatality$fatality_rate,
  FatalityPer = Low_fatality$fatality_per,
  Trips1 = Low_fatality$Number.of.Trips..1,
  Trips2 = Low_fatality$Number.of.Trips.1.3,
  Trips3 = Low_fatality$Number.of.Trips.3.5,
  Trips4 = Low_fatality$Number.of.Trips.5.10,
  Trips5 = Low_fatality$Number.of.Trips.10.25,
  Trips6 = Low_fatality$Number.of.Trips.25.50,
  Trips7 = Low_fatality$Number.of.Trips.50.100,
  Trips8 = Low_fatality$Number.of.Trips.100.250,
  Trips9 = Low_fatality$Number.of.Trips.250.500,
  Trips10 = Low_fatality$Number.of.Trips...500,
  A = 0, B = 0, C = 1
)

# combine 3 groups together
FatalityHML_data <- rbind(Hfat_data, Lfat_data, Mfat_data)
FatalityHML_data

xDATA <- data.frame(
  Trips1 = ConfirmedHML_data$Trips1,
  Trips2 = ConfirmedHML_data$Trips2,
  Trips3 = ConfirmedHML_data$Trips3,
  Trips4 = ConfirmedHML_data$Trips4,
  Trips5 = ConfirmedHML_data$Trips5,
  Trips6 = ConfirmedHML_data$Trips6,
  Trips7 = ConfirmedHML_data$Trips7,
  Trips8 = ConfirmedHML_data$Trips8,
  Trips9 = ConfirmedHML_data$Trips9,
  Trips10 = ConfirmedHML_data$Trips10
)

library(GGally)
ggpairs(xDATA)

# LOGS FOR CONFIRMED

# High Confirmed
logHighConfirmed <- glm(A ~ FatalityRate + log(Trips1) + log(Trips2) +
                          log(Trips3) + log(Trips4) + log(Trips5) +
                          log(Trips6) + log(Trips7) +
                          log(Trips8) + log(Trips9) +
                          log(Trips10),
                        data = ConfirmedHML_data, family = binomial)
summary(logHighConfirmed)
stepHC <- stepAIC(logHighConfirmed, direction = "both")
summary(stepHC)
logHCfromStep <- glm(formula = A ~ log(Trips1) + log(Trips4) +
                      log(Trips7) + log(Trips8) +
                      log(Trips10), family = binomial, data = ConfirmedHML_data)
summary(logHCfromStep)
car::vif(logHCfromStep)
logHCfromStep1 <- glm(formula = A ~ log(Trips4) +
                      log(Trips7) + log(Trips8) +
                      log(Trips10), family = binomial, data = ConfirmedHML_data)
summary(logHCfromStep1)
car::vif(logHCfromStep1)
logHCfromStep2 <- glm(formula = A ~ log(Trips7) + log(Trips8) +
                      log(Trips10), family = binomial, data = ConfirmedHML_data)
summary(logHCfromStep2)
car::vif(logHCfromStep2)
logHCfromStep3 <- glm(formula = A ~ log(Trips7) + log(Trips8),
                      family = binomial, data = ConfirmedHML_data)
summary(logHCfromStep3)
car::vif(logHCfromStep3)
par(mfrow = c(2, 2))
plot(logHCfromStep3)

#BestModel------CHECK
logHCfromStep4 <- glm(formula = A ~ log(Trips7) + log(Trips8) +
                      log(Trips7) * log(Trips8), family = binomial, data = ConfirmedHML_data)
summary(logHCfromStep4)
car::vif(logHCfromStep4)

# Medium Confirmed
logMediumConfirmed <- glm(B ~ FatalityRate + log(Trips1) + log(Trips2) +
                          log(Trips3) + log(Trips4) + log(Trips5) +
                          log(Trips6) + log(Trips7) +
                          log(Trips8) + log(Trips9) +
                          log(Trips10), data = ConfirmedHML_data, family = binomial)
summary(logMediumConfirmed)
stepMC <- stepAIC(logMediumConfirmed, direction = "both")
summary(stepMC)
logMCfromStep <- glm(formula = B ~ log(Trips2) + log(Trips5) +
                      log(Trips6) + log(Trips7) +
                      log(Trips10), family = binomial, data = ConfirmedHML_data)
summary(logMCfromStep)
car::vif(logMCfromStep)
#Best Model ----- POOR
par(mfrow = c(2, 2))
plot(logMCfromStep)
logMCfromStep1 <- glm(formula = B ~ log(Trips5) + log(Trips6) +
                      log(Trips7) + log(Trips10), family = binomial, data = ConfirmedHML_data)
summary(logMCfromStep1)
car::vif(logMCfromStep1)
logMCfromStep2 <- glm(formula = B ~ log(Trips5) + log(Trips7) +
                      log(Trips10), family = binomial, data = ConfirmedHML_data)
summary(logMCfromStep2)
car::vif(logMCfromStep2)

# Low Confirmed
logLowConfirmed <- glm(C ~ FatalityRate + log(Trips1) + log(Trips2) +
                        log(Trips3) + log(Trips4) + log(Trips5) +
                        log(Trips6) + log(Trips7) +
                        log(Trips8) + log(Trips9) +
                        log(Trips10), data = ConfirmedHML_data, family = binomial)
summary(logLowConfirmed)
stepLC <- stepAIC(logLowConfirmed, direction = "both")
summary(stepLC)
logLCfromStep <- glm(formula = C ~ log(Trips4) + log(Trips7) +
                      log(Trips8), family = binomial, data = ConfirmedHML_data)
summary(logLCfromStep)
car::vif(logLCfromStep)
logLCfromStep1 <- glm(formula = C ~ log(Trips4) + log(Trips8),
                      family = binomial, data = ConfirmedHML_data)
summary(logLCfromStep1)
car::vif(logLCfromStep1)
logLCfromStep2 <- glm(formula = C ~ log(Trips4) + log(Trips8) +
                      log(Trips4) * log(Trips8), family = binomial, data = ConfirmedHML_data)
summary(logLCfromStep2)
car::vif(logLCfromStep2)
#Best Model ---- CHECK
par(mfrow = c(2, 2))
plot(logLCfromStep2)

# Multiple Linear for CONFIRMED

# High Confirmed
HighConfirmed <- lm(ConfirmedPer ~ FatalityRate + (Trips1) + (Trips2) +
                     (Trips3) + (Trips4) + (Trips5) +
                     (Trips6) + (Trips7) +
                     (Trips8) + (Trips9) +
                     (Trips10), data = Hcon_data)
summary(HighConfirmed)
stepHCper <- stepAIC(HighConfirmed, direction = "both")
summary(stepHCper)
HCfromStep <- lm(formula = ConfirmedPer ~ Trips1 + Trips5 + Trips7 + Trips9 +
                  Trips10, data = Hcon_data)
summary(HCfromStep)
car::vif(HCfromStep)
#BestModel ---- POOR
par(mfrow = c(2, 2))
plot(HCfromStep)
HCfromStep1 <- lm(formula = ConfirmedPer ~ Trips7 + Trips9 +
                   Trips10, data = Hcon_data)
summary(HCfromStep1)
car::vif(HCfromStep1)

# Medium Confirmed
MiddleConfirmed <- lm(ConfirmedPer ~ FatalityRate + (Trips1) + (Trips2) +
                       (Trips3) + (Trips4) + (Trips5) +
                       (Trips6) + (Trips7) +
                       (Trips8) + (Trips9) +
                       (Trips10), data = Mcon_data)
summary(MiddleConfirmed)
stepMCper <- stepAIC(MiddleConfirmed, direction = "both")
summary(stepMCper)
MCfromStep <- lm(formula = ConfirmedPer ~ FatalityRate + Trips1 + Trips2 +
                  Trips3 + Trips4 + Trips6 + Trips10, data = Mcon_data)
summary(MCfromStep)
car::vif(MCfromStep)
MCfromStep1 <- lm(formula = ConfirmedPer ~ FatalityRate + Trips1 + Trips3 + Trips4 +
                   Trips6 + Trips10, data = Mcon_data)
summary(MCfromStep1)
car::vif(MCfromStep1)
#BEST MODEL------CHECK
par(mfrow = c(2, 2))
plot(MCfromStep1)
MCfromStep2 <- lm(formula = ConfirmedPer ~ FatalityRate + Trips1 + Trips4 +
                   Trips6 + Trips10, data = Mcon_data)
summary(MCfromStep2)
car::vif(MCfromStep2)

# Low Confirmed
LowConfirmed <- lm(ConfirmedPer ~ FatalityRate + (Trips1) + (Trips2) +
                    (Trips3) + (Trips4) + (Trips5) +
                    (Trips6) + (Trips7) +
                    (Trips8) + (Trips9) +
                    (Trips10), data = Lcon_data)
summary(LowConfirmed)
stepLCper <- stepAIC(LowConfirmed, direction = "both")
summary(stepLCper)
LCfromStep <- lm(formula = ConfirmedPer ~ Trips1 + Trips2 + Trips3 + Trips4 +
                  Trips5, data = Lcon_data)
summary(LCfromStep)
car::vif(LCfromStep)
#Best Model ------ CHECK
par(mfrow = c(2, 2))
plot(LCfromStep)
LCfromStep1 <- lm(formula = ConfirmedPer ~ Trips1 + Trips2 + Trips4 +
                   Trips5, data = Lcon_data)
summary(LCfromStep1)
car::vif(LCfromStep1)

# LOGS FOR Fatality

# High Fatality
logHighFatality <- glm(A ~ ConfirmedRate + log(Trips1) + log(Trips2) +
                        log(Trips3) + log(Trips4) + log(Trips5) +
                        log(Trips6) + log(Trips7) +
                        log(Trips8) + log(Trips9) +
                        log(Trips10), data = FatalityHML_data, family = binomial)
summary(logHighFatality)
stepHF <- stepAIC(logHighFatality, direction = "both")
summary(stepHF)
logHFfromStep <- glm(formula = A ~ log(Trips1) + log(Trips2) + log(Trips4) +
                      log(Trips6) + log(Trips8) + log(Trips10), family = binomial, data = FatalityHML_data)
summary(logHFfromStep)
car::vif(logHFfromStep)
logHFfromStep1 <- glm(formula = A ~ log(Trips1) + log(Trips4) + log(Trips6) +
                       log(Trips8) + log(Trips10), family = binomial, data = FatalityHML_data)
summary(logHFfromStep1)
car::vif(logHFfromStep1)
logHFfromStep2 <- glm(formula = A ~ log(Trips6) + log(Trips8) +
                       log(Trips10), family = binomial, data = FatalityHML_data)
summary(logHFfromStep2)
car::vif(logHFfromStep2)
logHFfromStep3 <- glm(formula = A ~ log(Trips6) + log(Trips8), family = binomial, data = FatalityHML_data)
summary(logHFfromStep3)
car::vif(logHFfromStep3)
#Best Model------ CHECK
par(mfrow = c(2, 2))
plot(logHFfromStep3)
logHFfromStep4 <- glm(formula = A ~ log(Trips6) + log(Trips8) + log(Trips6) *
                       log(Trips8), family = binomial, data = FatalityHML_data)
summary(logHFfromStep4)
car::vif(logHFfromStep4)
logHFfromStep5 <- glm(formula = A ~ log(Trips6), family = binomial, data = FatalityHML_data)
summary(logHFfromStep5)
car::vif(logHFfromStep5)

# Medium Fatality
logMediumFatality <- glm(B ~ ConfirmedRate + log(Trips1) + log(Trips2) +
                          log(Trips3) + log(Trips4) + log(Trips5) +
                          log(Trips6) + log(Trips7) +
                          log(Trips8) + log(Trips9) +
                          log(Trips10), data = FatalityHML_data, family = binomial)
summary(logMediumFatality)
stepMF <- stepAIC(logMediumFatality, direction = "both")
summary(stepMF)
logMFfromStep <- glm(formula = B ~ ConfirmedRate + log(Trips1) + log(Trips2) +
                      log(Trips3) + log(Trips4) + log(Trips6) +
                      log(Trips8) + log(Trips9) +
                      log(Trips10), family = binomial, data = FatalityHML_data)
summary(logMFfromStep)
car::vif(logMFfromStep)
#bestModel (bad p and VIF)-----POOR
par(mfrow = c(2, 2))
plot(logMFfromStep)
logMFfromStep1 <- glm(formula = B ~ ConfirmedRate + log(Trips1) + log(Trips6) + log(Trips8) +
                       log(Trips10), family = binomial, data = FatalityHML_data)
summary(logMFfromStep1)
car::vif(logMFfromStep1)
logMFfromStep2 <- glm(formula = B ~ log(Trips6) + log(Trips8) +
                       log(Trips10), family = binomial, data = FatalityHML_data)
summary(logMFfromStep2)
car::vif(logMFfromStep2)

# Low Fatality
logLowFatality <- glm(C ~ ConfirmedRate + log(Trips1) + log(Trips2) +
                       log(Trips3) + log(Trips4) + log(Trips5) +
                       log(Trips6) + log(Trips7) +
                       log(Trips8) + log(Trips9) +
                       log(Trips10), data = FatalityHML_data, family = binomial)
summary(logLowFatality)
stepLF <- stepAIC(logLowFatality, direction = "both")
summary(stepLF)
logLFfromStep <- glm(formula = C ~ ConfirmedRate + log(Trips3) + log(Trips4),
                      family = binomial, data = FatalityHML_data)
summary(logLFfromStep)
car::vif(logLFfromStep)
logLFfromStep1 <- glm(formula = C ~ ConfirmedRate + log(Trips3),
                      family = binomial, data = FatalityHML_data)
summary(logLFfromStep1)
car::vif(logLFfromStep1)
#final model, significant p values, low AIC ---- CHECK
par(mfrow = c(2, 2))
plot(logLFfromStep1)

# Multiple Linear for FATALITY

# High Fatality
HighFatality <- lm(FatalityPer ~ ConfirmedRate + (Trips1) + (Trips2) +
                    (Trips3) + (Trips4) + (Trips5) +
                    (Trips6) + (Trips7) +
                    (Trips8) + (Trips9) +
                    (Trips10), data = Hfat_data)
summary(HighFatality)
stepHFper <- stepAIC(HighFatality, direction = "both")
summary(stepHFper)
HFfromStep <- lm(formula = FatalityPer ~ ConfirmedRate + Trips1 + Trips2 +
                  Trips3 + Trips4 + Trips6 + Trips7 + Trips8 +
                  Trips9 + Trips10, data = Hfat_data)
summary(HFfromStep)
car::vif(HFfromStep)
HFfromStep1 <- lm(formula = FatalityPer ~ ConfirmedRate + Trips2 +
                   Trips3 + Trips7 + Trips8 + Trips9 + Trips10, data = Hfat_data)
summary(HFfromStep1)
car::vif(HFfromStep1)
HFfromStep2 <- lm(formula = FatalityPer ~ Trips2 +
                   Trips3 + Trips7 + Trips9 + Trips10, data = Hfat_data)
summary(HFfromStep2)
car::vif(HFfromStep2)
#BEST MODEL FOR R-SQUARED
par(mfrow = c(2, 2))
plot(HFfromStep2)
HFfromStep3 <- lm(formula = FatalityPer ~ Trips7 + Trips9 + Trips10, data = Hfat_data)
summary(HFfromStep3)
car::vif(HFfromStep3)
HFfromStep4 <- lm(formula = FatalityPer ~ Trips9 + Trips10, data = Hfat_data)
summary(HFfromStep4)
car::vif(HFfromStep4)
#BEST MODEL FOR LOW COLLINEARITY
par(mfrow = c(2, 2))
plot(HFfromStep4)
HFfromStep5 <- lm(formula = FatalityPer ~ Trips9 + Trips10 + Trips9 * Trips10, data = Hfat_data)
summary(HFfromStep5)
car::vif(HFfromStep5)

# Medium Fatality
MediumFatality <- lm(FatalityPer ~ ConfirmedRate + (Trips1) + (Trips2) +
                      (Trips3) + (Trips4) + (Trips5) +
                      (Trips6) + (Trips7) +
                      (Trips8) + (Trips9) +
                      (Trips10), data = Mfat_data)
summary(MediumFatality)
stepMFper <- stepAIC(MediumFatality, direction = "both")
summary(stepMFper)
MFfromStep <- lm(formula = FatalityPer ~ Trips2 + Trips3 + Trips4 + Trips6 +
                  Trips8 + Trips9 + Trips10, data = Mfat_data)
summary(MFfromStep)
car::vif(MFfromStep)
#BEST MODEL VERY--------POOR
par(mfrow = c(2, 2))
plot(MFfromStep)

# Low Fatality
LowFatality <- lm(FatalityPer ~ ConfirmedRate + (Trips1) + (Trips2) +
                    (Trips3) + (Trips4) + (Trips5) +
                    (Trips6) + (Trips7) +
                    (Trips8) + (Trips9) +
                    (Trips10), data = Lfat_data)
summary(LowFatality)
stepLFper <- stepAIC(LowFatality, direction = "both")
summary(stepLFper)
LFfromStep <- lm(formula = FatalityPer ~ ConfirmedRate + Trips1 + Trips2 +
                  Trips3 + Trips4 + Trips5 + Trips6 + Trips8 +
                  Trips9 + Trips10, data = Lfat_data)
summary(LFfromStep)
car::vif(LFfromStep)
#VERY POOR MODEL
par(mfrow = c(2, 2))
plot(LFfromStep)
LFfromStep1 <- lm(formula = FatalityPer ~ ConfirmedRate + Trips1 + Trips2 +
                   Trips3 + Trips5 + Trips6 + Trips8 + Trips9 +
                   Trips10, data = Lfat_data)
summary(LFfromStep1)
car::vif(LFfromStep1)


