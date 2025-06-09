% Developer: FANG Huangcheng @ Bjtu
% Last updated: 2024-08-01
% Email: valy_f@bjtu.edu.cn;huangcheng.fang@polyu.edu.hk
% Website: https://www.researchgate.net/profile/Huangcheng-Fang
% Please do not remove this Header Comment under any circumstances, such as using or modifying this code, or convert this code to another programming language

function dz=d_transformation(x,series,orders)
x=x(:);
if ischar(series)
    series=['-1i*((x + 1)./(x - 1).^2 - 1./(x - 1))',series(17:end)];
    dz=eval(series);
else
    for k=1:1:size(orders,1)
        Q(:,k)=orders(k)*x.^(orders(k)-1);
    end
    dz=Q*series;
end
end