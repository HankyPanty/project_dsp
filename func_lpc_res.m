function [A ,lpr] = func_lpc_res(x,P,N)


x=x.*window(@hamming,N);
r=[];
for i=0:P
    r=[r; sum(x(1:N-i).*x(1+i:N))];
end

R=toeplitz(r(1:P));
a=inv(R)*r(2:P+1);

for i=1 : P
if isnan(a(i))
    a(i)=0.1;
end
i=i+1;
end

A=[1; -a];

B = A';

est = filter([0 -B(2:end)], 1, x);
lpr = x - est;
lpr=lpr';