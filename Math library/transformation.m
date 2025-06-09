% Developer: FANG Huangcheng @ Bjtu
% Last updated: 2024-08-01
% Email: valy_f@bjtu.edu.cn;huangcheng.fang@polyu.edu.hk
% Website: https://www.researchgate.net/profile/Huangcheng-Fang
% Please do not remove this Header Comment under any circumstances, such as using or modifying this code, or convert this code to another programming language

function z=transformation(x,series,orders)
x=x(:);
if ischar(series) 
    z=eval(series);
else
    Q=x.^(orders.');
    z=Q*series;
end
end