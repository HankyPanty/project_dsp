function [aCoeff, eCoeff, voiced,pitch_plot, pitch_ka_vector, lpccs,formants] = func_collector(x, fs, fsize,M)

frame_length = round(fs .* fsize);                          %frame_length=number of samples in each framesize of "x"
N= frame_length - 1;                                        %N+1 = frame length = number of data points in each framesize
ctr=1;
formants=[1 1 1 1 1];
lpccs=   [1 1 1 1 1 1 1 1 1 1];

%LPC AND RESEDUAL,FRAME SEGMENTATION,PITCH VECTOR,LPCC AND FORMANTS CALCULATION AHEAD
for b=1 : frame_length : (length(x) - frame_length)
    y1=x(b:b+N);                                            %"b+N" denotes the end point of current frame;(b:b+N)=N+1 elements
                                                            %"y1" denotes an array of the data points of the current frame
                                                        
    y = filter([1 -.9378], 1, y1);                          %pre-emphasis filtering

    [a, e] = func_lpc_res (y, M,frame_length);              %e=error signal from lpc resedual
    aCoeff(ctr: (ctr + length(a) - 1)) = a;                 %aCoeff is array of "a" for whole "x"
    eCoeff(b: (b + length(e) - 1)) = e;                     %eCoeff is array of "e" for whole "x"
    
    formants =[formants;func_formants(a,fs)];               %Formants stored in the matrix formants
    %formants=0;
    lpccs =[lpccs;func_lpcc_sanjay(a,M)];                   %lpccs stored in the matrix formants
    
    msf(b:(b + N)) = func_vd_msf (y);                   
    zc(b:(b + N)) = func_vd_zc (y);
    [pitch_plot(b:(b + N)),freq] = func_pitch (e,fs);
    pitch_ka_vector(ctr)=freq;
    ctr=ctr+1;
end

%THRESHOLD CALCULATIONS
thresh_msf = (( (sum(msf)./length(msf)) - min(msf)) .* (0.5) ) + min(msf);
voiced_msf =  msf > thresh_msf;      %=1,0

thresh_zc = (( ( sum(zc)./length(zc) ) - min(zc) ) .*  (2) ) + min(zc);
voiced_zc = zc < thresh_zc;

thresh_pitch = (( (sum(pitch_plot)./length(pitch_plot)) - min(pitch_plot)) .* (0.5) ) + min(pitch_plot);
voiced_pitch =  pitch_plot > thresh_pitch;

%VOICED FRAMES CALCULATION AHEAD
for b=1:(length(x) - frame_length)
    if voiced_msf(b) .* voiced_pitch(b) .* voiced_zc(b) == 1
        voiced(b) = 1;
    else                                                    %condition for a voised frame is
        voiced(b) = 0;
    end
end

total_windows=ctr-1;

%LPCC AND GAIN FUNCTION
%for b=1 : frame_length : (length(x) - frame_length)
%    
%    lpcc_for_one = func_lpcc_sanjay(a,M);
%    lpcc(b:(b + M)) = lpcc_for_one;
%    
%end
%func_formants(a,fs)
%trial=func_trial_lpcc(a)
%trial2=func_lpcc(e, voiced(b), pitch_plot(b), a, M)
%trial3=func_lpcc_sanjay(a,M)