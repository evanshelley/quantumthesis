%% Thesis A Simulations - Lock In Detection
clear;clc;close all;
%% Define input signal

% frequency at which the system will operate
fosc = 30e6;   % 30MHz

% time resolution & time
L = 5000;      % amount of time units
dt = 1e-10;     % Ts
Fs = 1/dt;      % Fs
t = (0:L-1)*dt; % time

% amplitude of main oscillations
A1 = 10e-6;

% Vin is input signal to system
Vin = A1*sin(2*pi*fosc*t);

% plot Vin
subplot(2,1,1);
plot(t/1e-6,Vin/1e-6,'LineWidth',2);
% xlabel("Time (\mus)",'FontSize',18);
% ylabel("Voltage (\muV)",'FontSize',18);
% title(strcat("Input signal V_{in} at f = ",num2str(fosc/1e6),"MHz"),'FontSize',18);
ylim([-(A1+0.1*A1)/1e-6 (A1+0.1*A1)/1e-6]);
grid on;

% plot FFT of Vin
Y = fft(Vin);

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs * (0:(L/2))/L;

subplot(2,1,2);
plot(f,P1,'LineWidth',2);
% xlabel("Frequency (Hz)",'FontSize',18);
% ylabel("|P1(f)|",'FontSize',18);
% title(strcat("FFT of V_{in} at f = ",num2str(fosc/1e6),"MHz"),'FontSize',18);
xlim([0 12e7]);
ylim([-(0.1*max(abs(P1))+0.1*max(abs(P1))) (max(abs(P1))+0.1*max(abs(P1)))]);
grid on;


%% Simulate measurements (tunnelling events)

event_time = ceil(L/2);
event_duration = ceil(L/7);

Vevent = Vin;
% assuming tunelling event will result in signal of 0.1 amplitude of original
Vevent(event_time:(event_time + event_duration)) = 0.1 * Vevent(event_time:(event_time + event_duration));

figure;
% plot Vevent
subplot(3,1,1);
plot(t/1e-6,Vevent/1e-6,'LineWidth',2);
% xlabel("Time (\mus)",'FontSize',18);
% ylabel("Voltage (\muV)",'FontSize',18);
% title(strcat("Signal after event V_{event} at f = ",num2str(fosc/1e6),"MHz"),'FontSize',18);
ylim([-(A1+0.1*A1)/1e-6 (A1+0.1*A1)/1e-6]);
grid on;


%% Simulate noise + phase shift

% noise amplitude as a percentage of A1
noiseA = 1.7;

% add noise
noise = rand(1,L) * noiseA * A1 - (noiseA * A1)/2;
Vnoise = Vevent + noise;

% phase shift
%Vnoise = [Vnoise(4950:end) Vnoise(1:4949)];

% plot Vnoise
subplot(3,1,2);
plot(t/1e-6,Vnoise/1e-6,'LineWidth',2);
% xlabel("Time (\mus)",'FontSize',18);
% ylabel("Voltage (\muV)",'FontSize',18);
% title(strcat("Signal with noise V_{noise} at f = ",num2str(fosc/1e6),"MHz"),'FontSize',18);
ylim([-(A1+0.1*A1)/1e-6 (A1+0.1*A1)/1e-6]);
grid on;


%% Simulate amplification

% in order of 1mV to 10mV
Vamp = Vnoise * 1e2;

% plot Vamp
subplot(3,1,3);
plot(t/1e-6,Vamp/1e-3,'LineWidth',2);
% xlabel("Time (\mus)",'FontSize',18);
% ylabel("Voltage (mV)",'FontSize',18);
% title(strcat("Amplified signal V_{amp} at f = ",num2str(fosc/1e6),"MHz"),'FontSize',18);
ylim([-(max(abs(Vamp))+0.1*max(abs(Vamp)))/1e-3 (max(abs(Vamp))+0.1*max(abs(Vamp)))/1e-3]);
grid on;


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
% xlabel("Time (\mus)",'FontSize',18);
% ylabel("Voltage (mV)",'FontSize',18);
% title(strcat("Mixed Signal V_{mixed1} at f = ",num2str(fosc/1e6),"MHz"),'FontSize',18);
ylim([-(max(abs(Vmixed1))+0.1*max(abs(Vmixed1)))/1e-3 (max(abs(Vmixed1))+0.1*max(abs(Vmixed1)))/1e-3]);
grid on;

subplot(4,1,2);
plot(t/1e-6,Vmixed2/1e-3,'LineWidth',2);
% xlabel("Time (\mus)",'FontSize',18);
% ylabel("Voltage (mV)",'FontSize',18);
% title(strcat("Mixed Signal V_{mixed2} at f = ",num2str(fosc/1e6),"MHz"),'FontSize',18);
ylim([-(max(abs(Vmixed2))+0.1*max(abs(Vmixed2)))/1e-3 (max(abs(Vmixed2))+0.1*max(abs(Vmixed2)))/1e-3]);
grid on;

% plot FFT of Vmixed1
Y = fft(Vmixed1);

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs * (0:(L/2))/L;

subplot(4,1,3);
plot(f,P1,'LineWidth',2);
% xlabel("Frequency (Hz)",'FontSize',18);
% ylabel("|P1(f)|",'FontSize',18);
% title(strcat("FFT of V_{mixed1} at f = ",num2str(fosc/1e6),"MHz"),'FontSize',18);
xlim([0 12e7]);
ylim([-(0.1*max(abs(P1))+0.1*max(abs(P1))) (max(abs(P1))+0.1*max(abs(P1)))]);
grid on;

% plot FFT of Vmixed2
Y = fft(Vmixed2);

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs * (0:(L/2))/L;

subplot(4,1,4);
plot(f,P1,'LineWidth',2);
% xlabel("Frequency (Hz)",'FontSize',18);
% ylabel("|P1(f)|",'FontSize',18);
% title(strcat("FFT of V_{mixed2} at f = ",num2str(fosc/1e6),"MHz"),'FontSize',18);
xlim([0 12e7]);
ylim([-(0.1*max(abs(P1))+0.1*max(abs(P1))) (max(abs(P1))+0.1*max(abs(P1)))]);
grid on;

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
% xlabel("Time (\mus)",'FontSize',18);
% ylabel("Voltage (mV)",'FontSize',18);
% title(strcat("Filtered Signal V_{filt1} at f = ",num2str(fosc/1e6),"MHz"),'FontSize',18);
ylim([-(max(abs(Vfilt1))+0.1*max(abs(Vfilt1)))/1e-3 (max(abs(Vfilt1))+0.1*max(abs(Vfilt1)))/1e-3]);
grid on;

subplot(4,1,2);
plot(t/1e-6,Vfilt2/1e-3,'LineWidth',2);
% xlabel("Time (\mus)",'FontSize',18);
% ylabel("Voltage (mV)",'FontSize',18);
% title(strcat("Filtered Signal V_{filt2} at f = ",num2str(fosc/1e6),"MHz"),'FontSize',18);
ylim([-(max(abs(Vfilt2))+0.1*max(abs(Vfilt2)))/1e-3 (max(abs(Vfilt2))+0.1*max(abs(Vfilt2)))/1e-3]);
grid on;

% plot FFT of Vmixed1
Y = fft(Vfilt1);

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs * (0:(L/2))/L;

subplot(4,1,3);
plot(f,P1,'LineWidth',2);
% xlabel("Frequency (Hz)",'FontSize',18);
% ylabel("|P1(f)|",'FontSize',18);
% title(strcat("FFT of V_{Vfilt1} at f = ",num2str(fosc/1e6),"MHz"),'FontSize',18);
xlim([0 12e7]);
ylim([-(0.1*max(abs(P1))+0.1*max(abs(P1))) (max(abs(P1))+0.1*max(abs(P1)))]);
grid on;

% plot FFT of Vmixed2
Y = fft(Vfilt2);

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs * (0:(L/2))/L;

subplot(4,1,4);
plot(f,P1,'LineWidth',2);
% xlabel("Frequency (Hz)",'FontSize',18);
% ylabel("|P1(f)|",'FontSize',18);
% title(strcat("FFT of V_{filt2} at f = ",num2str(fosc/1e6),"MHz"),'FontSize',18);
xlim([0 12e7]);
ylim([-(0.1*max(abs(P1))+0.1*max(abs(P1))) (max(abs(P1))+0.1*max(abs(P1)))]);
grid on;


%% Recover signal

Vrecovered = 2*sqrt(Vfilt1.^2 + Vfilt2.^2);

figure;
subplot(2,1,1);
plot(t/1e-6,Vrecovered/1e-3,'LineWidth',2);
% xlabel("Time (\mus)",'FontSize',18);
% ylabel("Voltage (mV)",'FontSize',18);
% title(strcat("Recovered Signal V_{recovered} at f = ",num2str(fosc/1e6),"MHz"),'FontSize',18);
ylim([-(max(abs(Vrecovered))+0.1*max(abs(Vrecovered)))/1e-3 (max(abs(Vrecovered))+0.1*max(abs(Vrecovered)))/1e-3]);
grid on;


SNR = 20*log10(((sqrt(mean(Vevent.^2)))/(sqrt(mean(noise.^2))))^2)















