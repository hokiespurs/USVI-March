%%
LASNAME = 'C:\tmp\buck_trim.las';
% THETA = 0;
THETA = 32;

XI = 0:0.25:255;
YI = 0:0.25:180;
X0 = 327535;
Y0 = 1967550;
PLOTIND = 100;
PLOTZOFF = 41.2;
%%
dat = lasdata(LASNAME);
dat.get_color;
npts = numel(dat.x);

%% Bring data back to origin
x = dat.x-X0;
y = dat.y-Y0;

x2 = x.*cosd(THETA) + y.*sind(THETA);
y2 = -x.*sind(THETA) + y.*cosd(THETA);

%%
[xg,yg]=meshgrid(XI,YI);

%%
figure(1);clf
ind = 1:PLOTIND:npts;
plot(x2(ind),y2(ind),'b.');
hold on
plot(xg,yg,'r.-')
axis equal

%% 
Rg = roundgridfun(x2,y2,double(dat.red/255),xg,yg,@nanmean);
Gg = roundgridfun(x2,y2,double(dat.green/255),xg,yg,@nanmean);
[Bg,n] = roundgridfun(x2,y2,double(dat.blue/255),xg,yg,@nanmean);

zg = roundgridfun(x2,y2,double(dat.z),xg,yg,@nanmin);

Rg(n==0)=255;
Gg(n==0)=255;
Bg(n==0)=255;

RGB = uint8(cat(3,Rg,Gg,Bg));
%
f2 = figure(2);clf
axg = axgrid(2,1,0.075,0.05,0.1,0.95,0.1,0.9);
axg(1);
imagesc(XI,YI,histeq(RGB)/2+(RGB)/2);
set(gca,'ydir','normal');
axis equal
ylabel('Cross-shore Coordinate(m)','fontsize',16,'interpreter','latex');
axis tight
titlestr = {'RGB Orthophoto'};
title(titlestr,'interpreter','latex','fontsize',18)

axg(2)
pcolor(xg,yg,zg+PLOTZOFF);shading flat

axis equal
caxis([-44 -39]+PLOTZOFF)
demcmap([-3.3 4])
axis tight
xlabel('Along-shore Coordinate(m)','fontsize',16,'interpreter','latex');
ylabel('Cross-shore Coordinate(m)','fontsize',16,'interpreter','latex');

titlestr = {'Digital Surface Model (DSM)'};
title(titlestr,'interpreter','latex','fontsize',18)
set(gca,'GridColor',[0.9 0.9 0.9])

h = bigcolorbarax(axg(2),-.03,0.03,'Approximate Orthometric Elevation(m)','interpreter','latex','fontsize',15);
caxis([-3.3 4])

saveas(f2,'rgbdsm_NWbuck.png');