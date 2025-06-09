% Developer: FANG Huangcheng @ Bjtu
% Last updated: 2024-08-01
% Email: valy_f@bjtu.edu.cn;huangcheng.fang@polyu.edu.hk
% Website: https://www.researchgate.net/profile/Huangcheng-Fang
% Please do not remove this Header Comment under any circumstances, such as using or modifying this code, or convert this code to another programming language

function [C,S,f]=Fast_Fourier(y)
y=y(:);
L=size(y,1);
Fs=L;
N = 2^nextpow2(L); 
Y = fft(y,N)/N*2;
f = Fs/N*(0:1:N/2-1)'; %频率
C=real(Y(1:L/2));
S=-imag(Y(1:L/2));
temp=max(abs([C;S]));
% C(abs(C)<temp*1e-10)=0;
% S(abs(S)<temp*1e-10)=0;
% C(1)=C(1)/2;
end