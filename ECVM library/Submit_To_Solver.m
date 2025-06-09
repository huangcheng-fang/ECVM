% Developer: FANG Huangcheng @ Bjtu
% Last updated: 2024-08-01
% Email: valy_f@bjtu.edu.cn;huangcheng.fang@polyu.edu.hk
% Website: https://www.researchgate.net/profile/Huangcheng-Fang
% Please do not remove this Header Comment under any circumstances, such as using or modifying this code, or convert this code to another programming language

function Part=Submit_To_Solver(Part,Condition)
Part=Get_Part_matrix(Part);
Part=Get_Part_vector(Part);
% Part=Get_Part_special_term(Part,Condition);
[K,F]=Assemble_Equation(Part,Condition);
Part=Solve_Equation(Part,K,F);
disp('Calculation completed.....')
disp('====================================================================')
end