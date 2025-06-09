% Developer: FANG Huangcheng @ Bjtu
% Last updated: 2024-08-01
% Email: valy_f@bjtu.edu.cn;huangcheng.fang@polyu.edu.hk
% Website: https://www.researchgate.net/profile/Huangcheng-Fang
% Please do not remove this Header Comment under any circumstances, such as using or modifying this code, or convert this code to another programming language

function [sx,sy,sxy]=Single_stress_matrix(x,z,z0,fai_orders,pfai_orders,series,orders,kv,logterm)

w=transformation(x,series,orders);
dw=d_transformation(x,series,orders);
ddw=dd_transformation(x,series,orders);

dfai=x.^(fai_orders-1).*fai_orders;%d_fai(x,n);
ddfai=x.^(fai_orders-2).*fai_orders.*(fai_orders-1);%dd_fai(x,n);
dpfai=x.^(pfai_orders-1).*pfai_orders;%d_pfai(x,n);

dfaidz=dfai./dw;
ddfaidz=ddfai./(dw).^2-dfai.*ddw./(dw).^3;
dpfaidz=dpfai./dw;

sx1=[2*real(dfaidz)-real(conj(w).*ddfaidz),-real(dpfaidz)];
sy1=[2*real(dfaidz)+real(conj(w).*ddfaidz),+real(dpfaidz)];
sxy1=[imag(conj(w).*ddfaidz),imag(dpfaidz)];

sx2=-[2*imag(dfaidz)-imag(conj(w).*ddfaidz),-imag(dpfaidz)];
sy2=-[2*imag(dfaidz)+imag(conj(w).*ddfaidz),+imag(dpfaidz)];
sxy2=[real(conj(w).*ddfaidz),real(dpfaidz)];

sx=[sx1,sx2];
sy=[sy1,sy2];
sxy=[sxy1,sxy2];

if logterm
    dfai=-(z-z0).^-1;ddfai=(z-z0).^-2;
    dpfai=kv*(z-z0).^-1;z=z-z0;
    Ax=real(2*dfai-conj(z).*ddfai-dpfai)/(2*pi*(1+kv));
    Bx=real((2*dfai-conj(z).*ddfai+dpfai)*1i)/(2*pi*(1+kv));
    Ay=real(2*dfai+conj(z).*ddfai+dpfai)/(2*pi*(1+kv));
    By=real((2*dfai+conj(z).*ddfai-dpfai)*1i)/(2*pi*(1+kv));
    Axy=imag(conj(z).*ddfai+dpfai)/(2*pi*(1+kv));
    Bxy=imag((conj(z).*ddfai-dpfai)*1i)/(2*pi*(1+kv));
    sx=[sx,Ax,Bx];
    sy=[sy,Ay,By];
    sxy=[sxy,Axy,Bxy];
end
end