% Developer: FANG Huangcheng @ Bjtu
% Last updated: 2024-08-01
% Email: valy_f@bjtu.edu.cn;huangcheng.fang@polyu.edu.hk
% Website: https://www.researchgate.net/profile/Huangcheng-Fang
% Please do not remove this Header Comment under any circumstances, such as using or modifying this code, or convert this code to another programming language

function expression=Spline_boundary(z)
[theta,r]=cart2pol(real(z),imag(z));
theta=mod(theta,2*pi);
[theta,loc]=unique(theta);
r=r(loc);
if theta(end)<pi*2
theta(end+1)=theta(1)+2*pi;r(end+1)=r(1);
end
expression=spline(theta,r);
end