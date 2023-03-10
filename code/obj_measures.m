% Program to find objective measures of Speech enhancement algorithms

clc
clear all;
close all;

%% Log likelihood ratio between clean and enhanced speech samples
% Note1- LLR measure is limited in the range [0,2]
% Note2- Here length of clean and enhanced speech sample need not be same
% It takes the minimum of both length to calculate LLR.

LLR=comp_llr('sp30.wav','sp30_train_sn5_enh.wav');

%% Cepstrum distance between clean and enhanced speech samples
% Note1- Cepstrum measure is limited in the range [0,10]
% Note2- Here length of clean and enhanced speech sample need not be same
% It takes the minimum of both length to calculate cepstrum distance.

Cep_dist=comp_cep('sp30.wav','sp30_train_sn5_enh.wav');

%% Weighted Spectral Slope distance between clean and enhanced speech samples
% Note1- WSS measure is limited in the range [0,150]
% Note2- Here length of clean and enhanced speech sample need not be same
% It takes the minimum of both length to calculate WSS distance.

WSS_dist=comp_wss('sp30.wav','sp30_train_sn5_enh.wav');

%% PESQ MOS score between clean and enhanced speech samples
% Note1- PESQ MOS score is limited in the range [-0.5,4.5]

pesq_value=pesq('sp30.wav','sp30_train_sn5_enh.wav');



