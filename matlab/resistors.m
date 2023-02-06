Single = csvread('C:\Users\Bill Trader\git\wearable-bioinstrumentation\data\pressureSensorSingleResistor.csv');
Series = csvread('C:\Users\Bill Trader\git\wearable-bioinstrumentation\data\pressureSensorSeriesResistor.csv');
Parallel = csvread('C:\Users\Bill Trader\git\wearable-bioinstrumentation\data\pressureSensorParallelResistor.csv');
R1 = 'Bill Single Resistor: Vout 4.35';
R2 = 'Series Resistors: Vout 3.77';
R3 = 'Parallel Resistors: Vout 4.65';
plot(Single(:,1), Single(:,2), Series(:,1), Series(:,2), Parallel(:,1), Parallel(:,2))
legend(R1, R2, R3)
title('Figure 2. Changing R1')
xlabel('Eleapsed Time (seconds)')
ylabel('Voltage (V)')