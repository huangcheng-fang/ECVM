% Developer: FANG Huangcheng @ Bjtu
% Last updated: 2024-08-01
% Email: valy_f@bjtu.edu.cn;huangcheng.fang@polyu.edu.hk
% Website: https://www.researchgate.net/profile/Huangcheng-Fang
% Please do not remove this Header Comment under any circumstances, such as using or modifying this code, or convert this code to another programming language

function Plot_Deformed_Model(Part,n,varargin)
%--------------------------------------------------------------------------
scale=1;
for i=1:1:numel(varargin)
    command=split(varargin{i},["="]);
    if numel(command)>2
        error(['Wrong input argument: ',varargin{i}]);
    end
    switch command{1}
        case 'xlim'
            xrange=eval(command{2});
        case 'scale'
            scale=eval(command{2});
        otherwise
            error(['Wrong input argument: ',command{1}]);
    end
end
%--------------------------------------------------------------------------
figure(n);hold on
colorr='rgbcmyk';
hold on
for PTi=1:1:size(Part,1)
    theta=[linspace(pi/1001,2*pi,1001)]';
    for bi=1:1:size(Part(PTi).boundary,1)
        series=Part(PTi).boundary(bi).Conformal_series;
        orders=Part(PTi).boundary(bi).Conformal_orders;
        origin=Part(PTi).boundary(bi).origin;
        x=exp(theta*1i);
        z=transformation(x,series,orders);
        S0=max(abs(z));
        z=z+origin;
        [Ux,Uy]=Get_displacement(z,Part(PTi));
        S1=max(abs(Ux+Uy*1i));
        plot(z+(Ux+Uy*1i)*scale,colorr(mod(PTi,7)+1))
    end
end
axis equal
xlim(xrange)
end