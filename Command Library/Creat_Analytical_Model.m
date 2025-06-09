% Developer: FANG Huangcheng @ Bjtu
% Last updated: 2024-08-01
% Email: valy_f@bjtu.edu.cn;huangcheng.fang@polyu.edu.hk
% Website: https://www.researchgate.net/profile/Huangcheng-Fang
% Please do not remove this Header Comment under any circumstances, such as using or modifying this code, or convert this code to another programming language

function [Boundary,Part,Condition]=Creat_Analytical_Model()
Boundary.shape=[];
Boundary.type=[];
Boundary.origin=[];
Boundary.expression=[];
Boundary.Conformal_type=[];
Boundary.Conformal_series=[];
Boundary.Conformal_orders=[];
Boundary.discrete_points=[];
Boundary.discrete_thetas=[];
Boundary.discrete_angles=[];
Boundary.Laurent_order=[];
Boundary.fai_orders=[];
Boundary.pfai_orders=[];
Boundary.logterm=[];
% Boundary.logterm_value=[];
Boundary.dofs=[];
Part.material=[];
Part.primary_stress=[];
Part.boundary=[];
Part.dofs=[];
Part.coeff=[];
Part.equation=[];
Condition.type=[];Condition.expression=[];
Condition.partID1=[];Condition.partboundaryID1=[];
Condition.partID2=[];Condition.partboundaryID2=[];
Condition.range=[];Condition.fix_point=[];Condition.pointID=[];
Boundary(1,:)=[];
Condition(1,:)=[];
Part(1,:)=[];
global maxdof
maxdof=0;
end