% Developer: FANG Huangcheng @ Bjtu
% Last updated: 2024-08-01
% Email: valy_f@bjtu.edu.cn;huangcheng.fang@polyu.edu.hk
% Website: https://www.researchgate.net/profile/Huangcheng-Fang
% Please do not remove this Header Comment under any circumstances, such as using or modifying this code, or convert this code to another programming language

function [Sr,St,Srt]=Get_stress_polar(z,alpha,Part)
[Sx,Sy,Sxy]=Get_stress(z,Part);
ssize=size(Sx,2);
alpha=repmat(alpha,1,ssize);
Sr=0.5*(Sx+Sy)+0.5*(Sx-Sy).*cos(2*alpha)+Sxy.*sin(2*alpha);
St=0.5*(Sx+Sy)-0.5*(Sx-Sy).*cos(2*alpha)-Sxy.*sin(2*alpha);
Srt=0.5*(Sy-Sx).*sin(2*alpha)+Sxy.*cos(2*alpha);
end