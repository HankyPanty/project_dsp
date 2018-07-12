xxx=csvread('training.csv');

for train_var=757:6: size(xxx,1)
% MAIN BODY
% clear;
% clc;

%TAKING INPUT WAVFILE

file=int2str(xxx(train_var,1));
 
audionm = strcat('a (',file,').wav');
%audionm = 'DataSet/traini5ng_dataset_female/PDAm02_007_5.wav'
[x, fs] =audioread(audionm);

t=length(x)./fs;                                                                        %length of wav file
sprintf('The wavfile %f is  %3.2f  seconds long',train_var, t)                                       %printing length of audio file


%THE ALGORITHM STARTS HERE
M=10;                                                                                   %prediction order
fsize = 30e-3;
N=round(fs .* fsize);
[a,e,voiced,pitch_plot,pitch_vect,m_lpcc,formants] = func_collector(x, fs, fsize,M);    %taking input from function collector 

%VALUES CALCULATED IN EXPERIMENT
a;                                                                                 %
e;
m_lpcc;
pitch_plot;
voiced;
formants;

%CALCULATION

freq_all= sum(pitch_vect)/length(pitch_vect);                                           %calculating pitch for all frames

if(length(pitch_plot)>length(voiced))                                                   %calculating pitch only using voiced frames
    freq_voiced=sum((pitch_plot(1:length(voiced)).^-1).*voiced)*fs/sum(voiced);
else
    freq_voiced=sum((pitch_plot.^-1).*voiced(1:length(pitch_plot)))*fs/sum(voiced(1:length(pitch_plot)));
end

ctr=1;
for abc=1: N : (size(formants,1)-3)*(N)
    voiced_frame(ctr)=round(sum(voiced(abc:abc+N-1))/N);
    formants_train_max(ctr)=max(formants(ctr,:));
    formants_train_min(ctr)=min(formants(ctr,:));
    voiced_formants_max(ctr)=formants_train_max(ctr)*voiced_frame(ctr);
    voiced_formants_min(ctr)=formants_train_min(ctr)*voiced_frame(ctr);
    ctr=ctr+1;
end

f_train_max(train_var)=sum(voiced_formants_max)/sum(voiced_frame);
f_train_min(train_var)=sum(voiced_formants_min)/sum(voiced_frame);
pitch_train(train_var)=freq_voiced;


% god_var=pitch_train(train_var)*0.3418-f_train_max(train_var)*0.0088+0.0133*f_train_min;
% if god_var<-20.79
%     accu_vect(train_var)=1;
% else
%     accu_vect(train_var)=0;
% end

% RESULTS
% beep;
% disp('Press a key to play the original sound!');
% pause;
% soundsc(x, fs);

% figure;
% plot(x);
% title(['Original signal = "', audionm, '"']) 
% hold on
% plot(voiced);

end

beta=[-0.4003,0.0119,-0.0166];

bias=17.32;

asdf = [pitch_train',f_train_max',f_train_min'];
data = asdf*beta'+bias;
accu_vect = zeros(200,1);
j= 0;
for i=1:size(xxx,1)
if (data(i)>0)
    
    accu_vect(i)=1;
else
    accu_vect(i)=0;
end
if (xxx(i,2)==accu_vect(i))
    j=j+1;
end
end
accuracy=j*100/size(xxx,1)


% model = fitcsvm([pitch_train',f_train_max',f_train_min'],xxx(:,2));
% labels = xxx(:,2);
% threedim(pitch_train,f_train_max,f_train_min,labels)
% 

asdfg = [pitch_train',f_train_max',f_train_min'];
threedim(pitch_train,f_train_max,f_train_min, xxx(:,2));

figure
threedim2(pitch_train,f_train_max,f_train_min,accu_vect)

% xxx=xxx[pitch_train;xxx]
% xxx[3][train_var] = freq_voiced

