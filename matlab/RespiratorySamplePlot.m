Sample = csvread('C:\Users\Bill Trader\git\wearable-bioinstrumentation\data\pressureSensor.csv');
plot(Sample(:,1), Sample(:,2))
title('Figure 3. Individual Respiratory Sample')
xlabel('Eleapsed Time (seconds)')
ylabel('Voltage (V)')