% Developer: FANG Huangcheng @ Bjtu
% Last updated: 2024-08-01
% Email: valy_f@bjtu.edu.cn;huangcheng.fang@polyu.edu.hk
% Website: https://www.researchgate.net/profile/Huangcheng-Fang
% Please do not remove this Header Comment under any circumstances, such as using or modifying this code, or convert this code to another programming language

function Part=Get_Part_special_term(Part,Condition)
for PTi=1:1:size(Part,1)
    for bi=1:1:size(Part(PTi).boundary,1)
        if ~Part(PTi).boundary(bi).logterm
            continue
        end
        expression=Part(PTi).boundary(bi).expression;
        origin=Part(PTi).boundary(bi).origin;
        %-------------------------------------------------------------------
        [ip,wt]=grule(1000);theta=ip*pi+pi;wt=wt*pi;
        dr = fnval(fnder(expression, 1), theta);
        r=ppval(expression,theta);
        z=r.*exp(theta*1i)+origin;
        dx=dr.*cos(theta)-r.*sin(theta);
        dy=dr.*sin(theta)+r.*cos(theta);
        alpha=mod(cart2pol(dx,dy)+pi/2,2*pi);
        ds=sqrt(r.^2+dr.^2).*wt;
        %------------------------------------------------------------------
        [PSx,PSy,PSxy]=Get_stress(z,Part(PTi));
        FX=PSx.'*(cos(alpha).*ds)+PSxy.'*(sin(alpha).*ds);FY=PSy.'*(sin(alpha).*ds)+PSxy.'*(cos(alpha).*ds);
        Part(PTi).boundary(bi).logterm_value=-[FX;FY];
        %-------------------------------------------------------------------
    end
end
for ci=1:1:numel(Condition)
    if contains(Condition(ci).type,'stress')
        PTi=Condition(ci).partID1;
        bi=Condition(ci).partboundaryID1;
        if ~Part(PTi).boundary(bi).logterm
            continue
        end
        expression=Part(PTi).boundary(bi).expression;
        origin=Part(PTi).boundary(bi).origin;
        %-------------------------------------------------------------------
        [ip,wt]=grule(1000);theta=ip*pi+pi;wt=wt*pi;
        dr = fnval(fnder(expression, 1), theta);
        r=ppval(expression,theta);
        z=r.*exp(theta*1i)+origin;
        dx=dr.*cos(theta)-r.*sin(theta);
        dy=dr.*sin(theta)+r.*cos(theta);
        alpha=mod(cart2pol(dx,dy)+pi/2,2*pi);
        ds=sqrt(r.^2+dr.^2).*wt;
        %------------------------------------------------------------------
        x=real(z);y=imag(z);
        switch Condition(ci).type
            case 'normal_stress'
                Pr=eval(Condition(ci).expression{1})+0.*x;
                FX=Pr.'*(cos(alpha).*ds);
                FY=Pr.'*(sin(alpha).*ds);
            case 'tangential_stress'
                Prt=eval(Condition(ci).expression{1})+0.*x;
                FX=-Prt.'*(sin(alpha).*ds);
                FY=Prt.'*(cos(alpha).*ds);
            otherwise
                error('Unknow type')
        end
        Part(PTi).boundary(bi).logterm_value=Part(PTi).boundary(bi).logterm_value+[FX;FY];
    end
end
end