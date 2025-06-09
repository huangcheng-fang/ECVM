% Developer: FANG Huangcheng @ Bjtu
% Last updated: 2024-08-01
% Email: valy_f@bjtu.edu.cn;huangcheng.fang@polyu.edu.hk
% Website: https://www.researchgate.net/profile/Huangcheng-Fang
% Please do not remove this Header Comment under any circumstances, such as using or modifying this code, or convert this code to another programming language

function boundary=Discrete_Boundary(boundary)

expression=boundary.expression;
origin=boundary.origin;

n=abs(boundary.Laurent_order)+size(boundary.Conformal_orders,1)+5;
FN=nextpow2(n)+1;num=2^FN;

if strcmp(boundary.shape,'line')
    theta0=linspace(pi/128,2*pi-pi/128,num);
    x=exp(theta0*1i);
    z=transformation(x,boundary.Conformal_series,boundary.Conformal_orders)+origin;
    angle=repmat(mod(expression-pi/2,2*pi),size(z,1),1);
    theta=repmat(mod(expression,2*pi),size(z,1),1);
else
    d=2*pi/(num);theta0=(0:num-1)'*d;
    x=exp(theta0*1i);
    z=transformation(x,boundary.Conformal_series,boundary.Conformal_orders)+origin;
    theta=mod(imag(log(z-origin)),2*pi);
    dr = fnval(fnder(expression, 1), theta);
    r=ppval(expression,theta);
    dx=dr.*cos(theta)-r.*sin(theta);
    dy=dr.*sin(theta)+r.*cos(theta);
    angle=mod(cart2pol(dx,dy)-pi/2,2*pi);
    angle=mod(angle-pi,2*pi);
end
boundary.discrete_points=z;
boundary.discrete_thetas=theta;
boundary.discrete_angles=angle;
if strcmp(boundary.type,'outer')
    boundary.discrete_angles=mod(angle-pi,2*pi);
end
end