rm(list = ls())

# load packages
library(tidyverse)
library(tidyr)
library(magrittr)
library(ggplot2)
library(dplyr)

# load data
data <- read.csv('C:/rrData.csv') # data should be 50 obs. x 4 variables
data$participant <- factor(data$participant) # make participant variable a factor
table(data$participant) # should be 10 repeats per participant

# LINE PLOT ----
# reshape the data into long format so that there are 4 columns: participant, time, feature (rr or rr_fft), and value
data_long <- data %>% gather(data, RR, -c(time, participant)) # data_long should be 100 obs. x 4 variables

#define custom labels
plot_names <- c('1'="Participant 1", '2'="Participant 2", '3'="Participant 3", '4'="Participant 4", '5'="Participant 5")

# line plot
ggplot(data_long, aes(time, RR, color=data, group=data))+
  geom_point()+
  geom_line()+
  theme(panel.background = element_blank())+
  xlab("Time (s)")+
  ylab("RR (bpm)")+
  guides(color=guide_legend(title="Feature (Bill)"))+
  ggtitle("Figure 1: Line Plot")+
  facet_wrap(vars(participant), labeller = as_labeller(plot_names))

# BAR PLOT ----
# find the mean and standard deviation within each participant-feature
summary <- data_long %>% group_by(participant, data) %>% summarize(mean = mean(RR), sd =  sd(RR)) # summary should be 10 obs. x 4 variables

# bar plot
ggplot(summary, aes(participant, mean, fill=data))+
  geom_bar(stat="identity", position=position_dodge())+
  geom_errorbar(aes(ymin=mean-sd, ymax=mean+sd), width=.2,position=position_dodge(.9))+
  theme(panel.background = element_blank())+
  xlab("Participant")+
  ylab("RR (bpm)")+
  guides(fill=guide_legend(title="Feature (Bill)"))+
  ggtitle("Figure 2: Bar Plot")
 
# SCATTER PLOT ----
# fit linear model to data, y = rr_fft, x = rr)
fit <- lm(data$rr_fft ~ data$rr)

# combine text for equation
eq <- substitute(italic(y) == a + b %.% italic(x)*", "~~italic(r)^2~"="~r2, 
               list(a = format(unname(coef(fit)[1]), digits = 2),
                    b = format(unname(coef(fit)[2]), digits = 2),
                     r2 = format(summary(fit)$r.squared, digits = 2)))
text <- as.character(as.expression(eq));
 
# scatter plot
ggplot(data, aes(rr, rr_fft))+
  geom_point(alpha=0.5)+
  theme(panel.background = element_blank())+
  xlab("RR (bpm)")+
  ylab("RR FFT (bpm)")+
  ggtitle("Figure 3: Scatter Plot")+
  geom_smooth(method=lm)+
  annotate("text", x = 30, y = 30, label = text, parse = TRUE) 

# BLAND-ALTMAN PLOT ----
# caclulate and save the differences between the two measures and the averages of the two measures
data %<>% mutate(data, dif=rr-rr_fft, avg=(rr+rr_fft)/2)
mean_dif = mean(data$dif)
lower = mean_dif-1.96*sd(data$dif)
upper = mean_dif+1.96*sd(data$dif)

# Bland-Altman plot
ggplot(data, aes(avg, dif)) +
  geom_point(alpha = .25)+
  xlab('Average of Measures (brpm)')+
  ylab('Difference Between Measures (RR - RR_FFT) (brpm)')+
  theme(panel.background = element_blank())+
  annotate('text', x=c(30,30), y=c(30,28), label=c('Mean (LoA)', '6.299 (-9.527 - 22.126)'), color = 'black', size = 4) +
  geom_hline(yintercept=mean_dif)+
  geom_hline(yintercept=lower, color = 'orange', linetype = 'dashed')+
  geom_hline(yintercept=upper, color = 'orange', linetype = 'dashed')+
  geom_hline(yintercept=mean_dif, color ='green', linetype = 'solid')+
  ggtitle("Figure 4: Bland-Altman Plot") 

# BOX PLOT ----
ggplot(data, aes(x=participant, y= rr-rr_fft, col=participant))+
  geom_boxplot()+
  xlab('Participants')+
  ylab('Difference Between Measures (RR - RR_FFT) (brpm)')+
  theme(legend.position ='non', panel.background = element_blank())+
  ggtitle("Figure 5: Box Plot") 
