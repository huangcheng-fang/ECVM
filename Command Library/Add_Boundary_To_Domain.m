% Developer: FANG Huangcheng @ Bjtu
% Last updated: 2024-08-01
% Email: valy_f@bjtu.edu.cn;huangcheng.fang@polyu.edu.hk
% Website: https://www.researchgate.net/profile/Huangcheng-Fang
% Please do not remove this Header Comment under any circumstances, such as using or modifying this code, or convert this code to another programming language

function Part=Add_Boundary_To_Domain(Part,Boundary,PTi,varargin)
%--------------------------------------------------------------------------
for i=1:1:numel(varargin)
    command=split(varargin{i},["="]);
    if numel(command)>2
        error(['Wrong input argument: ',varargin{i}]);
    end
    switch command{1}
        case 'boundaryID'
            boundaryID=eval(command{2});
        otherwise
            error(['Wrong input argument: ',command{1}]);
    end
end
%--------------------------------------------------------------------------
if PTi>size(Part,1)
    error(['Available max number is ',num2str(size(Part,2)),', not ' num2str(PTi)])
end
%--------------------------------------------------------------------------
aboundary=Boundary(boundaryID(:));
Part(PTi).boundary(end+1:end+numel(boundaryID),:)=aboundary;
%--------------------------------------------------------------------------
addof=[];
for bi=1:1:size(aboundary,1)
    addof=[addof;aboundary(bi).dofs];
end
Part(PTi).dofs=[Part(PTi).dofs;addof];
Part(PTi).coeff=[Part(PTi).coeff;zeros(size(addof))];
%--------------------------------------------------------------------------
end