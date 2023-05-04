# load packages
library(tidyverse)
library(tidyr)
library(magrittr)
library(ggplot2)
library(dplyr)
library(ggpubr)

### Setup ###

# load data
data <- read.csv('C:/Users/Bill Trader/git/wearable-bioinstrumentation/data/myDataFinal.csv') # data should be 50 obs. x 4 variables
data %<>% mutate(data, Date = as.POSIXct(Date, format ="%m/%d/%Y"))
as_tibble(data)

# convert from seconds to minutes
data$TotalSleepDuration <- data$TotalSleepDuration/60
data$REMSleepDuration <- data$REMSleepDuration/60
data$LightSleepDuration <- data$LightSleepDuration/60
data$DeepSleepDuration <- data$DeepSleepDuration/60
data$TotalSleepHour <- data$TotalSleepDuration/60

### Regression Plots ###

# Video Games vs. Workload
fit <- lm(data$ScreenGame ~ data$Survey2Adjust)
eq <- substitute(italic(y) == a + b %.% italic(x)*", "~~italic(r)^2~"="~r2, 
                 list(a = format(unname(coef(fit)[1]), digits = 2),
                      b = format(unname(coef(fit)[2]), digits = 2),
                      r2 = format(summary(fit)$r.squared, digits = 2)))
text <- as.character(as.expression(eq));

game <- ggplot(data, aes(ScreenGame, Survey2Adjust))+
  geom_point(alpha=0.5)+
  theme(panel.background = element_blank())+
  xlab("Time Spent Playing Video Games [min]")+
  ylab("Next Day's Workload")+
  ggtitle("Time in Video Games vs. Next Day Workload")+
  geom_smooth(method=lm)+
  annotate("text", x = 200, y = 4, label = text, parse = TRUE) 

# Alcohol vs. Workload
fit <- lm(data$Drinks ~ data$Survey2Adjust)
eq <- substitute(italic(y) == a + b %.% italic(x)*", "~~italic(r)^2~"="~r2, 
                 list(a = format(unname(coef(fit)[1]), digits = 2),
                      b = format(unname(coef(fit)[2]), digits = 2),
                      r2 = format(summary(fit)$r.squared, digits = 2)))
text <- as.character(as.expression(eq));

alc <- ggplot(data, aes(Drinks, Survey2Adjust))+
  geom_point(alpha=0.5)+
  theme(panel.background = element_blank())+
  xlab("Alcohol Consumption [Standard Drink]")+
  ylab("Next Day's Workload")+
  ggtitle("Standard Drinks vs. Next Day Workload")+
  geom_smooth(method=lm)+
  annotate("text", x = 12, y = 4, label = text, parse = TRUE) 

# Workload vs. Sleep Score
fit <- lm(data$Survey.2 ~ data$Sleep.Score)
eq <- substitute(italic(y) == a + b %.% italic(x)*", "~~italic(r)^2~"="~r2, 
                 list(a = format(unname(coef(fit)[1]), digits = 2),
                      b = format(unname(coef(fit)[2]), digits = 2),
                      r2 = format(summary(fit)$r.squared, digits = 2)))
text <- as.character(as.expression(eq));

sleep <- ggplot(data, aes(Survey.2, Sleep.Score))+
  geom_point(alpha=0.5)+
  theme(panel.background = element_blank())+
  xlab("Workload")+
  ylab("Sleep Score")+
  ggtitle("Workload vs. Sleep Score")+
  geom_smooth(method=lm)+
  annotate("text", x = 3.5, y = 70, label = text, parse = TRUE) 

figure1 <- ggarrange(game, alc, sleep, ncol=3, nrow=1)
figure1

### Correlation Value Bar Plots ###

# Correlation Calculations 

# alcohol-total sleep
at <- cor(data$Drinks, data$TotalSleepDuration, use = "pairwise.complete.obs")
# alcohol-Rem sleep
arem <- cor(data$Drinks, data$REMSleepDuration, use = "pairwise.complete.obs")
# alcohol-light sleep
al <- cor(data$Drinks, data$LightSleepDuration, use = "pairwise.complete.obs")
# alcohol-deep sleep
ad <- cor(data$Drinks, data$DeepSleepDuration, use = "pairwise.complete.obs")
# alcohol-sleep score
as <- cor(data$Drinks, data$Sleep.Score, use = "pairwise.complete.obs")
# caff-total sleep
ct <- cor(data$Caffeine, data$TotalSleepDuration, use = "pairwise.complete.obs")
# caff-Rem sleep
crem <- cor(data$Caffeine, data$REMSleepDuration, use = "pairwise.complete.obs")
# caff-light sleep
cl <- cor(data$Caffeine, data$LightSleepDuration, use = "pairwise.complete.obs")
# caff-deep sleep
cd <- cor(data$Caffeine, data$DeepSleepDuration, use = "pairwise.complete.obs")
# caff-sleep score
cs <- cor(data$Caffeine, data$Sleep.Score, use = "pairwise.complete.obs")
# work time-total sleep
wt <- cor(data$ScreenWork, data$TotalSleepDuration, use = "pairwise.complete.obs")
# work time-Rem sleep
wrem <- cor(data$ScreenWork, data$REMSleepDuration, use = "pairwise.complete.obs")
# work time-light sleep
wl <- cor(data$ScreenWork, data$LightSleepDuration, use = "pairwise.complete.obs")
# work time-deep sleep
wd <- cor(data$ScreenWork, data$DeepSleepDuration, use = "pairwise.complete.obs")
# work time-sleep score
ws <- cor(data$ScreenWork, data$Sleep.Score, use = "pairwise.complete.obs")
# game time-total sleep
gt <- cor(data$ScreenGame, data$TotalSleepDuration, use = "pairwise.complete.obs")
# game time-Rem sleep
grem <- cor(data$ScreenGame, data$REMSleepDuration, use = "pairwise.complete.obs")
# game time-light sleep
gl <- cor(data$ScreenGame, data$LightSleepDuration, use = "pairwise.complete.obs")
# game time-deep sleep
gd <- cor(data$ScreenGame, data$DeepSleepDuration, use = "pairwise.complete.obs")
# game time-sleep score
gs <- cor(data$ScreenGame, data$Sleep.Score, use = "pairwise.complete.obs")

# bar plots

# Alcohol vs. Sleep
dfa <- data.frame(AlcoholvSleep=c("Total Sleep", "REM Sleep", "Light Sleep", "Deep Sleep", "Sleep Score"),
                 lena=c(at, arem, al, ad, as))
alcVsSleep <- ggplot(dfa, aes(x=AlcoholvSleep, y=lena, fill=AlcoholvSleep)) +
                  geom_bar(stat="identity")+
                  xlab("")+
                  ylab("R-Value")+
                  ggtitle("Correlation Between Alcohol and Sleep Values")+
                  ylim(-1,1)+
                  scale_fill_manual(values=c("darkred", "darkred", "darkgreen", "darkred", "darkred"))+
                  theme(panel.background = element_blank())+
                  theme(legend.position = "none")+
                  geom_abline(slope=0, intercept=0.4,  col = "cyan", lwd=1, lty=2) +
                  geom_abline(slope=0, intercept=0.7,  col = "blue", lwd=1, lty=2)+
                  geom_abline(slope=0, intercept=-0.4,  col = "cyan", lwd=1, lty=2) +
                  geom_abline(slope=0, intercept=-0.7,  col = "blue", lwd=1, lty=2)+
                  geom_abline(slope=0, intercept=0)

# Caff vs. Sleep
dfc <- data.frame(CaffvSleep=c("Total Sleep", "REM Sleep", "Light Sleep", "Deep Sleep", "Sleep Score"),
                 lenc=c(ct, crem, cl, cd, cs))
caffVsSleep <- ggplot(dfc, aes(x=CaffvSleep, y=lenc, fill=CaffvSleep)) +
                  geom_bar(stat="identity")+
                  xlab("")+
                  ylab("R-Value")+
                  ggtitle("Correlation Between Caffeine and Sleep Values")+
                  ylim(-1,1)+
                  scale_fill_manual(values=c("darkred", "darkred", "darkred", "darkred", "darkred"))+
                  theme(panel.background = element_blank())+
                  theme(legend.position = "none")+
                  geom_abline(slope=0, intercept=0.4,  col = "cyan", lwd=1, lty=2) +
                  geom_abline(slope=0, intercept=0.7,  col = "blue", lwd=1, lty=2)+
                  geom_abline(slope=0, intercept=-0.4,  col = "cyan", lwd=1, lty=2) +
                  geom_abline(slope=0, intercept=-0.7,  col = "blue", lwd=1, lty=2)+
                  geom_abline(slope=0, intercept=0)

# Work vs. Sleep
dfw <- data.frame(WorkvSleep=c("Total Sleep", "REM Sleep", "Light Sleep", "Deep Sleep", "Sleep Score"),
                  lenw=c(wt, wrem, wl, wd, ws))
workVsSleep <- ggplot(dfw, aes(x=WorkvSleep, y=lenw, fill=WorkvSleep)) +
                  geom_bar(stat="identity")+
                  xlab("")+
                  ylab("R-Value")+
                  ggtitle("Correlation Between Work Time and Sleep Values")+
                  ylim(-1,1)+
                  scale_fill_manual(values=c("darkgreen", "darkred", "darkred", "darkred", "darkred"))+
                  theme(panel.background = element_blank())+
                  theme(legend.position = "none")+
                  geom_abline(slope=0, intercept=0.4,  col = "cyan", lwd=1, lty=2) +
                  geom_abline(slope=0, intercept=0.7,  col = "blue", lwd=1, lty=2)+
                  geom_abline(slope=0, intercept=-0.4,  col = "cyan", lwd=1, lty=2) +
                  geom_abline(slope=0, intercept=-0.7,  col = "blue", lwd=1, lty=2)+
                  geom_abline(slope=0, intercept=0)

# Game vs. Sleep
dfg <- data.frame(GamevSleep=c("Total Sleep", "REM Sleep", "Light Sleep", "Deep Sleep", "Sleep Score"),
                  leng=c(gt, grem, gl, gd, gs))
gameVsSleep <- ggplot(dfg, aes(x=GamevSleep, y=leng, fill=GamevSleep)) +
                  geom_bar(stat="identity")+
                  xlab("")+
                  ylab("R-Value")+
                  ggtitle("Correlation Between Video Game Time and Sleep Values")+
                  ylim(-1,1)+
                  scale_fill_manual(values=c("darkgreen", "darkred", "darkred", "darkred", "darkred"))+
                  theme(panel.background = element_blank())+
                  theme(legend.position = "none")+
                  geom_abline(slope=0, intercept=0.4,  col = "cyan", lwd=1, lty=2) +
                  geom_abline(slope=0, intercept=0.7,  col = "blue", lwd=1, lty=2)+
                  geom_abline(slope=0, intercept=-0.4,  col = "cyan", lwd=1, lty=2) +
                  geom_abline(slope=0, intercept=-0.7,  col = "blue", lwd=1, lty=2)+
                  geom_abline(slope=0, intercept=0)

figure2 <- ggarrange(alcVsSleep, caffVsSleep, workVsSleep, gameVsSleep, ncol=2, nrow=2)
figure2

### Line Plots of Total Sleep, Workload, and Motivation ###

ggplot(data, aes(Date)) +
  geom_line(aes(y=TotalSleepHour, color='Total Sleep [hour]'), alpha=0.5)+
  geom_point(aes(y=TotalSleepHour, color='Total Sleep [hour]'), alpha=0.5)+
  geom_point(aes(y=Survey.1*2, color='Motivation'), alpha=0.5)+
  geom_line(aes(y=Survey.1*2, color='Motivation'), alpha=0.5)+
  geom_point(aes(y=Survey.2*2, color='Workload'), alpha=0.5)+
  geom_line(aes(y=Survey.2*2, color='Workload'), alpha=0.5)+
  theme(panel.background = element_blank())+
  ylim(0,10)+
  xlab("Date")+
  ylab("")+
  scale_color_manual(name='Legend',
                     breaks=c('Total Sleep [hour]', 'Motivation', 'Workload'),
                     values=c('Total Sleep [hour]'='deepskyblue', 'Motivation'='red', 'Workload'='darkgreen'))+
  ggtitle("Total Sleep Duration Vs. Motivation and Workload")+
  geom_abline(slope=0, intercept=2, lwd=1.5, alpha=.1)+
  geom_abline(slope=0, intercept=10, lwd=1.5, alpha=.1)



### Pearson's Test - Statistical Test ###

# Number of Meals
mt <- cor(data$Meals, data$TotalSleepDuration, use = "pairwise.complete.obs")
mrem <- cor(data$Meals, data$REMSleepDuration, use = "pairwise.complete.obs")
ml <- cor(data$Meals, data$LightSleepDuration, use = "pairwise.complete.obs")
md <- cor(data$Meals, data$DeepSleepDuration, use = "pairwise.complete.obs")
ms <- cor(data$Meals, data$Sleep.Score, use = "pairwise.complete.obs")
me <- cor(data$Meals, data$Efficiency, use = "pairwise.complete.obs")
mlat <- cor(data$Meals, data$Latency, use = "pairwise.complete.obs")
# Caffeine
ce <- cor(data$Caffeine, data$Efficiency, use = "pairwise.complete.obs")
clat <- cor(data$Caffeine, data$Latency, use = "pairwise.complete.obs")
# Alcohol
ae <- cor(data$Drinks, data$Efficiency, use = "pairwise.complete.obs")
alat <- cor(data$Drinks, data$Latency, use = "pairwise.complete.obs")
# Motivation
mott <- cor(data$Survey.1, data$TotalSleepDuration, use = "pairwise.complete.obs")
motrem <- cor(data$Survey.1, data$REMSleepDuration, use = "pairwise.complete.obs")
motl <- cor(data$Survey.1, data$LightSleepDuration, use = "pairwise.complete.obs")
motd <- cor(data$Survey.1, data$DeepSleepDuration, use = "pairwise.complete.obs")
mots <- cor(data$Survey.1, data$Sleep.Score, use = "pairwise.complete.obs")
mote <- cor(data$Survey.1, data$Efficiency, use = "pairwise.complete.obs")
motlat <- cor(data$Survey.1, data$Latency, use = "pairwise.complete.obs")
# Workload
wort <- cor(data$Survey.2, data$TotalSleepDuration, use = "pairwise.complete.obs")
worrem <- cor(data$Survey.2, data$REMSleepDuration, use = "pairwise.complete.obs")
worl <- cor(data$Survey.2, data$LightSleepDuration, use = "pairwise.complete.obs")
word <- cor(data$Survey.2, data$DeepSleepDuration, use = "pairwise.complete.obs")
wors <- cor(data$Survey.2, data$Sleep.Score, use = "pairwise.complete.obs")
wore <- cor(data$Survey.2, data$Efficiency, use = "pairwise.complete.obs")
worlat <- cor(data$Survey.2, data$Latency, use = "pairwise.complete.obs")
# Screen Time Work
swe <- cor(data$ScreenWork, data$Efficiency, use = "pairwise.complete.obs")
swlat <- cor(data$ScreenWork, data$Latency, use = "pairwise.complete.obs")
# Screen Time Game
sge <- cor(data$ScreenGame, data$Efficiency, use = "pairwise.complete.obs")
sglat <- cor(data$ScreenGame, data$Latency, use = "pairwise.complete.obs")
# Screen Time Other
sot <- cor(data$ScreenOther, data$TotalSleepDuration, use = "pairwise.complete.obs")
sorem <- cor(data$ScreenOther, data$REMSleepDuration, use = "pairwise.complete.obs")
sol <- cor(data$ScreenOther, data$LightSleepDuration, use = "pairwise.complete.obs")
sod <- cor(data$ScreenOther, data$DeepSleepDuration, use = "pairwise.complete.obs")
sos <- cor(data$ScreenOther, data$Sleep.Score, use = "pairwise.complete.obs")
soe <- cor(data$ScreenOther, data$Efficiency, use = "pairwise.complete.obs")
solat <- cor(data$ScreenOther, data$Latency, use = "pairwise.complete.obs")
# Screen Time Total
stt <- cor(data$ScreenTotal, data$TotalSleepDuration, use = "pairwise.complete.obs")
strem <- cor(data$ScreenTotal, data$REMSleepDuration, use = "pairwise.complete.obs")
stl <- cor(data$ScreenTotal, data$LightSleepDuration, use = "pairwise.complete.obs")
std <- cor(data$ScreenTotal, data$DeepSleepDuration, use = "pairwise.complete.obs")
sts <- cor(data$ScreenTotal, data$Sleep.Score, use = "pairwise.complete.obs")
ste <- cor(data$ScreenTotal, data$Efficiency, use = "pairwise.complete.obs")
stlat <- cor(data$ScreenTotal, data$Latency, use = "pairwise.complete.obs")
# Activity Score
actt <- cor(data$Activity, data$TotalSleepDuration, use = "pairwise.complete.obs")
actrem <- cor(data$Activity, data$REMSleepDuration, use = "pairwise.complete.obs")
actl <- cor(data$Activity, data$LightSleepDuration, use = "pairwise.complete.obs")
actd <- cor(data$Activity, data$DeepSleepDuration, use = "pairwise.complete.obs")
acts <- cor(data$Activity, data$Sleep.Score, use = "pairwise.complete.obs")
acte <- cor(data$Activity, data$Efficiency, use = "pairwise.complete.obs")
actlat <- cor(data$Activity, data$Latency, use = "pairwise.complete.obs")  
