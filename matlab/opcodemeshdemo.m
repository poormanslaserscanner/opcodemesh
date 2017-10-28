function opcodemeshdemo()

% f = [1 2 3]'; v = [-1 0 0.1 ; 1 1 0.1 ; 1 -1 0.1]';
% t = opcodemesh(v,f);
% from = [0.17 0.17 0.5]';
% to = [0.17 0.17 -1]';
% [hit,d,trix,bary] = t.intersect(from,(to-from)./normc(to-from));
% B = bary(:,hit); T = trix(hit);
% Q = repmat(1-B(2,:)-B(1,:),3,1).*v(:,f(1,T)) + repmat(B(1,:),3,1).*v(:,f(2,T)) + repmat(B(2,:),3,1).*v(:,f(3,T));

 
fv = read_ply2('deer.ply');
v = fv.vertices';
f = fv.faces';

minb = min(v([3 2],:),[],2);
maxb = max(v([3 2],:),[],2);
t = opcodemesh(v,f);
v=v+0.2;
t.update(v);



%{
imgsz = 512;
bmin = min(v(:,[2 3]));
bmax = max(v(:,[2 3]));
mindist = 1e9;
maxdist = -1e9;

y = 1:imgsz;
x = 1:imgsz;
% view from the side
fracy = (imgsz-y)./imgsz;
cy = (bmax(1) - bmin(1)) .* fracy + bmin(1);
fracz = x./imgsz;
cz = (bmax(2) - bmin(2)) .* fracz + bmin(2);

[fz,fy] = meshgrid(cy,cz);
from = [-1000*ones(size(fy(:))) fy(:) fz(:)];
to = [1000*ones(size(fy(:))) fy(:) fz(:)];

[hit,d] = raycastmeshmex('intersect',t,from,to);


img_d = reshape(d,size(fz));
imagesc(img_d);
%}
%v=v'; f=f';
%T = trix(hit); B=bary(:,hit)
%Q = repmat(B(1,:),3,1).*v(:,f(1,T)) + repmat(B(2,:),3,1).*v(:,f(2,T)) + repmat(1-B(2,:)-B(1,:),3,1).*v(:,f(3,T));


imgsize = 300;

x = (1:imgsize) ./ imgsize .* (maxb(1) - minb(1)) + minb(1);
y = (1:imgsize) ./ imgsize .* (maxb(2) - minb(2)) + minb(2);
[X,Y] = meshgrid(x,y);
Y = flipud(Y);
Z = 1000*ones(size(X));

from = [-Z(:) Y(:) X(:)]';
to = [Z(:) Y(:) X(:)]';

[hit,d,trix,bary,Q] = t.intersect(from,to-from);

img_d = reshape(d,size(Z));
figure,imagesc(img_d);
%img_hit = reshape(hit,size(Z));
%figure,imagesc(img_hit);
%opcodemeshmex('delete',t);

return;

B = bary(:,hit);
T = trix(hit);
Qold = repmat(1-B(2,:)-B(1,:),3,1).*v(:,f(1,T)) + ...
    repmat(B(1,:),3,1).*v(:,f(2,T)) + ...
    repmat(B(2,:),3,1).*v(:,f(3,T));
