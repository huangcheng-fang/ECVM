% Developer: FANG Huangcheng @ Bjtu
% Last updated: 2024-08-01
% Email: valy_f@bjtu.edu.cn;huangcheng.fang@polyu.edu.hk
% Website: https://www.researchgate.net/profile/Huangcheng-Fang
% Please do not remove this Header Comment under any circumstances, such as using or modifying this code, or convert this code to another programming language

function [ux,uy]=Single_displacement_matrix(x,z,z0,fai_orders,pfai_orders,series,orders,kv,G,logterm)

w=transformation(x,series,orders);
dw=d_transformation(x,series,orders);

dfai=x.^(fai_orders-1).*fai_orders;%d_fai(x,n);

w=repmat(w,1,size(dfai,2));
dw=repmat(dw,1,size(dfai,2));

fai=x.^(fai_orders);%Fai(x,n);
pfai=x.^(pfai_orders);%Pfai(x,n);
dfaidz=dfai./dw;


ux1=[kv*real(fai)-real(w.*conj(dfaidz)),-real(conj(pfai))];
uy1=[kv*imag(fai)-imag(w.*conj(dfaidz)),-imag(conj(pfai))];

ux2=-[kv*imag(fai)+imag(w.*conj(dfaidz)),+imag(conj(pfai))];
uy2=[kv*real(fai)+real(w.*conj(dfaidz)),+real(conj(pfai))];

ux=[ux1,ux2]/(2*G);
uy=[uy1,uy2]/(2*G);

if logterm
    fai=-log(z-z0);dfai=-(z-z0).^-1;
    pfai=kv*log(z-z0);z=z-z0;
    Ax=real(kv*fai-z.*conj(dfai)-conj(pfai))/(2*pi*(1+kv))/(2*G);
    Bx=real(kv*fai*1i-z.*conj(dfai*1i)-conj(pfai*-1i))/(2*pi*(1+kv))/(2*G);
    Ay=imag(kv*fai-z.*conj(dfai)-conj(pfai))/(2*pi*(1+kv))/(2*G);
    By=imag(kv*fai*1i-z.*conj(dfai*1i)-conj(pfai*-1i))/(2*pi*(1+kv))/(2*G);
    ux=[ux,Ax,Bx];
    uy=[uy,Ay,By];
end
end