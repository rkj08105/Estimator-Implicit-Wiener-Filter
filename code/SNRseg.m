% To calculate Segmental SNR (ok) 
% x- Clean signal fragmented
% y- Enhanced signal fragmented 
% fr- Frame length (in samples)
% len_overlap- length of frame overlapped (in samples)
% syntax: SNR_Segmental=SNRseg(Original Signal,Enhanced Signal,Frame length)

% See Segmental SNR formula at page 480 of Loizou book (eqn. 11.1 or 11.2)
% We have used eqn. 11.2 to avoid possiblity of getting large negative values 
% while calculating Segmental SNR during silent segments of speech.

function[SNRseg]=SNRseg(x,y,fr)
count=1;
len_overlap=100; % length of frame overlapped = len1 = 100 samples for 50% overlapping 

for i=1:len_overlap:length(y)-fr
    temp_orig=x(i:i+fr-1);
    temp_enh=y(i:i+fr-1);
    frag_SNR(count)=log(1+sum(temp_orig.*temp_orig)/sum((temp_orig-temp_enh).*(temp_orig-temp_enh)));
    count=count+1;
end
SNRseg=sum(frag_SNR)*10/count;
