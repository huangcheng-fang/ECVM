% Developer: FANG Huangcheng @ Bjtu
% Last updated: 2024-08-01
% Email: valy_f@bjtu.edu.cn;huangcheng.fang@polyu.edu.hk
% Website: https://www.researchgate.net/profile/Huangcheng-Fang
% Please do not remove this Header Comment under any circumstances, such as using or modifying this code, or convert this code to another programming language

function Part=Get_Part_matrix(Part)
for PTi=1:1:size(Part,1)
    E=Part(PTi).material(1);mu=Part(PTi).material(2);kv=3-4*mu;G=E/(2*(1+mu));
    for bi=1:1:size(Part(PTi).boundary,1)
        z=Part(PTi).boundary(bi).discrete_points;
        alpha=Part(PTi).boundary(bi).discrete_angles;
        Sx=[];Sy=[];Sxy=[];Ux=[];Uy=[];
        for bj=1:1:size(Part(PTi).boundary,1)
            type=Part(PTi).boundary(bj).type;
            fai_orders=Part(PTi).boundary(bj).fai_orders;
            pfai_orders=Part(PTi).boundary(bj).pfai_orders;
            logterm=Part(PTi).boundary(bj).logterm;
            series=Part(PTi).boundary(bj).Conformal_series;
            orders=Part(PTi).boundary(bj).Conformal_orders;
            origin=Part(PTi).boundary(bj).origin;
            xj=Local_coordinate_transformation(z-origin,type,series,orders);
            
            [sx,sy,sxy]=Single_stress_matrix(xj,z,origin,fai_orders,pfai_orders,series,orders,kv,logterm);
            [ux,uy]=Single_displacement_matrix(xj,z,origin,fai_orders,pfai_orders,series,orders,kv,G,logterm);
            Sx=[Sx,sx];Sy=[Sy,sy];Sxy=[Sxy,sxy];
            Ux=[Ux,ux];Uy=[Uy,uy];
        end
        %-------------------------------------------------------------------
        Part(PTi).equation(bi).Sx=Sx;
        Part(PTi).equation(bi).Sy=Sy;
        Part(PTi).equation(bi).Sxy=Sxy;
        Part(PTi).equation(bi).Ux=Ux;
        Part(PTi).equation(bi).Uy=Uy;
        %-------------------------------------------------------------------        
        Part(PTi).equation(bi).Sr=0.5*(Sx+Sy)+0.5*(Sx-Sy).*cos(2*alpha)+Sxy.*sin(2*alpha);
        Part(PTi).equation(bi).St=0.5*(Sx+Sy)-0.5*(Sx-Sy).*cos(2*alpha)-Sxy.*sin(2*alpha);
        Part(PTi).equation(bi).Srt=0.5*(Sy-Sx).*sin(2*alpha)+Sxy.*cos(2*alpha);
        Part(PTi).equation(bi).Ur=Ux.*cos(alpha)+Uy.*sin(alpha);
        Part(PTi).equation(bi).Ut=-Ux.*sin(alpha)+Uy.*cos(alpha);
        %-------------------------------------------------------------------
    end
end

end