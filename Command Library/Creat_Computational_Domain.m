% Developer: FANG Huangcheng @ Bjtu
% Last updated: 2024-08-01
% Email: valy_f@bjtu.edu.cn;huangcheng.fang@polyu.edu.hk
% Website: https://www.researchgate.net/profile/Huangcheng-Fang
% Please do not remove this Header Comment under any circumstances, such as using or modifying this code, or convert this code to another programming language

function Part=Creat_Computational_Domain(Part,Boundary,PTi,varargin)
%--------------------------------------------------------------------------
for i=1:1:numel(varargin)
    command=split(varargin{i},["="]);
    if numel(command)>2
        error(['Wrong input argument: ',varargin{i}]);
    end
    switch command{1}
        case 'material'
            material=eval(command{2});
        case 'primary_stress'
            primary_stress=eval(command{2});
        case 'boundaryID'
            boundaryID=eval(command{2});
        otherwise
            error(['Wrong input argument: ',command{1}]);
    end
end
%--------------------------------------------------------------------------
if PTi~=size(Part,1)+1
    error(['Available number is ',num2str(1+size(Part,2)),', not ' num2str(PTi)])
end
%--------------------------------------------------------------------------
part.material=material(:).';
part.primary_stress=primary_stress(:).';
part.boundary=Boundary(boundaryID(:));
%--------------------------------------------------------------------------
part.dofs=[];
for bi=1:1:size(part.boundary,1)
    part.dofs=[part.dofs;part.boundary(bi).dofs];
end
part.coeff=zeros(size(part.dofs));
part.equation=[];
%--------------------------------------------------------------------------
Part(PTi,1)=part;
end