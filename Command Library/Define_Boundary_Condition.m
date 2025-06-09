% Developer: FANG Huangcheng @ Bjtu
% Last updated: 2024-08-01
% Email: valy_f@bjtu.edu.cn;huangcheng.fang@polyu.edu.hk
% Website: https://www.researchgate.net/profile/Huangcheng-Fang
% Please do not remove this Header Comment under any circumstances, such as using or modifying this code, or convert this code to another programming language

function [Condition,Part]=Define_Boundary_Condition(Condition,Part,ID,varargin)
%--------------------------------------------------------------------------
range=[-inf,inf];fix_point=[];partboundaryID=[];
for i=1:1:numel(varargin)
    command=split(varargin{i},["="]);
    if numel(command)>2
        error(['Wrong input argument: ',varargin{i}]);
    end
    switch command{1}
        case 'type'
            type=command{2};
        case 'expression'
            expression=eval(command{2});
        case 'point'
            fix_point=eval(command{2});
        case 'partID'
            partID=eval(command{2});
        case 'partboundaryID'
            partboundaryID=eval(command{2});
        otherwise
            error(['Wrong input argument: ',command{1}]);
    end
end
if ID~=size(Condition,1)+1
     error(['Available number is ',num2str(1+size(Condition,1)),', not ' num2str(ID)])
end
if ~ismember(type,{'normal_stress','tangential_stress','normal_displacement', 'tangential_displacement','fix_pointX','fix_pointY'})
    error(['Unkonwn boundary condition type: ',type]);
end
%--------------------------------------------------------------------------
condition.type=type;condition.expression=expression;
condition.partID1=partID;condition.partboundaryID1=partboundaryID;
condition.partID2=[];condition.partboundaryID2=[];
condition.range=range;condition.fix_point=fix_point;condition.pointID=[];
%--------------------------------------------------------------------------
if ~contains(condition.type,'fix')
    theta0= Part(partID).boundary(partboundaryID).discrete_thetas;
    loc=find(theta0>range(1)&theta0<=range(2));
    condition.pointID=loc;
end
%--------------------------------------------------------------------------
Condition(ID,1)=condition;
end