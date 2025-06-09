% Developer: FANG Huangcheng @ Bjtu
% Last updated: 2024-08-01
% Email: valy_f@bjtu.edu.cn;huangcheng.fang@polyu.edu.hk
% Website: https://www.researchgate.net/profile/Huangcheng-Fang
% Please do not remove this Header Comment under any circumstances, such as using or modifying this code, or convert this code to another programming language

function Part=Get_Part_vector(Part)
for PTi=1:1:size(Part,1)
    for bi=1:1:size(Part(PTi).boundary,1)
        z=Part(PTi).boundary(bi).discrete_points;
        alpha=Part(PTi).boundary(bi).discrete_angles;
        %-------------------------------------------------------------------
        [PSx,PSy,PSxy]=Primary_stress_filed(z,Part(PTi).primary_stress);
        PSx=PSx+Part(PTi).equation(bi).Sx*Part(PTi).coeff;
        PSy=PSy+Part(PTi).equation(bi).Sy*Part(PTi).coeff;
        PSxy=PSxy+Part(PTi).equation(bi).Sxy*Part(PTi).coeff;
        PSr=(0.5*(PSx+PSy)+0.5*(PSx-PSy).*cos(2*alpha)+PSxy.*sin(2*alpha));
        PSrt=(0.5*(PSy-PSx).*sin(2*alpha)+PSxy.*cos(2*alpha));
        Part(PTi).equation(bi).PSr=PSr;Part(PTi).equation(bi).PSrt=PSrt;
        %-------------------------------------------------------------------
    end
end
end