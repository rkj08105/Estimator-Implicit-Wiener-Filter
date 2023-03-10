
% Implicit Wiener filter method. 

clc
clear all;
close all;

[s,fs]=audioread('sp30.wav');   % fs=8000 Hz % clean speech

[y,fs]=audioread('sp30_train_sn5.wav'); % noisy speech 

% ====================== Initialize variables =============================

frame_dur=25; % 25 ms % frame duration
len=floor(frame_dur*fs/1000); % 200 % frame size in samples
if rem(len,2)==1 
    len=len+1; 
end
perc_ovr=50; % window overlap in percent of frame size
len1=floor(len*perc_ovr/100);  % 100
len2=len-len1; % 100

alpha=0.9; % smoothing parameter
Thres=3; % VAD threshold 
FLOOR=0.002;

win=hamming(len,'periodic');   % windowing
winGain=len2/sum(win); % normalization gain for overlap and add with 50 % overlap

%% Noise magnitude calculation considering first 5 frames of noisy speech 
% as noise/silence.

nFFT=256;  % FFT length=256
noise_mean=zeros(nFFT,1);
j=1;

for k=1:5
   noise_mean=noise_mean+abs(fft(win.*y(j:j+len-1),nFFT));
   j=j+len;
end
noise_mu=noise_mean/5; % noise magnitude (average)

% =============== Initialize variables ====================================
   
k=1;
img=sqrt(-1);
y_old=zeros(len1,1);
Nframes=floor(length(y)/len2)-1; % 233
yfinal=zeros(Nframes*len2,1);

%===============================  Start Processing ========================

for n=1:Nframes 
   
   y_win=win.*y(k:k+len-1);     % Windowing of input signal
   y_stft=fft(y_win,nFFT);      % STFT of a frame
   y_mag=abs(y_stft);           % magnitude of noisy signal
    
   SNRseg=10*log10(norm(y_mag,2)^2/norm(noise_mu,2)^2);
   
   gama_value=gama(SNRseg);
   
   sub_speech=y_mag.^2 - gama_value*noise_mu.^2; % subtracted speech % Enhanced speech PSD
   diffw = sub_speech-FLOOR*noise_mu.^2;   % difference speech 
   
   % Floor negative components of difference
   z=find(diffw <0);  
   if~isempty(z)
      sub_speech(z)=FLOOR*noise_mu(z).^2;
   end
   
   % Noise update using a simple VAD
  
   if (SNRseg < Thres)   
      noise_temp = alpha*noise_mu.^2+(1-alpha)*y_mag.^2;  % first order recusive equation  
      noise_mu=noise_temp.^(1/2);   % new estimated noise magnitude 
   end
   
% ----------------- Constructing Enhanced/Denoised Signal -----------------
      
   sub_speech(nFFT/2+2:nFFT)=flipud(sub_speech(2:nFFT/2));  % to ensure conjugate symmetry for real reconstruction
   theta=angle(y_stft); % Angle for each frame
   s_cap_phasor=(sub_speech.^(1/2)).*(cos(theta)+img*(sin(theta))); % Enhanced Speech in Phasor form 
   s_cap=real(ifft(s_cap_phasor)); % Enhanced speech in time domain without overlapping

% ----------------- Overlap and add ---------------------------------------    
    
   y_final(k:k+len2-1)=y_old+s_cap(1:len1); % Final enhanced/denoised signal=y_final
   y_old=s_cap(1+len1:len);
  
 k=k+len2;
end

%% Writing Enhanced Speech 

% Enh_speech=input('Enter the Enhanced file name--->'); %'sp25_airport_sn5_enh.wav'
% audiowrite(Enh_speech,winGain*y_final,fs);

%% Signal Plots 

figure(1);
l = length(y_final);      % length of enhanced signal i.e. y_final
t = linspace(0, l/fs, l); % To plot signal w.r.t time

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
title('Enhanced speech using IWF', 'FontSize', 13);
xlabel('Time (second)', 'FontSize', 13);
ylabel('Amplitude', 'FontSize', 13);

%=========================== Spectrogram  =================================

M = round(0.025*fs); %=200 % 25 ms window 
N = 2^nextpow2(M);   %=256 % zero padding for interpolation
w = hamming(M);

subplot(3,2,2);
spectrogram(s,w,160,N,fs,'yaxis'); 
title('Clean speech spectrogram', 'FontSize', 13);
colorbar ('off');
xlabel('Time (second)', 'FontSize', 13);
ylabel('Frequency (kHz)', 'FontSize', 13);

subplot(3,2,4);
spectrogram(y,w,160,N,fs,'yaxis');
title('Noisy speech spectrogram', 'FontSize', 13);
colorbar ('off');
xlabel('Time (second)', 'FontSize', 13);
ylabel('Frequency (kHz)', 'FontSize', 13);

subplot(3,2,6);
spectrogram(y_final,w,160,N,fs,'yaxis');
title('Enhanced speech spectrogram using IWF', 'FontSize', 13);
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
[PD2, F2]=periodogram(noise_mu,hamming(length(noise_mu)),256,Fs); % Noise PSD
plot(F2,10*log10(PD2),'r'); 
legend('Noisy PSD','Noise PSD','Location','NorthEast');
set(legend,'fontsize',15);
ylim([-180 -20]);
xlabel('Frequency (Hz)', 'FontSize', 13); 
ylabel('Power/frequency (dB/Hz)', 'FontSize', 13);
title('Noisy vs Noise PSD using IWF with recursive noise estimation', 'FontSize', 13);

%% Used function 

function a=gama(SNR)

if SNR>=-5.0 && SNR<=20
   a=4-SNR*3/20; 
else
   
  if SNR<-5.0
   a=5;
  end

  if SNR>20
    a=1;
  end
  
end
end
