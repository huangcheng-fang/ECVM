% Developer: FANG Huangcheng @ Bjtu
% Last updated: 2024-08-01
% Email: valy_f@bjtu.edu.cn;huangcheng.fang@polyu.edu.hk
% Website: https://www.researchgate.net/profile/Huangcheng-Fang
% Please do not remove this Header Comment under any circumstances, such as using or modifying this code, or convert this code to another programming language

function Boundary=Creat_Geometric_Boundary(Boundary,ID,varargin)
%--------------------------------------------------------------------------
conformal_type='standard';
for i=1:1:numel(varargin)
    command=split(varargin{i},["="]);
    if numel(command)>2
        error(['Wrong input argument: ',varargin{i}]);
    end
    switch command{1}
        case 'type'
            type=command{2};
        case 'shape'
            shape=command{2};
        case 'parameter'
            parameter=eval(command{2});
        case 'origin'
            g_origin=eval(command{2});
            if size(g_origin,2)==2;g_origin=g_origin(1)+g_origin(2)*i;end
        case 'laurent_order'
            Laurent_order=eval(command{2});
        case 'conformal_order'
            Conformal_order=eval(command{2});
        otherwise
            error(['Wrong input argument: ',command{1}]);
    end
end
%--------------------------------------------------------------------------
if ID~=size(Boundary,1)+1
    error(['Available number is ',num2str(1+size(Boundary,1)),', not ' num2str(ID)])
end
%--------------------------------------------------------------------------
if strcmp(shape,'line');conformal_type='fraction';end
%--------------------------------------------------------------------------
[expression,origin]=Define_shape(shape,parameter);
[series,orders]=Conformal_transformation(type,conformal_type,Conformal_order,expression);
[fai_orders,pfai_orders,logterm,dofs]=Assign_Laurent_order(type,shape,Laurent_order);
boundary.type=type;
boundary.shape=shape;
boundary.origin=origin+g_origin;
boundary.expression=expression;
boundary.Conformal_type=conformal_type;
boundary.Conformal_series=series;
boundary.Conformal_orders=orders;
boundary.Laurent_order=Laurent_order;
boundary.fai_orders=fai_orders;
boundary.pfai_orders=pfai_orders;
boundary.logterm=logterm;
% boundary.logterm_value=nan;
boundary.dofs=dofs;
Boundary(ID,1)=Discrete_Boundary(boundary);
end






function [fai_orders,pfai_orders,logterm,dofs]=Assign_Laurent_order(type,shape,laurent_order)
logterm=0;
switch type
    case 'inner'
        fai_orders=-(1:1:laurent_order);
        pfai_orders=-(1:1:laurent_order+2);
        if ~strcmp(shape,'line')
           logterm=1; 
        end
    case 'outer'
        fai_orders=0:1:laurent_order+2;
        pfai_orders=1:1:laurent_order;
    otherwise
        error('Unknow type')
end
global maxdof
dofs=(1:1:2*(numel(fai_orders)+numel(pfai_orders)+logterm)).'+maxdof;
maxdof=dofs(end);
end

function [expression,origin]=Define_shape(shape,parameter)
switch shape
    case 'file'
        inputfile=parameter;
        model_file=fopen(inputfile);
        ni=1;flag=0;
        while ~feof(model_file)
            eachline=fgetl(model_file);
            temp_node=str2num(eachline);
            nodes(ni,1:size(temp_node,2))=temp_node;
            ni=ni+1;
        end
        fclose(model_file);
        x=nodes(:,2);y=nodes(:,3);
        z=x+y*1i;
        origin0=mean(z);
        z=z-origin0;
        [theta,r]=cart2pol(real(z),imag(z));
        theta=mod(theta,2*pi);
        [theta,loc]=unique(theta);
        r=r(loc);
        theta(end+1)=theta(1)+2*pi;r(end+1)=r(1);
        expression=spline(theta,r);
        theta=linspace(0,2*pi,10000);
        r=ppval(expression,theta);
        C=r.^3.*exp(theta*1i)*2/3;
        A=r.^2;
        origin=sum(C)/sum(A);
        
        control_points=z-origin;
        origin=origin+origin0;
        warning('未完善')
    case 'line'
        expression=mod(parameter(1)+pi/2,pi)-pi/2;
        origin=0;
        return
    case 'rectangle'
        a=parameter(1);b=parameter(2);
        x0=[linspace(-a,a,201)];
        y0=[linspace(-b,b,201)];   
        
        x=[y0*0+a,x0,y0*0-a,x0];
        y=[y0,x0*0+b,y0,x0*0-b];
        control_points=x+y*1i;
        origin=0;
    case 'ellipse'
        a=parameter(1);b=parameter(2);
        theta=linspace(0,2*pi,100);
        r=1./sqrt((cos(theta)/a).^2+(sin(theta)/b).^2);
        control_points=r.*exp(theta*1i);
        origin =0;

    case 'semicircle_semiellipse'
        a=parameter(1);b=parameter(2);
        theta1=linspace(0,pi-pi/100,100);
        theta2=linspace(pi,2*pi,100);
        r1=a+theta1*0;
        r2=1./sqrt((cos(theta2)/a).^2+(sin(theta2)/b).^2);
        theta=[theta1,theta2;];
        r=[r1,r2];z=r.*exp(theta*1i);
        expression=spline(theta,r);
        expression.type='close';
        theta=linspace(0,2*pi,10000);
        r=ppval(expression,theta);
        C=r.^3.*exp(theta*1i)*2/3;
        A=r.^2;
        origin=sum(C)/sum(A);
        
        control_points=z(:)-origin;
    otherwise
        disp('Unknown boundary shape')
end
expression=Spline_boundary(control_points);
end