% Developer: FANG Huangcheng @ Bjtu
% Last updated: 2024-08-01
% Email: valy_f@bjtu.edu.cn;huangcheng.fang@polyu.edu.hk
% Website: https://www.researchgate.net/profile/Huangcheng-Fang
% Please do not remove this Header Comment under any circumstances, such as using or modifying this code, or convert this code to another programming language

function [Sx,Sy,Sxy]=Get_stress(z,Part)
mu=Part.material(2);kv=3-4*mu;
[PSx,PSy,PSxy]=Primary_stress_filed(z,Part.primary_stress);
Sx_M=[];Sy_M=[];Sxy_M=[];
for bi=1:1:size(Part.boundary,1)
    fai_orders=Part.boundary(bi).fai_orders;
    pfai_orders=Part.boundary(bi).pfai_orders;
    logterm=Part.boundary(bi).logterm;
    type=Part.boundary(bi).type;
    series=Part.boundary(bi).Conformal_series;
    orders=Part.boundary(bi).Conformal_orders;
    origin=Part.boundary(bi).origin;
    x=Local_coordinate_transformation(z-origin,type,series,orders);
    [sx_M,sy_M,sxy_M]=Single_stress_matrix(x,z,origin,fai_orders,pfai_orders,series,orders,kv,logterm);
    Sx_M=[Sx_M,sx_M];Sy_M=[Sy_M,sy_M];Sxy_M=[Sxy_M,sxy_M];
end
Sx=Sx_M*Part.coeff+PSx;
Sy=Sy_M*Part.coeff+PSy;
Sxy=Sxy_M*Part.coeff+PSxy;
end