% Developer: FANG Huangcheng @ Bjtu
% Last updated: 2024-08-01
% Email: valy_f@bjtu.edu.cn;huangcheng.fang@polyu.edu.hk
% Website: https://www.researchgate.net/profile/Huangcheng-Fang
% Please do not remove this Header Comment under any circumstances, such as using or modifying this code, or convert this code to another programming language

function [Ux_M,Uy_M]=Get_displacement_matrix(z,Part)
E=Part.material(1);mu=Part.material(2);
G=E/(2*(1+mu));kv=3-4*mu;
Ux_M=[];Uy_M=[];
for bi=1:1:size(Part.boundary,1)
    type=Part.boundary(bi).type;
    fai_orders=Part.boundary(bi).fai_orders;
    pfai_orders=Part.boundary(bi).pfai_orders;
    logterm=Part.boundary(bi).logterm;
    series=Part.boundary(bi).Conformal_series;
    orders=Part.boundary(bi).Conformal_orders;
    origin=Part.boundary(bi).origin;
    zi=z-origin;
    x=Local_coordinate_transformation(zi,type,series,orders);
    [ux,uy]=Single_displacement_matrix(x,z,origin,fai_orders,pfai_orders,series,orders,kv,G,logterm);
    Ux_M=[Ux_M,ux];Uy_M=[Uy_M,uy];
end

end