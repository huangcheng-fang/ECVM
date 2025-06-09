% Developer: FANG Huangcheng @ Bjtu
% Last updated: 2024-08-01
% Email: valy_f@bjtu.edu.cn;huangcheng.fang@polyu.edu.hk
% Website: https://www.researchgate.net/profile/Huangcheng-Fang
% Please do not remove this Header Comment under any circumstances, such as using or modifying this code, or convert this code to another programming language

function [Condition,Part]=Define_Contact_Condition(Condition,Part,ID,varargin)
%--------------------------------------------------------------------------
range=[-inf,inf];fix_point=[];expression=[];
for i=1:1:numel(varargin)
    command=split(varargin{i},["="]);
    if numel(command)>2
        error(['Wrong input argument: ',varargin{i}]);
    end
    switch command{1}
        case 'type'
            type=command{2};
        case 'parameter'
            expression=eval(command{2});
        case 'partID1'
            partID1=eval(command{2});
        case 'partboundaryID1'
            partboundaryID1=eval(command{2});
        case 'partID2'
            partID2=eval(command{2});
        case 'partboundaryID2'
            partboundaryID2=eval(command{2});
        otherwise
            error(['Wrong input argument: ',command{1}]);
    end
end
%--------------------------------------------------------------------------
if ID~=size(Condition,1)+1
    error(['Available number is ',num2str(1+size(Condition,1)),', not ' num2str(ID)])
end
if ~ismember(type,{'bonded_contact','frictionless_contact','frictional_contact'})
    error(['Unkonwn contact condition type: ',type]);
end
%--------------------------------------------------------------------------
condition.type=type;condition.expression=num2cell(expression);
condition.partID1=partID1;condition.partboundaryID1=partboundaryID1;
condition.partID2=partID2;condition.partboundaryID2=partboundaryID2;
condition.range=range;condition.fix_point=fix_point;condition.pointID=[];
if ismember(type,{'bonded_contact','frictionless_contact'})
    condition.expression={'0.*x','0.*x',0};
end
%--------------------------------------------------------------------------
if strcmp(Part(partID1).boundary(partboundaryID1).type,'inner')&&strcmp(Part(partID2).boundary(partboundaryID2).type,'outer')
    part1=partID1;boundary1=partboundaryID1;
    part2=partID2;boundary2=partboundaryID2;
end
if strcmp(Part(partID1).boundary(partboundaryID1).type,'outer')&&strcmp(Part(partID2).boundary(partboundaryID2).type,'inner')
    part1=partID2;boundary1=partboundaryID2;
    part2=partID1;boundary2=partboundaryID1;
end
contact_points=Part(part1).boundary(boundary1).discrete_points;
contact_points(2:2:end)=Part(part2).boundary(boundary2).discrete_points(2:2:end);
%--------------------------------------------------------------------------
[contact_points,thetas,angles]=smooth_on_inner_boundary(Part(part1).boundary(boundary1),contact_points);
Part(part1).boundary(boundary1).discrete_points=contact_points;
Part(part1).boundary(boundary1).discrete_thetas=thetas;
Part(part1).boundary(boundary1).discrete_angles=angles;
Part(part2).boundary(boundary2).discrete_points=contact_points;%Correcting_point(Part(part2).boundary(boundary2),contact_points);
Part(part2).boundary(boundary2).discrete_thetas=thetas;
Part(part2).boundary(boundary2).discrete_angles=mod(angles+pi,2*pi);
%--------------------------------------------------------------------------
theta0=Part(part1).boundary(boundary1).discrete_thetas;
loc=find(theta0>range(1)&theta0<=range(2));
condition.pointID=loc;
%--------------------------------------------------------------------------
Condition(ID,1)=condition;
end


function [contact_points,thetas,angles]=smooth_on_inner_boundary(boundary,contact_points)
contact_points=Correcting_point(boundary,contact_points);
expression=boundary.expression;
origin=boundary.origin;
if strcmp(boundary.shape,'line')
    angles=repmat(mod(expression-pi/2,2*pi),size(contact_points,1),1);
    thetas=repmat(mod(expression,2*pi),size(contact_points,1),1);
    z=eval(boundary.Conformal_series(18:end))*1i*(contact_points-origin);
    x=(z-1)./(z+1);[~,loc]=sort(mod(imag(log(x)),2*pi));
    contact_points=contact_points(loc);
else
    thetas=mod(imag(log(contact_points-origin)),2*pi);
    [thetas,loc]=sort(thetas);contact_points=contact_points(loc);
    dr = fnval(fnder(expression, 1), thetas);
    r=ppval(expression,thetas);
    dx=dr.*cos(thetas)-r.*sin(thetas);
    dy=dr.*sin(thetas)+r.*cos(thetas);
    angles=mod(cart2pol(dx,dy)-pi/2,2*pi);
    angles=mod(angles-pi,2*pi);
end
end


function contact_points=Correcting_point(boundary,contact_points)
type=boundary.type;
series=boundary.Conformal_series;
orders=boundary.Conformal_orders;
origin=boundary.origin;

x=Local_coordinate_transformation(contact_points-origin,type,series,orders);
x=x./abs(x);
contact_points=transformation(x,series,orders)+origin;
end