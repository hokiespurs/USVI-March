%% test photogrammetry
% make up data
T = [0 0 100];
rpy = [210 10 -30]*pi/180;
R = euler2dcm(rpy(1),rpy(2),rpy(3));

K = [2 0 3;0 2 2;0 0 1];

zElev = 0;
% generate function ro project uv 2 xyz
projectionfun = @(u,v) uv2xyzConstZ(K,R,T,u,v,zElev);

% project full uv grid
[u,v]=meshgrid(1:6,1:4);
[x,y,z] = projectionfun(u,v);

% calculate corners of all pixels
[x1,y1,z1,x2,y2,z2,x3,y3,z3,x4,y4,z4] = uv2xyzCorners(projectionfun,u,v);

% calculate footprint specs
[a,b,az,el,h]=uv2xyzfootprint(x1,y1,z1,x2,y2,z2,x3,y3,z3,x4,y4,z4);

% Plot Data
figure(1);clf;hold on
% plot z plane
patch([-200 -200 200 200],[-200 200 200 -200],[1 1 1 1]*zElev,'b');alpha(0.2)

% plot individual pixel
cmap = parula(256);
pixArea = (a+b).*h/2;
plotval = pixArea;
plotvallim = [min(plotval(:)) max(plotval(:))];
val = num2ind(plotval,plotvallim,256);
patch([x1(:) x2(:) x3(:) x4(:)]',[y1(:) y2(:) y3(:) y4(:)]',...
     [z1(:) z2(:) z3(:) z4(:)]',plotval(:)','EdgeColor',[0.4 0.4 0.4]);

 % color with rgb
% patch([x1(:) x2(:) x3(:) x4(:)]',[y1(:) y2(:) y3(:) y4(:)]',...
%     [z1(:) z2(:) z3(:) z4(:)]',permute(cmap(val,:),[1 3 2]),'EdgeColor',[0.4 0.4 0.4]);

colorbar
caxis(plotvallim)

% pcolor a
% pcolor(x,y,(b+a).*h/2);shading flat

% plot image pixel centers
plot3(x,y,z,'k.','markersize',10);

% plot image origin
plot(0,0,'r+','markersize',20)

% plot upper left metrics
u = [1 1];v=[0.5 1.5];
[x,y,z] = projectionfun(u,v);
plot3(x,y,z,'b.-')

u = [0.5 1.5];v=[1 1];
[x,y,z] = projectionfun(u,v);
plot3(x,y,z,'b.-')

xv = [(x1(1)+x2(1))/2 (x3(1)+x4(1))/2];
yv = [(y1(1)+y2(1))/2 (y3(1)+y4(1))/2];
zv = [(z1(1)+z2(1))/2 (z3(1)+z4(1))/2];

xh = [(x3(1)+x2(1))/2 (x1(1)+x4(1))/2];
yh = [(y3(1)+y2(1))/2 (y1(1)+y4(1))/2];
zh = [(z3(1)+z2(1))/2 (z1(1)+z4(1))/2];

plot3([x1(1) x3(1)],[y1(1) y3(1)],[z1(1) z3(1)],'k-');
plot3([x2(1) x4(1)],[y2(1) y4(1)],[z2(1) z4(1)],'k-');

xo = (x1+x2+x3+x4)/4;
yo = (y1+y2+y3+y4)/4;
zo = (z1+z2+z3+z4)/4;

plot3(xv,yv,zv,'m-')
plot3(xh,yh,zh,'m-')
plot3(xo,yo,zo,'m.','markersize',10)
axis equal
grid on