% Developer: FANG Huangcheng @ Bjtu
% Last updated: 2024-08-01
% Email: valy_f@bjtu.edu.cn;huangcheng.fang@polyu.edu.hk
% Website: https://www.researchgate.net/profile/Huangcheng-Fang
% Please do not remove this Header Comment under any circumstances, such as using or modifying this code, or convert this code to another programming language

function ddz=dd_transformation(x,series,orders)
if ischar(series)
    series=['-1i*(2./(x - 1).^2 - (2*(x + 1))./(x - 1).^3)',series(17:end)];
    ddz=eval(series);
else
    for k=1:1:size(orders,1);
        Q(:,k)=(orders(k)-1)*orders(k)*(x).^(orders(k)-2);
    end
    ddz=Q*series;
end
end