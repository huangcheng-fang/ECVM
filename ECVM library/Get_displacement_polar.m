% Developer: FANG Huangcheng @ Bjtu
% Last updated: 2024-08-01
% Email: valy_f@bjtu.edu.cn;huangcheng.fang@polyu.edu.hk
% Website: https://www.researchgate.net/profile/Huangcheng-Fang
% Please do not remove this Header Comment under any circumstances, such as using or modifying this code, or convert this code to another programming language

function [Ur,Ut]=Get_displacement_polar(z,alpha,Part)
[Ux,Uy]=Get_displacement(z,Part);
Ur=Ux.*cos(alpha)+Uy.*sin(alpha);
Ut=-Ux.*sin(alpha)+Uy.*cos(alpha);
end