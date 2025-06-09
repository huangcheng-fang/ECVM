% Developer: FANG Huangcheng @ Bjtu
% Last updated: 2024-08-01
% Email: valy_f@bjtu.edu.cn;huangcheng.fang@polyu.edu.hk
% Website: https://www.researchgate.net/profile/Huangcheng-Fang
% Please do not remove this Header Comment under any circumstances, such as using or modifying this code, or convert this code to another programming language

%%-------------------------------------------------------------------------
%Import FEM mesh information
function part=Import_Abaqus_Mesh(modelfile)
%--------------------------------------------------------------------------
data=importdata(modelfile,'',1e8);
maxL=0;
for ii=1:1:size(data,1)
    maxL=max(maxL,size(data{ii},2));
end
maxL=maxL+5;
%------------------------------location---------------------------------------
star=[];partloc=[];
for ii=1:1:size(data,1)
    if contains(data{ii},'*Part, name=')
        partloc(end+1,1)=ii;
    end
    if strcmp(data{ii},'*End Part')
        partloc(end,2)=ii;
    end
    if contains(data{ii},'*')
        star(end+1,1)=ii;
    end
    if size(data{ii},2)<maxL
        temp=data{ii};
        if ~strcmp(temp(end),',');temp(end+1)=',';end
        temp(size(temp,2)+1:maxL)='0';
        data{ii}=temp;
    end
end
%------------------------import part---------------------------------------
part.name=[];part.node=[];part.etype=[];part.element=[];
for ii=1:1:size(partloc,1)
    loc=star(star>=partloc(ii,1)&star<=partloc(ii,2));
    T=split(data{loc(1)},",");T=split(T{2},"name=");part(ii,1).name=T{end};
    if numel(loc)==2;continue;end
    node=str2num(cell2mat(data(loc(2)+1:loc(3)-1)));
    part(ii,1).node=node(:,2:end-1);
    for jj=3:1:numel(loc)-1
        T=split(data{loc(jj)},",");
        if strcmp(T{1},'*Element')
            T=split(T{2},"type=");
            element=str2num(cell2mat(data(loc(jj)+1:loc(jj+1)-1)));
            part(ii,1).element(end+1:end+size(element,1),1:size(element,2)-2)=element(:,2:end-1);
        end
    end
end
end