% Developer: FANG Huangcheng @ Bjtu
% Last updated: 2024-08-01
% Email: valy_f@bjtu.edu.cn;huangcheng.fang@polyu.edu.hk
% Website: https://www.researchgate.net/profile/Huangcheng-Fang
% Please do not remove this Header Comment under any circumstances, such as using or modifying this code, or convert this code to another programming language

%%-------------------------------------------------------------------------
%Import FEM mesh information
function result=Import_Abaqus_Result(modelfile)
%--------------------------------------------------------------------------
data=importdata(modelfile,'',1e8);
start=[];end0=size(data,1);
for ii=1:1:size(data,1)
    if contains(data{ii},'----------------')
        start=ii;
    end
    if contains(data{ii},'Minimum')
        end0=ii-1;
    end
end
result=str2num(cell2mat(data(start+1:end0)));
end