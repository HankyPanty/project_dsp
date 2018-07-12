function formants = func_formants(A,fs)

rts = roots(A);
rts = rts(imag(rts)>=0);
angz = atan2(imag(rts),real(rts));
[frqs,indices] = sort(angz.*(fs/(2*pi)));
bw = -1/2*(fs/(2*pi))*log(abs(rts(indices)));
nn = 1;

formants=zeros(1,5);
for kk = 1:length(frqs)
if (frqs(kk) > 90 && bw(kk) <400)
formants(nn) = frqs(kk);
nn = nn+1;
end
if(nn==6)
    break;
end
end
if(length(formants)==1)
    formants(2)=0;
end
if(length(formants)==2)
    formants(3)=0;
end
if(length(formants)==3)
    formants(4)=0;
end
if(length(formants)==4)
    formants(5)=0;
end
