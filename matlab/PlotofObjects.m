None1 = csvread('C:\Users\Bill Trader\git\wearable-bioinstrumentation\data\pressureSensorDataNoObject1.csv');
None2 = csvread('C:\Users\Bill Trader\git\wearable-bioinstrumentation\data\pressureSensorDataNoObject2.csv');
Phone1 = csvread('C:\Users\Bill Trader\git\wearable-bioinstrumentation\data\pressureSensorDataPhone1.csv');
Phone2 = csvread('C:\Users\Bill Trader\git\wearable-bioinstrumentation\data\pressureSensorDataPhone2.csv');
Mic1 = csvread('C:\Users\Bill Trader\git\wearable-bioinstrumentation\data\pressureSensorDataMic1.csv');
Mic2 = csvread('C:\Users\Bill Trader\git\wearable-bioinstrumentation\data\pressureSensorDataMic2.csv');
N1 = 'No Object; Sample 1; R2 = 857.0012';
N2 = 'No Object; Sample 2; R2 = 850.8865';
P1 = 'Phone; Sample 1; R2 = 312.7020';
P2 = 'Phone; Sample 2; R2 = 269.9956';
M1 = 'Mic Stand; Sample 1; R2 = 19.4098';
M2 = 'Mic Stand; Sample 2; R2 = 18.5221';
plot(None1(:,1), None1(:,2), None2(:,1), None2(:,2), Phone1(:,1), Phone1(:,2), ...
    Phone2(:,1), Phone2(:,2), Mic1(:,1), Mic1(:,2), Mic2(:,1), Mic2(:,2))
legend(N1, N2, P1, P2, M1, M2)
title('Figure 1. Calculate Resistance')
xlabel('Eleapsed Time (seconds)')
ylabel('Voltage (V)')