% Developer: FANG Huangcheng @ Bjtu
% Last updated: 2024-08-01
% Email: valy_f@bjtu.edu.cn;huangcheng.fang@polyu.edu.hk
% Website: https://www.researchgate.net/profile/Huangcheng-Fang
% Please do not remove this Header Comment under any circumstances, such as using or modifying this code, or convert this code to another programming language

function Plot_Model(Part,n,varargin)
%--------------------------------------------------------------------------
for i=1:1:numel(varargin)
    command=split(varargin{i},["="]);
    if numel(command)>2
        error(['Wrong input argument: ',varargin{i}]);
    end
    switch command{1}
        case 'xlim'
            xrange=eval(command{2});
        otherwise
            error(['Wrong input argument: ',command{1}]);
    end
end
figure(n);hold on
for PTi=1:1:size(Part,1)
    
    for bi=1:1:size(Part(PTi).boundary,1)
        z=Part(PTi).boundary(bi).discrete_points;
        if strcmp(Part(PTi).boundary(bi).shape,'line')
            plot(z)
            continue
        end
        if strcmp(Part(PTi).boundary(bi).type,'outer')
            fill(real(z),imag(z),[255 97 0]/255)
        else
            fill(real(z),imag(z),'w')
        end
    end
end
axis equal
xlim(xrange)
drawnow
end