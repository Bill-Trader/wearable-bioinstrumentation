% analyzeRESP calculates respiration rate using time and frequency domain
% analyses

function [rr,rr_fft] = analyzeRESP(time,resp,plotsOn)
    % INPUTS: 
    % time: elapsed time (seconds)
    % resp: output from pressure sensor (voltage)
    % plotsOn: true for plots, false for no plots
    
    % OUTPUT:
    % rr: respiration rate (brpm) found from time domain data
    % rr_fft: respiration rate (brpm) found from frequency domain data

    % save orgiinal data
    time_raw = time;
    resp_raw = resp;
    duration = max(time)-min(time);
 
    % calculate fs % FILL IN CODE HERE
    dt = mean(diff(time));
    fs = 1/dt;
   
    % remove offset
    resp = resp - mean(resp);

    % bandpass pass filter resp
    w1 = 0.17; % FILL IN CODE HERE
    w2 = 1; % FILL IN CODE HERE
    resp = bandpass(resp,[w1 w2],fs);

    % find peaks
    [pks,locs] = findpeaks(resp);
    x_peaks = time(locs);

    % calcuate rr
    rr = length(pks)*60/duration; % FILL IN CODE HERE

    % fft
    L = fs*duration;
    R = fft(resp); 
    f = fs*(0:(L/2))/L; % FILL IN CODE HERE (look at fft documentation)
    P2 = abs(R/L);
    P1 = P2(1:L/2+1); % FILL IN CODE HERE (look at fft documentation)
    P1(2:end-1) = 2*P1(2:end-1);

    % calcuate rrFft
    [P1_max, index] = max(P1);
    freq_max = f(index);
    rr_fft = freq_max*60; % FILL IN CODE HERE (hint: look at max documentation)

    if plotsOn
        figure % FILL IN CODE HERE to add legends, axes labels, and * for peaks
        subplot(3,1,1) 
        plot(time_raw,resp_raw)
        title('Provided Sample')
        xlabel('Elapsed Time (s)')
        ylabel('Voltage (V)')
        
        subplot(3,1,2)
        plot(time,resp,x_peaks,pks,'*')
        xlabel('Elapsed Time (s)')
        ylabel('Filtered Voltage (V)')
        S1 = 'Provided RR (brpm): ';
        S2 = string(rr);
        legend('RESP', strcat(S1,S2))
        
        subplot(3,1,3)
        plot(f,P1)
        hold on
        plot(freq_max,P1_max,'*')
        hold off
        xlabel('Frequency (Hz)')
        ylabel('|P1(f)|')
        S3 = 'Provided RR FFT (brpm): ';
        S4 = string(rr_fft);
        legend('RESP', strcat(S3,S4))
    end
end