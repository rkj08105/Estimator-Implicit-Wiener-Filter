
% Spectral Subtraction method. 

clc;
clear all;
close all;

[s1,Fs]=audioread('sp30.wav');  % Fs=8000 Hz  % Clean speech
s=s1/sqrt(sum(s1.^2));          % Normalised clean signal

[y1,Fs]=audioread('sp30_train_sn5.wav'); % Noisy speech

y=y1/sqrt(sum(y1.^2));          % Normalised noisy signal

% =============== Initialize variables ====================================

t=0.025; % frame duration=25 milli sec
L=t*Fs;  % window/frame length=200 samples 
Ns=length(y); % length of samples 
% Nframes=floor(Ns/L); % 107 frames initially

len=floor(L); % =200 samples i.e Single frame length 
if rem(len,2)==1
    len=len+1; 
end
perc_ovr=50;                  % window overlap in percent of frame size
len1=floor(len*perc_ovr/100); %=100 samples i.e. length of frame overlapped 
len2=len-len1;                %=100 samples i.e. length of non-overlapped frame

j1=sqrt(-1);
y_old=zeros(len1,1);             % Old size=100*1 
Nframes=floor(length(y)/len2)-1; % 233 % frames after 50% overlapping 
y_final=zeros(Nframes*len2,1);   % final new size
win=hamming(len,'periodic');     % Hamming window % window/Frame size=200*1 
nFFT=256;                        % FFT length=256
Dpsd=zeros(nFFT,1);              % Initialising Noise PSD

%--------------------Estimation of Noisy PSD-------------------------------
k=1;
for n=1:Nframes
   yframe=y(k:k+len-1);  % Framing 
   ywin=win.*yframe;     % Windowing  
   ystft=fft(ywin,nFFT); % STFT  
   ymag=abs(ystft);      % Magnitude of noisy signal
   ypsd=ymag.^2;         % PSD of noisy signal 
   
% ------------------Estimation of Noise PSD--------------------------------
% First order recursive equation to estimate noise PSD (eqn. 9.26 of book)

alpha=0.99; % smoothing parameter 

Dpsd=alpha.*Dpsd+(1-alpha).*ypsd; % PSD of noise signal
 
% ----------------- Constructing Enhanced/Denoised Signal -----------------

s_cap_psd=ypsd-Dpsd; % Enhanced speech PSD 

s_cap_psd(nFFT/2+2:nFFT)=flipud(s_cap_psd(2:nFFT/2));  % to ensure conjugate symmetry for real reconstruction
theta=angle(ystft); % Angle for each frame 
s_cap_phasor=(s_cap_psd.^(1/2)).*(cos(theta)+j1*(sin(theta))); % Enhanced Speech in Phasor form 
s_cap=real(ifft(s_cap_phasor)); % Enhanced speech in time domain without overlapping

% ----------------- Overlap and add --------------------------------------- 

y_final(k:k+len2-1)=y_old+s_cap(1:len1); % Final enhanced/denoised signal=y_final
y_old=s_cap(1+len1:len); 

k=k+len2;
end
%================ Writing Enhanced Speech =================================

% Enh_speech=input('Enter the Enhanced file name--->'); %'sp25_babble_sn5_enh.wav'
% audiowrite(Enh_speech,y_final,Fs);

%======================== Overall & Segmental SNR =========================

% SNR between enhanced and noise signal 
l=length(y_final);       % Length of enhanced speech
noise=y(1:l)-y_final;    
SNR_overall=snr(y_final,noise); % using MATLAB function for SNR

% Segmental SNR between clean & processed speech (=clean-enhanced)
% See Segmental SNR formula at page 480 of Loizou book (eqn. 11.1 or 11.2)
% We have used eqn. 11.2. For more explanation, see SNRseg.m file.
% Frame length=200 samples (for 25 milli-sec frame duration);

SNR_Segmental=SNRseg(s1,y_final,200); 

%=========================== Signal Plots =================================

figure(1);
l = length(y_final);      % length of enhanced signal i.e. y_final
t = linspace(0, l/Fs, l); % To plot signal w.r.t time
noise=y(1:l)-y_final;     % same as length of enhanced speech

subplot(3,2,1);
plot(t,s(1:l),'k');
title('Clean speech', 'FontSize', 13);
xlabel('Time (second)', 'FontSize', 13);
ylabel('Amplitude', 'FontSize', 13);

subplot(3,2,3);
plot(t,y(1:l),'k');
title('Noisy speech', 'FontSize', 13);
xlabel('Time (second)', 'FontSize', 13);
ylabel('Amplitude', 'FontSize', 13);

subplot(3,2,5);
plot(t,y_final,'k');
title('Enhanced speech using Spec. Sub.', 'FontSize', 13);
xlabel('Time (second)', 'FontSize', 13);
ylabel('Amplitude', 'FontSize', 13);

% %=========================== Spectrogram  =================================

M = round(0.025*Fs); %=200 % 25 ms window 
N = 2^nextpow2(M); %=256 % zero padding for interpolation
w = hamming(M);

subplot(3,2,2);
spectrogram(s1,w,160,N,Fs,'yaxis'); 
title('Clean speech spectrogram', 'FontSize', 13);
colorbar ('off');
xlabel('Time (second)', 'FontSize', 13);
ylabel('Frequency (kHz)', 'FontSize', 13);

subplot(3,2,4);
spectrogram(y,w,160,N,Fs,'yaxis');
title('Noisy speech spectrogram', 'FontSize', 13);
colorbar ('off');
xlabel('Time (second)', 'FontSize', 13);
ylabel('Frequency (kHz)', 'FontSize', 13);

subplot(3,2,6);
spectrogram(y_final,w,160,N,Fs,'yaxis');
title('Enhanced speech spectrogram using Spec. Sub.', 'FontSize', 13);
colorbar ('off');
xlabel('Time (second)', 'FontSize', 13);
ylabel('Frequency (kHz)', 'FontSize', 13);

%% Noisy vs Noise PSD plots

figure(2);
Fs=8000; % Sampling fequency
[PD1, F1]=periodogram(y,hamming(length(y)),256,Fs); % Noisy PSD
plot(F1,10*log10(PD1)); 
ylim([-180 -20]);
hold on;
[PD2, F2]=periodogram(noise,hamming(length(noise)),256,Fs); % Noise PSD
plot(F2,10*log10(PD2),'r'); 
legend('Noisy PSD','Noise PSD','Location','NorthEast');
set(legend,'fontsize',15);
ylim([-180 -20]);
xlabel('Frequency (Hz)', 'FontSize', 13); 
ylabel('Power/frequency (dB/Hz)', 'FontSize', 13);
title('Noisy vs Noise PSD using Spec. Sub. with recursive noise estimation','FontSize', 13);




