Start_ECVM;
[Boundary,Part,Condition]=Creat_Analytical_Model();
%====================创建地表边界与第一个隧道开挖边界=======================
Boundary=Creat_Geometric_Boundary(Boundary, 1,'type=outer', 'shape=line', 'parameter=[0]', 'origin=-0-0i', 'laurent_order=256', 'conformal_order=30');
Boundary=Creat_Geometric_Boundary(Boundary, 2,'type=inner', 'shape=ellipse', 'parameter=[4,3]', 'origin=-8-20i', 'laurent_order=256', 'conformal_order=30');
%========================创建含一个隧道的地层===============================
Part=Creat_Computational_Domain(Part,Boundary, 1, 'material=[50e6,0.25]', 'primary_stress={"10e3*y","20e3*y"}','boundaryID=[1,2]');
%============================定义边界条件==================================
[Condition,Part]=Define_Boundary_Condition(Condition, Part, 1, 'type=normal_stress', 'expression={"0"}', 'partID=1', 'partboundaryID=1');%地表零应力条件
[Condition,Part]=Define_Boundary_Condition(Condition, Part, 2, 'type=tangential_stress', 'expression={"0"}', 'partID=1', 'partboundaryID=1');%地表零应力条件
[Condition,Part]=Define_Boundary_Condition(Condition, Part, 3, 'type=normal_stress', 'expression={"(0.5*30e3*y-0.5*10e3*y.*cos(2*alpha))*0.3"}', 'partID=1', 'partboundaryID=2');%隧道开挖边界应力释放系数0.7
[Condition,Part]=Define_Boundary_Condition(Condition, Part, 4, 'type=tangential_stress', 'expression={"(0.5*10e3*y.*sin(2*alpha))*0.3"}', 'partID=1', 'partboundaryID=2');%隧道开挖边界应力释放系数0.7
[Condition,Part]=Define_Boundary_Condition(Condition, Part, 5, 'type=fix_pointX' ,'expression={''0.*x''}', 'point=[-30;30]','partID=1');%固定刚体位移
[Condition,Part]=Define_Boundary_Condition(Condition, Part, 6, 'type=fix_pointY' ,'expression={''0.*x''}', 'point=[-30;30]','partID=1');%固定刚体位移
%==============================提交计算====================================
Part=Submit_To_Solver(Part,Condition);
%==============================绘制地表沉降====================================
Plot_Model(Part,1,'xlim=[-30,30]')
z=Part(1).boundary(1).discrete_points;
alpha=Part(1).boundary(1).discrete_angles;
[Ur,Ut]=Get_displacement_polar(z,alpha,Part(1));
figure(2)
plot(real(z),Ur)
xlim([-30,30])





%====================创建第一个隧道衬砌的内外边界=======================
Boundary=Creat_Geometric_Boundary(Boundary, 3,'type=outer', 'shape=ellipse', 'parameter=[4,3]', 'origin=-8-20i', 'laurent_order=256', 'conformal_order=30');
Boundary=Creat_Geometric_Boundary(Boundary, 4,'type=inner', 'shape=ellipse', 'parameter=[4,3]-0.5', 'origin=-8-20i', 'laurent_order=256', 'conformal_order=30');
%========================创建第一个隧道衬砌===============================
Part=Creat_Computational_Domain(Part,Boundary, 2, 'material=[30e9,0.25]', 'primary_stress={"0","0"}','boundaryID=[3,4]');
%============================定义边界条件==================================
Condition([3,4],:)=[];%删除开挖边界的应力条件
[Condition,Part]=Define_Contact_Condition(Condition, Part, 5, 'type=bonded_contact', 'partID1=1', 'partboundaryID1=2', 'partID2=2', 'partboundaryID2=1');%接触条件
[Condition,Part]=Define_Boundary_Condition(Condition, Part, 6, 'type=normal_stress', 'expression={"0"}', 'partID=2', 'partboundaryID=2');%衬砌内边界零应力条件
[Condition,Part]=Define_Boundary_Condition(Condition, Part, 7, 'type=tangential_stress', 'expression={"0"}', 'partID=2', 'partboundaryID=2');%衬砌内边界零应力条件
%==============================提交计算====================================
Part=Submit_To_Solver(Part,Condition);
%==============================绘制地表沉降====================================
Plot_Model(Part,1,'xlim=[-30,30]')
z=Part(1).boundary(1).discrete_points;
alpha=Part(1).boundary(1).discrete_angles;
[Ur,Ut]=Get_displacement_polar(z,alpha,Part(1));
figure(2);hold on
plot(real(z),Ur)
xlim([-30,30])


%====================创建第二个隧道开挖边界=======================
Boundary=Creat_Geometric_Boundary(Boundary, 5,'type=inner', 'shape=ellipse', 'parameter=[4,3]', 'origin=8-20i', 'laurent_order=256', 'conformal_order=30');
%====================在地层中开挖第二个隧道============================
Part=Add_Boundary_To_Domain(Part,Boundary,1,'boundaryID=[5]');
%============================定义边界条件==================================
[Condition,Part]=Define_Boundary_Condition(Condition, Part, 8, 'type=normal_stress', 'expression={"(0.5*30e3*y-0.5*10e3*y.*cos(2*alpha))*0.3"}', 'partID=1', 'partboundaryID=3');%隧道开挖边界应力释放系数0.7
[Condition,Part]=Define_Boundary_Condition(Condition, Part, 9, 'type=tangential_stress', 'expression={"(0.5*10e3*y.*sin(2*alpha))*0.3"}', 'partID=1', 'partboundaryID=3');%隧道开挖边界应力释放系数0.7
%==============================提交计算====================================
Part=Submit_To_Solver(Part,Condition);
%==============================绘制地表沉降====================================
Plot_Model(Part,1,'xlim=[-30,30]')
z=Part(1).boundary(1).discrete_points;
alpha=Part(1).boundary(1).discrete_angles;
[Ur,Ut]=Get_displacement_polar(z,alpha,Part(1));
figure(2);hold on
plot(real(z),Ur)
xlim([-30,30])