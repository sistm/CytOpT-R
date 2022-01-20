library(reticulate)
library(tidyverse)
library(base)


source_python(file = "../../inst/python3/CytOpt_plot.py")
source_python(file = "../../inst/python3/minMaxScale.py")
source_python(file = "../../inst/python3/Tools_CytOpt_Descent_Ascent.py")
source_python(file = "../../inst/python3/Tools_CytOpt_MinMax_Swapping.py")


# Data import
# CytOpt estimation
Estimate_Prop <- read.csv('tests/ressources/Res_Estimation_Stan1A.txt', row.names = 1, header = T)
# Benchmark estimation
True_Prop <- read.csv('tests/ressources/True_proportion_Stan1A.txt', row.names = 1, header = T)

Estimate_Prop <- Estimate_Prop[!(row.names(Estimate_Prop) %in% c('Baylor1A')),]
True_Prop <- True_Prop[!(row.names(True_Prop) %in% c('Baylor1A')),]

head(Estimate_Prop)
head(True_Prop)


Estimate_Prop <- convertArray(Estimate_Prop)
True_Prop <- convertArray(True_Prop)

Diff_prop <- getRavel(True_Prop) - getRavel(Estimate_Prop)
Mean_prop <- (getRavel(True_Prop) + getRavel(Estimate_Prop))/2

cat('Percentage of classes where the estimation error is below 10%')
cat(sum(abs(Diff_prop) < 0.1)/length(Diff_prop) * 100)
cat('Percentage of classes where the estimation error is below 5%')
cat(sum(abs(Diff_prop) < 0.05)/length(Diff_prop) * 100)


Classes <- rep(1:10, 61)
Centre_1 <- rep(c('Yale', 'UCLA', 'NHLBI', 'CIMR', 'Miami'), each = 10)
Centre_2 <- rep(c('Standford', 'Yale', 'UCLA', 'NHLBI', 'CIMR', 'Baylor', 'Miami'), each = 10)
Centre <- c(Centre_1, Centre_2, Centre_2, Centre_2,
                    Centre_2, Centre_2, Centre_2, Centre_2, Centre_2)

Patient1A <- rep(1,50)
Patient2 <- rep(2,70)
Patient3 <- rep(3,70)
Patient1 <- rep(1,70)

Patient <- c(Patient1A, Patient2, Patient3,
                     Patient1, Patient2, Patient3,
                     Patient1, Patient2, Patient3)

Dico_res <- list('h_true' = getRavel(True_Prop) , 'h_hat' = getRavel(Estimate_Prop),
            'Diff' = Diff_prop, 'Mean' = Mean_prop, 'Classe' = Classes,
           'Center' = Centre, 'Patient' = Patient)
length(Dico_res$Classe)
df_res_Cytopt <- data.frame(Dico_res)

df_res_Cytopt['Classe'] <- as.factor(df_res_Cytopt[,'Classe'])



sd_diff <- sd(Diff_prop)
cat('Standard deviation:',sd_diff)

Bland_Altman(df_res_Cytopt, sd_diff,length(unique(df_res_Cytopt$Classe)),title='Source observations : Stanford 1A')
