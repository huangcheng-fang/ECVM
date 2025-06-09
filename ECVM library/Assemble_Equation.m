% Developer: FANG Huangcheng @ Bjtu
% Last updated: 2024-08-01
% Email: valy_f@bjtu.edu.cn;huangcheng.fang@polyu.edu.hk
% Website: https://www.researchgate.net/profile/Huangcheng-Fang
% Please do not remove this Header Comment under any circumstances, such as using or modifying this code, or convert this code to another programming language

function [K,F]=Assemble_Equation(Part,Condition)
K=[];F=[];
%---------------------Conventional boundary conditions---------------------
for Ci=1:1:size(Condition,1)
    PTi=Condition(Ci,1).partID1;bi=Condition(Ci,1).partboundaryID1;
    PTj=Condition(Ci,1).partID2;bj=Condition(Ci,1).partboundaryID2;
    E=Part(PTi).material(1);mu=Part(PTi).material(2);G=E/(2*(1+mu));
    pdof=[Part(PTi).dofs;Part(PTj).dofs;];
    SrI=[];SrtI=[];UrI=[];UtI=[];PSrI=[];PSrtI=[];
    SrJ=[];SrtJ=[];UrJ=[];UtJ=[];PSrJ=[];PSrtJ=[];
    if ~isempty(bi)
        SrI=Part(PTi).equation(bi).Sr;       
        SrtI=Part(PTi).equation(bi).Srt;     
        UrI=Part(PTi).equation(bi).Ur*2*G;   
        UtI=Part(PTi).equation(bi).Ut*2*G;  
        PSrI=Part(PTi).equation(bi).PSr;     
        PSrtI=Part(PTi).equation(bi).PSrt; 
    end
    if ~isempty(bj)
        SrJ=Part(PTj).equation(bj).Sr;
        SrtJ=Part(PTj).equation(bj).Srt;
        UrJ=Part(PTj).equation(bj).Ur*2*G;
        UtJ=Part(PTj).equation(bj).Ut*2*G;
        PSrJ=Part(PTj).equation(bj).PSr;
        PSrtJ=Part(PTj).equation(bj).PSrt;
    end
    K1=zeros(size(SrI,1),size(pdof,1));K2=zeros(size(SrJ,1),size(pdof,1));K3=zeros(size(SrJ,1),size(pdof,1));K4=zeros(size(SrJ,1),size(pdof,1));
    F1=zeros(size(SrI,1),1);F2=zeros(size(SrJ,1),1);F3=zeros(size(SrJ,1),1);F4=zeros(size(SrJ,1),1);
    for Cj=1:1:size(Condition,2)
        BC_type=Condition(Ci,Cj).type;
        expression=Condition(Ci,Cj).expression;
        loc=Condition(Ci,Cj).pointID(:);
        %-------------------------------------------------------------------
        switch BC_type
            case 'fix_pointX'
                z=Condition(Ci,Cj).fix_point(:);
                x=real(z);y=imag(z);
                [Ux_M,~]=Get_displacement_matrix(z,Part(PTi));
                K1=Ux_M*2*G;
                F1=eval(expression{1})*2*G+0.*x;
            case 'fix_pointY'
                z=Condition(Ci,Cj).fix_point(:);
                x=real(z);y=imag(z);
                [~,Uy_M]=Get_displacement_matrix(z,Part(PTi));
                K1=Uy_M*2*G;
                F1=eval(expression{1})*2*G+0.*x;
        end
        %-------------------------------------------------------------------
        switch BC_type
            case 'normal_stress'
                z=Part(PTi).boundary(bi).discrete_points(loc);
                discrete_theta=Part(PTi).boundary(bi).discrete_thetas(loc);
                alpha=Part(PTi).boundary(bi).discrete_angles(loc);
                x=real(z);y=imag(z);
                K1(loc,:)=SrI(loc,:);
                F1(loc,:)=eval(expression{1})+0.*x-PSrI(loc,:);
            case 'tangential_stress'
                z=Part(PTi).boundary(bi).discrete_points(loc);
                discrete_theta=Part(PTi).boundary(bi).discrete_thetas(loc);
                alpha=Part(PTi).boundary(bi).discrete_angles(loc);
                x=real(z);y=imag(z);
                K1(loc,:)=SrtI(loc,:);
                F1(loc,:)=eval(expression{1})+0.*x-PSrtI(loc,:);
            case 'normal_displacement'
                z=Part(PTi).boundary(bi).discrete_points(loc);
                discrete_theta=Part(PTi).boundary(bi).discrete_thetas(loc);
                x=real(z);y=imag(z);
                K1(loc,:)=UrI(loc,:);
                F1(loc,:)=eval(expression{1})*2*G+0.*x;
            case 'tangential_displacement'
                z=Part(PTi).boundary(bi).discrete_points(loc);
                discrete_theta=Part(PTi).boundary(bi).discrete_thetas(loc);
                x=real(z);y=imag(z);
                K1(loc,:)=UtI(loc,:);
                F1(loc,:)=eval(expression{1})*2*G+0.*x;
        end
        %-------------------------------------------------------------------
        switch BC_type
            case 'bonded_contact'
                z=Part(PTi).boundary(bi).discrete_points(loc);
                discrete_theta=Part(PTi).boundary(bi).discrete_thetas(loc);
                x=real(z);y=imag(z);
                K1(loc,:)=[SrI(loc,:), -SrJ(loc,:)];
                K2(loc,:)=[SrtI(loc,:),-SrtJ(loc,:)];
                K3(loc,:)=[UrI(loc,:), +UrJ(loc,:)];
                K4(loc,:)=[UtI(loc,:), +UtJ(loc,:)];
                
                F1(loc,1)=-PSrI(loc,:)+PSrJ(loc,:);
                F2(loc,1)=-PSrtI(loc,:)+PSrtJ(loc,:);
                F3(loc,1)=zeros(size(loc));
                F4(loc,1)=zeros(size(loc));
            case 'frictionless_contact'
                z=Part(PTi).boundary(bi).discrete_points(loc);
                discrete_theta=Part(PTi).boundary(bi).discrete_thetas(loc);
                x=real(z);y=imag(z);
                K1(loc,:)=[SrI(loc,:), -SrJ(loc,:)];
                K2(loc,:)=[SrtI(loc,:),-SrtJ(loc,:)];
                K3(loc,:)=[UrI(loc,:), +UrJ(loc,:)];
                K4(loc,:)=[SrtI(loc,:),+SrtJ(loc,:)*0;];
                
                F1(loc,:)=-PSrI(loc,:)+PSrJ(loc,:);
                F2(loc,:)=-PSrtI(loc,:)+PSrtJ(loc,:);
                F3(loc,1)=zeros(size(loc));
                F4(loc,:)=-PSrtI;
            case 'frictional_contact'
                contact_status=Part(PTi).boundary(bi).contact_status;
                contact_friction=Part(PTi).boundary(bi).contact_friction;
                gap=Part(PTi).boundary(bi).gap*2*G;
                
                z=Part(PTi).boundary(bi).discrete_point(loc);
                for II=1:1:size(z,1)
                    ii=loc(II);
                    if contact_status(ii,1)==0
                        K1(ii,:)=[SrI(ii,:),-SrJ(ii,:)];
                        K2(ii,:)=[SrtI(ii,:),-SrtJ(ii,:)];
                        K3(ii,:)=[SrI(ii,:),-SrJ(ii,:)*0];
                        K4(ii,:)=[SrtI(ii,:),-SrtJ(ii,:)*0];
                        
                        F1(ii,:)=-PSrI(ii,:)+PSrJ(ii,:);
                        F2(ii,:)=-PSrtI(ii,:)+PSrtJ(ii,:);
                        F3(ii,:)=-PSrI(ii,:);
                        F4(ii,:)=-PSrtI(ii,:);
                    end
                    if contact_status(ii,1)~=0&&contact_status(ii,2)==0
                        K1(ii,:)=[SrI(ii,:),-SrJ(ii,:)];
                        K2(ii,:)=[SrtI(ii,:),-SrtJ(ii,:)];
                        K3(ii,:)=[UrI(ii,:),UrJ(ii,:)];
                        K4(ii,:)=[SrtI(ii,:),-SrtJ(ii,:)*0];
                        
                        F1(ii,:)=-PSrI(ii,:)+PSrJ(ii,:);
                        F2(ii,:)=-PSrtI(ii,:)+PSrtJ(ii,:);
                        F3(ii,:)=gap(ii);
                        F4(ii,:)=[-PSrtI(ii,:)+contact_friction(ii)];
                    end
                    if contact_status(ii,1)~=0&&contact_status(ii,2)~=0
                        K1(ii,:)=[SrI(ii,:),-SrJ(ii,:)];
                        K2(ii,:)=[SrtI(ii,:),-SrtJ(ii,:)];
                        K3(ii,:)=[UrI(ii,:),UrJ(ii,:)];
                        K4(ii,:)=[UtI(ii,:),UtJ(ii,:)];
                        
                        F1(ii,:)=-PSrI(ii,:)+PSrJ(ii,:);
                        F2(ii,:)=-PSrtI(ii,:)+PSrtJ(ii,:);
                        F3(ii,:)=gap(ii);
                        F4(ii,:)=0;
                    end
                end 
        end
    end
    KI=[K1;K2;K3;K4];
    FI=[F1;F2;F3;F4];
    K(end+1:end+size(KI,1),pdof)=KI;
    F(end+1:end+size(KI,1),1)=FI;
end

end