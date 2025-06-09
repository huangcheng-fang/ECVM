% Developer: FANG Huangcheng @ Bjtu
% Last updated: 2024-08-01
% Email: valy_f@bjtu.edu.cn;huangcheng.fang@polyu.edu.hk
% Website: https://www.researchgate.net/profile/Huangcheng-Fang
% Please do not remove this Header Comment under any circumstances, such as using or modifying this code, or convert this code to another programming language

function x=Local_coordinate_transformation(z0,type,series,orders)
if ischar(series)
    z=eval(series(18:end))*1i*z0;
    x=(z-1)./(z+1);
    return
end

switch type
    case 'inner'
        lim=Inf;
   case 'outer'
        lim=0;
end
    
num=size(z0,1);d=2*pi/num;
theta=[0:num-1]'*d;theta(1)=d*1e-3;
x=exp(theta*1i);
z=transformation(x,series,orders);
perro=1;flag=0;
while 1
    k=d_transformation(x,series,orders);
    dx=(z0-z)./k;
    x=dx+x;
    loc=find((abs(x)-1).*(abs(x)-lim)>0);
    x(loc)=x(loc)./abs(x(loc));
    z=transformation(x,series,orders);
    erro=max(norm(z0-z)./norm(z0));
    if erro<1e-6||abs(perro-erro)<1e-7||flag>1e2
        break
    end
    perro=erro;flag=flag+1;
%     plot(x),axis equal
%     plot(z,'.'),axis equal
%     hold on
%     plot(z0),axis equal
%     hold off
%     pause(0.1)
end
if erro>0.02||flag>=1e2
    error('The error of inverse conformal mapping exceeds the threshold, please consider changing the order of conformal mapping')
end
end