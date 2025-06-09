% Developer: FANG Huangcheng @ Bjtu
% Last updated: 2024-08-01
% Email: valy_f@bjtu.edu.cn;huangcheng.fang@polyu.edu.hk
% Website: https://www.researchgate.net/profile/Huangcheng-Fang
% Please do not remove this Header Comment under any circumstances, such as using or modifying this code, or convert this code to another programming language

function [SPx,SPy,SPxy]=Special_stress_term(z,Part)
mu=Part.material(2);kv=3-4*mu;
for bi=1:1:size(Part.boundary,1)
    %-------------------------------------------------------------------
    SPx=0;SPy=0;SPxy=0;
    for bj=1:1:size(Part.boundary,1)
        if strcmp(Part.boundary(bj).shape,'line');continue;end
        A=-Part.boundary(bj).logterm/2/pi/(1+kv);
        z0=Part.boundary(bj).origin;
        SPx=SPx+real(2*A./(z-z0)-(-conj(z)*A./(z-z0).^2+conj(-A)*kv./(z-z0)));
        SPy=SPy+real(2*A./(z-z0)+(-conj(z)*A./(z-z0).^2+conj(-A)*kv./(z-z0)));
        SPxy=SPxy+imag((-conj(z)*A./(z-z0).^2+conj(-A)*kv./(z-z0)));
    end
    %-------------------------------------------------------------------
end
end