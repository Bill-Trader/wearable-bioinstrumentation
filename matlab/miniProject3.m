clear 
clc
close all

% connect arduino
a = arduino();

% define variables and call pressureSensor function
sampleTime = 5*60;
thresh = 2;
livePlot = false;
pauseTime = 0;
[data] = pressureSensor(a,sampleTime,thresh,livePlot,pauseTime);

% save pressureSensor output table to a csv in your data folder
writetable(data,'C:\Users\Bill Trader\git\wearable-bioinstrumentation\data\pressureSensor2.csv')

% plot voltage over time
figure
plot(data.time,data.voltage)

% calcuate data acqusition rate
dt = mean(diff(data.time));
fs = 1/dt;
display(fs);

% calculate R2 using R1, Vin, and Vout
r1 = 100;
Vin = 5;
r2 = mean(([data.voltage]*r1)./(Vin-[data.voltage]));
display(r2);