% Developer: FANG Huangcheng @ Bjtu
% Last updated: 2024-08-01
% Email: valy_f@bjtu.edu.cn;huangcheng.fang@polyu.edu.hk
% Website: https://www.researchgate.net/profile/Huangcheng-Fang
% Please do not remove this Header Comment under any circumstances, such as using or modifying this code, or convert this code to another programming language

function points=equally_spaced_points(z,num)
z=z(:);
[theta,~]=cart2pol(real(z),imag(z));
theta=mod(theta,2*pi);
[~,loc]=unique(theta);
z=z(loc);
L=abs([0;z(2:end)-z(1:end-1);z(end)-z(1)]);
for ii=1:1:numel(L)-1
   L(ii+1)=L(ii+1)+L(ii); 
end
z(end+1)=z(1);
points=interp1(L/L(end),z,(0:num-1)/num,'linear');
points=points(:);
end