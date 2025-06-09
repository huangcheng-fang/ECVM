% Developer: FANG Huangcheng @ Bjtu
% Last updated: 2024-08-01
% Email: valy_f@bjtu.edu.cn;huangcheng.fang@polyu.edu.hk
% Website: https://www.researchgate.net/profile/Huangcheng-Fang
% Please do not remove this Header Comment under any circumstances, such as using or modifying this code, or convert this code to another programming language

function Part=Solve_Equation(Part,K,F)
% for PTi=1:1:size(Part,1)
%     for bi=1:1:numel(Part(PTi).boundary)
%         if Part(PTi).boundary(bi).logterm
%             fv=Part(PTi).boundary(bi).logterm_value;
%             F=F-K(:,Part(PTi).boundary(bi).dofs(end-1:end))*fv;
%             K(:,Part(PTi).boundary(bi).dofs(end-1:end))=0;
%             K(end+1:end+2,Part(PTi).boundary(bi).dofs(end-1:end))=[1,0;0,1];
%             F=[F;fv];
%         end
%     end
% end


[Q,R]=qr(K);
R(size(R,2)+1:end,:)=[];
Q(:,size(R,2)+1:end)=[];
dcoeff=R\(Q'*F);
for PTi=1:1:size(Part,1)
    %---------------
%     for bi=1:1:numel(Part(PTi).boundary)
%         if Part(PTi).boundary(bi).logterm
%             dcoeff(Part(PTi).boundary(bi).dofs(end-1:end))=Part(PTi).boundary(bi).logterm_value;
%         end
%     end
    pdof=Part(PTi).dofs;
    Part(PTi).coeff=Part(PTi).coeff+dcoeff(pdof);
end
end