% Developer: FANG Huangcheng @ Bjtu
% Last updated: 2024-08-01
% Email: valy_f@bjtu.edu.cn;huangcheng.fang@polyu.edu.hk
% Website: https://www.researchgate.net/profile/Huangcheng-Fang
% Please do not remove this Header Comment under any circumstances, such as using or modifying this code, or convert this code to another programming language

function [Sx,Sy,Sxy]=Primary_stress_filed(z,expression)
x=real(z);y=imag(z);clear z
Sx=eval(expression{1})+0.*x;
Sy=eval(expression{2})+0.*x;
Sxy=0.*x;
end