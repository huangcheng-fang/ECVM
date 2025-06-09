% Developer: FANG Huangcheng @ Bjtu
% Last updated: 2024-08-01
% Email: valy_f@bjtu.edu.cn;huangcheng.fang@polyu.edu.hk
% Website: https://www.researchgate.net/profile/Huangcheng-Fang
% Please do not remove this Header Comment under any circumstances, such as using or modifying this code, or convert this code to another programming language

function A=d_fai(x,n)
switch sign(n)
    case -1
        for k1=1:1:-n
            A(:,k1)=-k1*x.^(-k1-1);
        end
    case 1
        for k2=0:1:n+2
            A(:,k2+1)=k2*x.^(k2-1);
        end
end
end