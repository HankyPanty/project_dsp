audionm = strcat('a (216).wav');
%audionm = 'DataSet/traini5ng_dataset_female/PDAm02_007_5.wav'
[x, fs] =audioread(audionm);

t=length(x)./fs;                                                                        %length of wav file
sprintf('The wavfile %f is  %3.2f  seconds long',train_var, t)                          %printing length of audio file


%THE ALGORITHM STARTS HERE
M=10;                                                                                   %prediction order
fsize = 30e-3;
N=round(fs*fsize);
[a,e,voiced,pitch_plot,pitch_vect,m_lpcc,formants] = func_collector(x, fs, fsize,M);    %taking input from function collector 

%VALUES CALCULATED IN EXPERIMENT
a;
e;
m_lpcc;
pitch_plot;
voiced;
formants;

%CALCULATION

freq_all= sum(pitch_vect)/length(pitch_vect);                                           %calculating pitch for all frames

if(length(pitch_plot)>length(voiced))                                                   %calculating pitch only using voiced frames
    freq_voiced=sum((pitch_plot(1:length(voiced)).^-1).*voiced)*fs/sum(voiced)
else
    freq_voiced=sum((pitch_plot.^-1).*voiced(1:length(pitch_plot)))*fs/sum(voiced(1:length(pitch_plot)));
end
ctr=1;
size(formants,1)
for abc=1: N : (size(formants,1)-3)*(N)
    voiced_frame(ctr)=round(sum(voiced(abc:abc+N-1))/N);
    formants_train_max(ctr)=max(formants(ctr,:));
    formants_train_min(ctr)=min(formants(ctr,:));
    voiced_formants_max(ctr)=formants_train_max(ctr)*voiced_frame(ctr);
    voiced_formants_min(ctr)=formants_train_min(ctr)*voiced_frame(ctr);
    ctr=ctr+1;
    ctr;
end

sum(voiced_formants_max)/sum(voiced_frame)
sum(voiced_formants_min)/sum(voiced_frame)

%RESULTS
beep;
disp('Press a key to play the original sound!');
pause;
soundsc(x, fs);
  
figure;
plot(x);
title(['Original signal = "', audionm, '"']) 
hold on
plot(voiced);
