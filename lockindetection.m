%% Thesis A Simulations - Lock In Detection
clear;clc;close all;
%% Define input signal

% frequency at which the system will operate
fosc = 10e6;   % 10MHz

% time resolution & time - currently set for 1 second long signal @ 500MS/s
sigduration = 80;    % signal duration, in microseconds
Fsorig = 500e6;     % sampling freq is 500MS/s
dt = 1/Fsorig;     % Ts
Lorig = sigduration * 1e-6 * Fsorig;     % amount of time units as a multiple of sampling freq, 500MS/s
torig = (0:(Lorig-1))*dt; % time

% amplitude of main oscillations
A1 = 10e-6;

% Vin is input signal to system
Vin = A1*sin(2*pi*fosc*torig);


%% decimate signal

M = 4;    % decimation factor

L = Lorig/M;
Fs = Fsorig/M;

Vindec = decimate(Vin,M);

t = downsample(torig,M);


%%

% plot Vin
subplot(2,2,1);
plot(torig/1e-6,Vin/1e-6,'LineWidth',2);
xlabel("Time (\mus)",'FontSize',18);
ylabel("Voltage (\muV)",'FontSize',18);
title(strcat("Input signal V_{r} at f = ",num2str(fosc/1e6),"MHz", ", Fs = ",num2str(Fsorig/1e6),"MHz"),'FontSize',18);
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
plot(f/1e6,P1,'LineWidth',2);
xlabel("Frequency (MHz)",'FontSize',18);
ylabel("|P1(f)|",'FontSize',18);
title(strcat("FFT of V_{r} at f = ",num2str(fosc/1e6),"MHz", ", Fs = ",num2str(Fsorig/1e6),"MHz"),'FontSize',18);
xlim([0 12e1]);
ylim([-(0.1*max(abs(P1))+0.1*max(abs(P1))) (max(abs(P1))+0.1*max(abs(P1)))]);
xline(Fsorig/2e6,'Color','r','LineStyle','--', 'LineWidth',2);    % line at nyquist limit
legend("|P1(f)|","Nyquist limit",'FontSize',18);
grid on;
set(gca,'FontSize',26)

% plot Vindec
subplot(2,2,3);
plot(t/1e-6,Vindec/1e-6,'LineWidth',2);
xlabel("Time (\mus)",'FontSize',18);
ylabel("Voltage (\muV)",'FontSize',18);
title(strcat("Input signal V_{r,dec} at f = ",num2str(fosc/1e6),"MHz", ", Fs = ",num2str(Fs/1e6),"MHz", ", M = ",num2str(M)),'FontSize',18);
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
plot(f/1e6,P1,'LineWidth',2);
xlabel("Frequency (MHz)",'FontSize',18);
ylabel("|P1(f)|",'FontSize',18);
title(strcat("FFT of V_{r,dec} at f = ",num2str(fosc/1e6),"MHz", ", Fs = ",num2str(Fs/1e6),"MHz"),'FontSize',18);
xlim([0 12e1]);
ylim([-(0.1*max(abs(P1))+0.1*max(abs(P1))) (max(abs(P1))+0.1*max(abs(P1)))]);
xline(Fs/2e6,'Color','r','LineStyle','--', 'LineWidth',2);    % line at nyquist limit
legend("|P1(f)|","Nyquist limit",'FontSize',18);
grid on;
set(gca,'FontSize',26)





%% Simulate measurements (tunnelling events)

event_time = ceil(L/2);
event_duration = ceil(L/7);

Vevent = Vindec;
% assuming tunelling event will result in signal of 0.1 amplitude of original
Vevent(event_time:(event_time + event_duration)) = 5 * Vevent(event_time:(event_time + event_duration));

figure;
% plot Vevent
subplot(3,1,1);
plot(t/1e-6,Vevent/1e-3,'LineWidth',2);
xlabel("Time (\mus)",'FontSize',18);
ylabel("Voltage (mV)",'FontSize',18);
title(strcat("Signal after event V_{event} at f = ",num2str(fosc/1e6),"MHz"),'FontSize',18);
ylim([-(max(abs(Vevent/1e-3))+0.2*max(abs(Vevent/1e-3))) (max(abs(Vevent/1e-3))+0.2*max(abs(Vevent/1e-3)))]);
grid on;
set(gca,'FontSize',26)


%% Simulate noise + phase shift

% noise amplitude as a percentage of A1, noise is +-noiseA/2
noiseA = 3;

% add noise
noise = rand(1,ceil(L)) * noiseA * A1 - (noiseA * A1)/2;
Vnoise = Vevent + noise;

% phase shift
%Vnoise = [Vnoise(4950:end) Vnoise(1:4949)];

% plot Vnoise
subplot(3,1,2);
plot(t/1e-6,Vnoise/1e-3,'LineWidth',2);
xlabel("Time (\mus)",'FontSize',18);
ylabel("Voltage (mV)",'FontSize',18);
title(strcat("Signal with noise V_{noise} at f = ",num2str(fosc/1e6),"MHz"),'FontSize',18);
ylim([-(max(abs(Vevent/1e-3))+0.2*max(abs(Vevent/1e-3))) (max(abs(Vevent/1e-3))+0.2*max(abs(Vevent/1e-3)))]);
grid on;
set(gca,'FontSize',26)


%% Simulate amplification

% in order of 1mV to 10mV
Vamp = Vnoise * 1e2;

% plot Vamp
subplot(3,1,3);
plot(t/1e-6,Vamp/1e-3,'LineWidth',2);
xlabel("Time (\mus)",'FontSize',18);
ylabel("Voltage (mV)",'FontSize',18);
title(strcat("Amplified signal V_{s} at f = ",num2str(fosc/1e6),"MHz"),'FontSize',18);
ylim([-(max(abs(Vamp/1e-3))+0.1*max(abs(Vamp/1e-3))) (max(abs(Vamp/1e-3))+0.1*max(abs(Vamp/1e-3)))]);
grid on;
set(gca,'FontSize',26)


%% Mix signals

% reference signals, same oscillation freq as input
Vref1 = sin(2*pi*fosc*t);
Vref2 = cos(2*pi*fosc*t);

% signals after mixing with local oscillator
Vmixed1 = Vamp .* Vref1;
Vmixed2 = Vamp .* Vref2;

figure;
subplot(4,1,1);
plot(t/1e-6,Vmixed1/1e-3,'LineWidth',2);
xlabel("Time (\mus)",'FontSize',18);
ylabel("Voltage (mV)",'FontSize',18);
title(strcat("Mixed Signal X_{m} at f = ",num2str(fosc/1e6),"MHz"),'FontSize',18);
ylim([-(max(abs(Vmixed1/1e-3))+0.1*max(abs(Vmixed1/1e-3))) (max(abs(Vmixed1/1e-3))+0.1*max(abs(Vmixed1/1e-3)))]);
grid on;
set(gca,'FontSize',26)

subplot(4,1,2);
plot(t/1e-6,Vmixed2/1e-3,'LineWidth',2);
xlabel("Time (\mus)",'FontSize',18);
ylabel("Voltage (mV)",'FontSize',18);
title(strcat("Mixed Signal Y_{m} at f = ",num2str(fosc/1e6),"MHz"),'FontSize',18);
ylim([-(max(abs(Vmixed2/1e-3))+0.1*max(abs(Vmixed2/1e-3))) (max(abs(Vmixed2/1e-3))+0.1*max(abs(Vmixed2/1e-3)))]);
grid on;
set(gca,'FontSize',26)

% plot FFT of Vmixed1
Y = fft(Vmixed1);

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs * (0:(L/2))/L;

subplot(4,1,3);
plot(f/1e6,P1,'LineWidth',2);
xlabel("Frequency (MHz)",'FontSize',18);
ylabel("|P1(f)|",'FontSize',18);
title(strcat("FFT of X_{m} at f = ",num2str(fosc/1e6),"MHz"),'FontSize',18);
xlim([0 12e1]);
ylim([-(0.1*max(abs(P1))+0.1*max(abs(P1))) (max(abs(P1))+0.1*max(abs(P1)))]);
grid on;
set(gca,'FontSize',26)

% plot FFT of Vmixed2
Y = fft(Vmixed2);

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs * (0:(L/2))/L;

subplot(4,1,4);
plot(f/1e6,P1,'LineWidth',2);
xlabel("Frequency (MHz)",'FontSize',18);
ylabel("|P1(f)|",'FontSize',18);
title(strcat("FFT of Y_{m} at f = ",num2str(fosc/1e6),"MHz"),'FontSize',18);
xlim([0 12e1]);
ylim([-(0.1*max(abs(P1))+0.1*max(abs(P1))) (max(abs(P1))+0.1*max(abs(P1)))]);
grid on;
set(gca,'FontSize',26)

%% Filter signals

% design lowpass filter
%D = fdesign.lowpass('Fp,Fst,Ap,Ast',0.2,0.25,0.5,40);
%filt = design(D,'butter','Systemobject',true);

lpFilt = designfilt('lowpassfir','PassbandFrequency',0.001, ...
         'StopbandFrequency',0.01,'PassbandRipple',0.5, ...
         'StopbandAttenuation',65,'DesignMethod','kaiserwin');

Vfilt1 = filter(lpFilt,Vmixed1);
Vfilt2 = filter(lpFilt,Vmixed2);

figure;
subplot(4,1,1);
plot(t/1e-6,Vfilt1/1e-3,'LineWidth',2);
xlabel("Time (\mus)",'FontSize',18);
ylabel("Voltage (mV)",'FontSize',18);
title(strcat("Filtered Signal X at f = ",num2str(fosc/1e6),"MHz"),'FontSize',18);
ylim([-(max(abs(Vfilt1/1e-3))+0.1*max(abs(Vfilt1/1e-3))) (max(abs(Vfilt1/1e-3))+0.1*max(abs(Vfilt1/1e-3)))]);
grid on;
set(gca,'FontSize',26)

subplot(4,1,2);
plot(t/1e-6,Vfilt2/1e-3,'LineWidth',2);
xlabel("Time (\mus)",'FontSize',18);
ylabel("Voltage (mV)",'FontSize',18);
title(strcat("Filtered Signal Y at f = ",num2str(fosc/1e6),"MHz"),'FontSize',18);
ylim([-(max(abs(Vfilt2/1e-3))+0.1*max(abs(Vfilt2/1e-3))) (max(abs(Vfilt2/1e-3))+0.1*max(abs(Vfilt2/1e-3)))]);
grid on;
set(gca,'FontSize',26)

% plot FFT of Vmixed1
Y = fft(Vfilt1);

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs * (0:(L/2))/L;

subplot(4,1,3);
plot(f/1e6,P1,'LineWidth',2);
xlabel("Frequency (MHz)",'FontSize',18);
ylabel("|P1(f)|",'FontSize',18);
title(strcat("FFT of X at f = ",num2str(fosc/1e6),"MHz"),'FontSize',18);
xlim([0 12e1]);
ylim([-(0.1*max(abs(P1))+0.1*max(abs(P1))) (max(abs(P1))+0.1*max(abs(P1)))]);
grid on;
set(gca,'FontSize',26)

% plot FFT of Vmixed2
Y = fft(Vfilt2);

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fsorig * (0:(L/2))/L;

subplot(4,1,4);
plot(f/1e6,P1,'LineWidth',2);
xlabel("Frequency (MHz)",'FontSize',18);
ylabel("|P1(f)|",'FontSize',18);
title(strcat("FFT of Y at f = ",num2str(fosc/1e6),"MHz"),'FontSize',18);
xlim([0 12e1]);
ylim([-(0.1*max(abs(P1))+0.1*max(abs(P1))) (max(abs(P1))+0.1*max(abs(P1)))]);
grid on;
set(gca,'FontSize',26)


%% Recover signal

Vrecovered = 2*sqrt(Vfilt1.^2 + Vfilt2.^2);

figure;
subplot(2,1,1);
plot(t/1e-6,Vrecovered/1e-3,'LineWidth',2);
xlabel("Time (\mus)",'FontSize',18);
ylabel("Voltage (mV)",'FontSize',18);
title(strcat("Recovered Signal R at f = ",num2str(fosc/1e6),"MHz"),'FontSize',18);
ylim([-(max(abs(Vrecovered/1e-3))+0.1*max(abs(Vrecovered/1e-3))) (max(abs(Vrecovered/1e-3))+0.1*max(abs(Vrecovered/1e-3)))]);
grid on;
set(gca,'FontSize',26)


SNR = 20*log10(((sqrt(mean(Vevent.^2)))/(sqrt(mean(noise.^2))))^2)















