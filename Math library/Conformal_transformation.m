% Developer: FANG Huangcheng @ Bjtu
% Last updated: 2024-08-01
% Email: valy_f@bjtu.edu.cn;huangcheng.fang@polyu.edu.hk
% Website: https://www.researchgate.net/profile/Huangcheng-Fang
% Please do not remove this Header Comment under any circumstances, such as using or modifying this code, or convert this code to another programming language

function [series,orders]=Conformal_transformation(type,conformal_type,order,expression)
%-------------------------------------------------------------------------------------------
if strcmp(conformal_type,'fraction')
    alpha=expression;
    roate=exp(-alpha(1)*1i)/order;
    series=['-1i*(1+x)./(1-x)/(',num2str(roate),')'];
    orders='fraction';
    disp(['The error of conformal transformation is: ',num2str(0),'(',num2str(0),')'])
    return
end
%-------------------------------------------------------------------------------------------
switch type
    case 'inner'
        [orders,series,erro]=inner_mapping(order,expression);
    case 'outer'
        [orders,series,erro]=outer_mapping(order,expression);
end
disp(['The error of conformal transformation is: ',num2str(erro),'(',num2str(order),')'])
if erro>1e-2
    error('The error of conformal mapping is too large. Please change the conformal_order')
end
end

function [orders,series,erro]=inner_mapping(order,expression)
FN=max(nextpow2(order)+1,6);num=2^FN;
d=pi/(num);theta=(0:2*num-1)'*d;alpha=theta;

r1=ppval(expression,theta);
Y1=r1.*exp(theta*1i);

flag=0;perro=100000;
k=[1:1:order]';
while 1
    keci1=exp(alpha*1i);
    y1=Y1./keci1;
    u1=real(y1);v1=imag(y1);
    [Cu1,Su1,~]=Fast_Fourier(u1);
    [Cv1,Sv1,~]=Fast_Fourier(v1);
    
    a0=Cu1(1)/2;b0=Cv1(1)/2;
    
    a(k,1)= (Cu1(k+1)-Sv1(k+1))/2;
    b(k,1)= (Su1(k+1)+Cv1(k+1))/2;
    
    Nu1=a0+(cos(alpha*k')*a+sin(alpha*k')*b);
    Nv1=b0+(-sin(alpha*k')*a+cos(alpha*k')*b);
    
    y10=Nu1+Nv1*1i;
    Y10=y10.*keci1;
    
    theta1=mod(imag(log(Y10)),2*pi);
    r1=ppval(expression,theta1);
    Y1=r1.*exp(theta1*1i);
    
    erro=norm(Y10-Y1)/norm(Y1);
    flag=flag+1;
    if erro<1e-4||flag>100||abs(perro-erro)<1e-6
        break
    end
    perro=erro;
    
%     plot(Y1,'.')
%     hold on
%     plot(Y10,'.')
%     axis equal
%     hold off
%     pause(0.1)
end
orders=[-order:0]'+1;
series=[a(end:-1:1);a0]+[b(end:-1:1);b0;]*1i;
end



function [orders,series,erro]=outer_mapping(order,expression)
FN=max(nextpow2(order)+1,6);num=2^FN;
d=pi/(num);theta=(0:2*num-1)'*d;alpha=theta;

r1=ppval(expression,theta);
y1=r1.*exp(theta*1i);

flag=0;perro=1;
k=[1:1:order]';
while 1
    u1=real(y1);v1=imag(y1);
    [Cu1,Su1,~]=Fast_Fourier(u1);
    [Cv1,Sv1,~]=Fast_Fourier(v1);
    
    a0=Cu1(1)/2;b0=Cv1(1)/2;
    
    a(k,1)= (Cu1(k+1)+Sv1(k+1))/2;
    b(k,1)= (-Su1(k+1)+Cv1(k+1))/2;
    
    Nu1=a0+(cos(alpha*k')*a-sin(alpha*k')*b);
    Nv1=b0+(sin(alpha*k')*a+cos(alpha*k')*b);
    
    y10=Nu1+Nv1*1i;
    theta1=mod(imag(log(y10)),2*pi);
    r1=ppval(expression,theta1);
    y1=r1.*exp(theta1*1i);
    
    
    erro=norm(y10-y1)/norm(y1);
    flag=flag+1;
    if erro<1e-4||flag>100||abs(perro-erro)<1e-6
        break
    end
    perro=erro;
    
%     plot(y1)
%     hold on
%     plot(y10,'.')
%     axis equal
%     hold off
%     pause(0.1)
end
orders=[0:order]';
series=[a0;a]+[b0;b]*1i;
end
