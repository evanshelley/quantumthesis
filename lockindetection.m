%% Thesis Simulations - Lock In Detection

% all variables marked with the following border can be modified for
% observing different results:
%=========================================================================%
% example_variable = 123;
%=========================================================================%

% running will generate 4 figures:
% Figure 1: Input / reference signal before and after decimation, and their
%       FFTs
% Figure 2: Noise periodograms for the generated white and pink noise to be
%       applied to the system
% Figure 3: Filter frequency response as a visualiser for what the filter
%       is doing
% Figure 4: Noiseless signal with tunneling event, noisy signal Vs with
%       tunneling event and recovered signal amplitude A after detection


clear;clc;close all;
%% Define input signal

%=========================================================================%
fosc = 10e6;   % frequency at which the system will operate (bias tone f & reference f)
%=========================================================================%

% time resolution, time and sampling f

%=========================================================================%
sigduration = 80;    % signal duration, in microseconds
%=========================================================================%

Fsorig = 500e6;     % sampling freq is 500MS/s
dt = 1/Fsorig;     % Ts
Lorig = sigduration * 1e-6 * Fsorig;     % amount of time units as a multiple of sampling freq, 500MS/s
torig = (0:(Lorig-1))*dt; % time

% amplitude of main oscillations
A1 = 10e-6;     % 10 microseconds

% Vin is input signal to system
Vin = A1*sin(2*pi*fosc*torig);


%% decimate signal

%=========================================================================%
M = 1;    % decimation factor, set to 1 for no decimation
%=========================================================================%

L = Lorig/M;
Fs = Fsorig/M;

% in matlab, decimate has in built anti-aliasing filter
% downsample does not
Vindec = downsample(Vin,M);

t = downsample(torig,M);


%% plot bias tone, decimated bias tone and their FFT's

% plot Vin
subplot(2,2,1);
plot(torig/1e-6,Vin/1e-6,'LineWidth',2);
xlabel("Time (\mus)",'FontSize',18);
ylabel("Voltage (\muV)",'FontSize',18);
title(strcat("(a) Input signal V_{r} at f = ",num2str(fosc/1e6),"MHz", ", Fs = ",num2str(Fsorig/1e6),"MHz"),'FontSize',18);
ylim([-(max(abs(Vin/1e-6))+0.1*max(abs(Vin/1e-6))) (max(abs(Vin/1e-6))+0.1*max(abs(Vin/1e-6)))]);
xlim([0 1]);
grid on;
set(gca,'FontSize',26)


% plot FFT of Vin
Y = fft(Vin);

P2 = abs(Y/Lorig);
P1 = P2(1:Lorig/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fsorig * (0:(Lorig/2))/Lorig;

subplot(2,2,2);
plot(f/1e6,P1/1e-6,'LineWidth',2);
xlabel("Frequency (MHz)",'FontSize',18);
ylabel("|P1(f)| (\muV)",'FontSize',18);
title(strcat("(b) FFT of V_{r} at f = ",num2str(fosc/1e6),"MHz", ", Fs = ",num2str(Fsorig/1e6),"MHz"),'FontSize',18);
xlim([0 12e1]);
ylim([-(0.1*max(abs(P1/1e-6))+0.1*max(abs(P1/1e-6))) (max(abs(P1/1e-6))+0.1*max(abs(P1/1e-6)))]);
xline(Fsorig/2e6,'Color','r','LineStyle','--', 'LineWidth',2);    % line at nyquist limit
legend("|P1(f)|","Nyquist limit",'FontSize',18);
grid on;
set(gca,'FontSize',26)

% plot Vindec
subplot(2,2,3);
plot(t/1e-6,Vindec/1e-6,'LineWidth',2);
xlabel("Time (\mus)",'FontSize',18);
ylabel("Voltage (\muV)",'FontSize',18);
title(strcat("(c) Input signal V_{r,dec} at f = ",num2str(fosc/1e6),"MHz", ", Fs = ",num2str(Fs/1e6),"MHz", ", M = ",num2str(M)),'FontSize',18);
ylim([-(max(abs(Vindec/1e-6))+0.1*max(abs(Vindec/1e-6))) (max(abs(Vindec/1e-6))+0.1*max(abs(Vindec/1e-6)))]);
grid on;
xlim([0 1]);
set(gca,'FontSize',26)

% plot FFT of Vindec
Y = fft(Vindec);

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = (Fsorig/M) * (0:(L/2))/L;

subplot(2,2,4);
plot(f/1e6,P1/1e-6,'LineWidth',2);
xlabel("Frequency (MHz)",'FontSize',18);
ylabel("|P1(f)| (\muV)",'FontSize',18);
title(strcat("(d) FFT of V_{r,dec} at f = ",num2str(fosc/1e6),"MHz", ", Fs = ",num2str(Fs/1e6),"MHz"),'FontSize',18);
xlim([0 12e1]);
ylim([-(0.1*max(abs(P1/1e-6))+0.1*max(abs(P1/1e-6))) (max(abs(P1/1e-6))+0.1*max(abs(P1/1e-6)))]);
xline(Fs/2e6,'Color','r','LineStyle','--', 'LineWidth',2);    % line at nyquist limit
legend("|P1(f)|","Nyquist limit",'FontSize',18);
grid on;
set(gca,'FontSize',26)


%% Simulate measurements (tunnelling events)

% event occurs at a random time, but not in the first or last 20% of the
% signal
event_time = ceil((rand * 0.6 * L) + (0.2 * L));

%=========================================================================%
event_duration = 0.25;      % tunneling event duration in microseconds
%=========================================================================%

% convert duration to # of samples
event_duration_samples = event_duration * 1e-6 * Fs;

Vevent = Vindec;

%=========================================================================%
event_coefficient = 5;  % magnitude of event compared to reference signal input, ie event will give 5x SET current
%=========================================================================%

% modulate signal with event
Vevent(event_time:(event_time + event_duration_samples)) = event_coefficient * Vevent(event_time:(event_time + event_duration_samples));

%% Simulate noise, phase shift and amplification

% white noise amplitude as a percentage of bias signal, so noiseA = 1 gives
% approx. max(abs(Vin)) = max(abs(whitenoise))
%=========================================================================%
whitenoiseA = 1;    % white noise amplitude as a percentage of bias signal
%=========================================================================%

% pink noise amplitude as a percentage of bias signal, so noiseA = 1 gives
% approx. max(abs(Vin)) = max(abs(pinknoise))
%=========================================================================%
pinknoiseA = 1;     % pink noise amplitude as a percentage of bias signal
%=========================================================================%

% generate white and pink noise
noisewhite = 2 * (rand(1,length(Vevent)) * whitenoiseA * A1 - (whitenoiseA * A1)/2);
noisepink = pinkusnoise(1,length(Vevent)) * pinknoiseA * 1.15 * A1;

% generate noise signal
noise = noisewhite + noisepink;

% find SNR of signal to be created
noisePower = sum(noise.^2) / length(noise);
signalPower = sum(Vevent.^2) / length(Vevent);
SNR = 10*log10(signalPower / noisePower)

% add noise to modulated signal
Vnoise = Vevent + noise;


% PHASE SHIFT

%=========================================================================%
phase_shift = 0;   % value between 0 and 2*pi
%=========================================================================%

% only necessary if there is a phase shift
if phase_shift ~= 0
    
    % convert phase shift to amount of samples to shift by
    % Fs/fosc gives samples per period
    phase_shift_samples = round((Fs/fosc) * phase_shift * (1/(2*pi)));

    % logical rotate values in signal to the right by phase_shift_samples
    phase_shift_buffer = Vnoise((end - phase_shift_samples + 1):end);
    Vnoise(phase_shift_samples:end) = Vnoise(1:(end - phase_shift_samples+1));
    Vnoise(1:phase_shift_samples) = phase_shift_buffer;
    
end

% signal amplification
% Vs is in order of 1mV to 10mV
Vs = Vnoise * 1e2;


%% plot noise spectra

figure;
subplot(3,1,1);
N = length(noisepink);
xdft = fft(noisepink);
xdft = xdft(1:N/2+1);
psdx = (1/(Fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:Fs/length(noisepink):Fs/2;
psdx(1) = 0;

plot(freq,10*log10(psdx),'LineWidth',2)
grid on
title('Pink Noise Periodogram','FontSize',18)
xlabel('Frequency (Hz)','FontSize',18)
ylabel('Power/Frequency (dB/Hz)','FontSize',18)
xlim([0 50e6]);
ylim([-220 -140]);
set(gca,'FontSize',22)

subplot(3,1,2);
N = length(noisewhite);
xdft = fft(noisewhite);
xdft = xdft(1:N/2+1);
psdx = (1/(Fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:Fs/length(noisewhite):Fs/2;


plot(freq,10*log10(psdx),'LineWidth',2)
grid on
title('White Noise Periodogram','FontSize',18)
xlabel('Frequency (Hz)','FontSize',18)
ylabel('Power/Frequency (dB/Hz)','FontSize',18)
xlim([0 50e6]);
ylim([-220 -140]);
set(gca,'FontSize',22)

subplot(3,1,3);
N = length(noise);
xdft = fft(noise);
xdft = xdft(1:N/2+1);
psdx = (1/(Fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:Fs/length(noise):Fs/2;
psdx(1) = 0;

plot(freq,10*log10(psdx),'LineWidth',2)
grid on
title('White + Pink Noise Periodogram','FontSize',18)
xlabel('Frequency (Hz)','FontSize',18)
ylabel('Power/Frequency (dB/Hz)','FontSize',18)
xlim([0 50e6]);
ylim([-220 -140]);
set(gca,'FontSize',22)


%% Circular buffer declarations

%=========================================================================%
bufperiods = 2;     % # of periods of the signal to fit in the buffer
%=========================================================================%

% bufsize is samples per bufperiods
%   Fs/fosc gives samples per period.
bufsize = ceil(bufperiods * (Fs / fosc));

circbuffer = zeros(1,bufsize);

% reference signals, same oscillation freq as input
Vref1 = sin(2*pi*fosc*t);
Vref2 = cos(2*pi*fosc*t);
     
% final result
A_avg = zeros(1,(length(Vref1)-bufsize));


%% filter creation & visualisation
% for now just moving average filter
% not actually using the filter generated here, implementation is done by
% actually doing a moving average. This is just generating the equivalent
% for visualisation. When using a different filter in the future it will be
% created here

omega_filt = 2*pi*(0:100:40e6)/Fs;
Hfilt = zeros(1,length(omega_filt));

% generate filter visualisation
for i = 1:length(omega_filt)
    
    Hfilt(i) = 10*log10((abs(sin((omega_filt(i)*bufsize)/2)^2/(sin((omega_filt(i))/2))^2)/bufsize^2));

end

% find cutoff frequency very roughly
cutoff_sample = 0;

for i = 1:length(Hfilt)
    if (Hfilt(i) <= -3)
        cutoff_sample = i;
        break;
    end
end

% plot filter frequency response
figure;
plot((omega_filt*Fs/(2*pi*1e6)),Hfilt,'LineWidth',2);
xlabel("Frequency (MHz)",'FontSize',18);
ylabel("Magnitude (dB)",'FontSize',18);
title(strcat("Simple Moving Average Filter Frequency Response"),'FontSize',18);
ylim([-100 0]);
xline((omega_filt(cutoff_sample)*Fs/(2*pi*1e6)),'Color','r','LineStyle','--', 'LineWidth',2);    % line at nyquist limit
legend(" Magnitude Response",strcat(" f_c = ",num2str(omega_filt(cutoff_sample)*Fs/(2*pi*1e6)), "MHz"),'FontSize',18);
grid on;
set(gca,'FontSize',26)


%% Process the signal

% perform mixing after circular buffer implementation - may not be
% necessary, just leaving here in case
%{
for n = 0:(length(Vref1)-bufsize-1)
    
    % load buffer with values from Vs
    circbuffer = Vs((1+n):(bufsize+n));
    
    % signals after mixing with local oscillator
    Vmixed1 = circbuffer .* Vref1((1+n):(bufsize+n));
    Vmixed2 = circbuffer .* Vref2((1+n):(bufsize+n));
    
    % recovered signal amplitude A
    A = 2*sqrt(Vmixed1.^2 + Vmixed2.^2);
    
    % take mean of values of A in the buffer: this performs a LPF
    % operation
    A_avg(n+1) = mean(A);
    
end
%}

% perform mixing after circular buffer implementation
Vmixed1 = Vs .* Vref1;
Vmixed2 = Vs .* Vref2;

circbuffer1 = zeros(1,bufsize);
circbuffer2 = zeros(1,bufsize);

for n = 0:(length(Vref1)-bufsize-1)
    
    % load buffer with values from Vs
    circbuffer1 = Vmixed1((1+n):(bufsize+n));
    circbuffer2 = Vmixed2((1+n):(bufsize+n));
    
    % recovered signal amplitude A
    A = 2*sqrt(circbuffer1.^2 + circbuffer2.^2);
    
    % take mean of values of A in the buffer: this performs a LPF
    % operation - moving average
    A_avg(n+1) = mean(A);
    
end

% find delay caused by filter; for moving average filters the
% delay is (N-1)/2, where N is number of samples averaged over
delay = ceil((bufsize - 1) / 2);

% output signal is padded with zeros at the start and end so it is of the
% same length as the input signal for comparison. We are only interested
% what is in the middle of the signal, not what is at the immediate start
% and end.
A_avg = horzcat(zeros(1,(ceil(bufsize/2))),A_avg,zeros(1,(floor(bufsize/2))));

% adjust for delay introduced by filtering
A_avg = horzcat(A_avg((delay+1):end),zeros(1,delay));


%% Plot output signal compared to input signal with and without noise

figure;
% plot Vevent
subplot(3,1,1);
plot(t/1e-6,Vevent/1e-3,'LineWidth',2);
xlabel("Time (\mus)",'FontSize',18);
ylabel("Voltage (mV)",'FontSize',18);
title(strcat("(a) Signal after event V_{event}"),'FontSize',18);
ylim([-(max(abs(Vevent/1e-3))+0.2*max(abs(Vevent/1e-3))) (max(abs(Vevent/1e-3))+0.2*max(abs(Vevent/1e-3)))]);
grid on;
set(gca,'FontSize',26)

subplot(3,1,2);
plot(t/1e-6,Vs/1e-3,'LineWidth',2);
xlabel("Time (\mus)",'FontSize',18);
ylabel("Voltage (mV)",'FontSize',18);
title(strcat("Amplified signal with noise V_{s}"),'FontSize',18);
ylim([-(max(abs(Vs/1e-3))+0.1*max(abs(Vs/1e-3))) (max(abs(Vs/1e-3))+0.1*max(abs(Vs/1e-3)))]);
grid on;
set(gca,'FontSize',26)

subplot(3,1,3);
plot(t/1e-6,A_avg/1e-3,'LineWidth',2);
xlabel("Time (\mus)",'FontSize',18);
ylabel("Voltage (mV)",'FontSize',18);
title(strcat("Recovered Signal Amplitude A, bufperiods=",num2str(bufperiods), " SNR=",num2str(SNR),"dB"),'FontSize',18);
ylim([-(max(abs(Vs/1e-3))+0.1*max(abs(Vs/1e-3))) (max(abs(Vs/1e-3))+0.1*max(abs(Vs/1e-3)))]);
grid on;
set(gca,'FontSize',26)


%% PINK NOISE GENERATOR 
% courtesy of https://au.mathworks.com/matlabcentral/answers/429107-how-can-i-generate-a-pinknoise-with-a-certain-duration

function y = pinkusnoise(m, n)
% function: y = pinknoise(m, n)
% m - number of matrix rows
% n - number of matrix columns
% y - matrix with pink (flicker) noise samples 
%     with mu = 0 and sigma = 1 (columnwise)
% The function generates a matrix of pink (flicker) noise samples
% (columnwise). In terms of power at a constant bandwidth, pink  
% noise falls off at 3 dB/oct, i.e. 10 dB/dec.
% difine the length of the noise vector and ensure  
% that M is even, this will simplify the processing
m = round(m); n = round(n); N = m*n;
if rem(N, 2)
    M = N+1;
else
    M = N;
end
% generate white noise sequence
x = randn(1, M);
% FFT
X = fft(x);
% prepare a vector with frequency indexes 
NumUniquePts = M/2 + 1;     % number of the unique fft points
k = 1:NumUniquePts;         % vector with frequency indexes 
% manipulate the left half of the spectrum so the PSD
% is proportional to the frequency by a factor of 1/f, 
% i.e. the amplitudes are proportional to 1/sqrt(f)
X = X(1:NumUniquePts);      
X = X./sqrt(k);
% prepare the right half of the spectrum - a conjugate copy of the left
% one except the DC component and the Nyquist component - they are unique,
% and reconstruct the whole spectrum
X = [X conj(X(end-1:-1:2))];
% IFFT
y = real(ifft(X));
% ensure that the length of y is N
y = y(1, 1:N);
% form the noise matrix and ensure unity standard 
% deviation and zero mean value (columnwise)
y = reshape(y, [m, n]);
y = bsxfun(@minus, y, mean(y));
y = bsxfun(@rdivide, y, std(y));
end

