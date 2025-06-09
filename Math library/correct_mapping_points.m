% Developer: FANG Huangcheng @ Bjtu
% Last updated: 2024-08-01
% Email: valy_f@bjtu.edu.cn;huangcheng.fang@polyu.edu.hk
% Website: https://www.researchgate.net/profile/Huangcheng-Fang
% Please do not remove this Header Comment under any circumstances, such as using or modifying this code, or convert this code to another programming language

function cz=correct_mapping_points(shape,z)
cz=complex(zeros(size(z)));
for ii=1:1:numel(z)
   dist=abs(shape-z(ii));
   [~,loc]=min(dist);
   lim=min(10,floor(numel(shape)/2));
   loc=loc+(-lim:1:lim);
   loc=mod(loc,numel(shape)); 
   loc(loc==0)=numel(shape);
   cp=complex(zeros(numel(loc)-1,1));
   dis=zeros(numel(loc)-1,1);
   for jj=1:1:numel(loc)-1
      vector=shape(loc(jj+1))-shape(loc(jj));
%       t=interect_line(shape(loc(jj:jj+1)),[0;z(ii)]);
      t=real(z(ii)-shape(loc(jj)))*real(vector)+imag(z(ii)-shape(loc(jj)))*imag(vector);
      t=t/abs(vector)/abs(vector);
      if abs(t)<=1
          cp(jj)=vector*t+shape(loc(jj));
      end
      if t>1
          cp(jj)=shape(loc(jj+1));
      end
      if t<0
          cp(jj)=shape(loc(jj));
      end
      dis(jj)=abs(cp(jj)-z(ii));
   end
   [~,mloc]=min(dis);
   cz(ii)=cp(mloc);
end
end

function t=interect_line(line1,line2)
line1=[real(line1(:)),imag(line1(:))];
line2=[real(line2(:)),imag(line2(:))];
k=[line1(2,1)-line1(1,1),line2(1,1)-line2(2,1);
   line1(2,2)-line1(1,2),line2(1,2)-line2(2,2);];
y=[line2(1,1)-line1(1,1)
    line2(1,2)-line1(1,2)];
if abs(det(k))<1e-8;t=1e16;return;end
t=k\y;
t=t(1);


end