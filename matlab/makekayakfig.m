%% Constants
FNAME = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\03_DELIVERABLES\01_GEOSPATIAL\06_SITEORTHOS/rod.tif';
KAYAKNAME = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\03_DELIVERABLES\01_GEOSPATIAL\01_CONTROL/20180330_RODBAY_SONAR_APPLIEDDEPTH.csv';
pt = [328900 1961650];
az =  243;

ASI = 0:.1:350;
XSI = -50:.1:250;

[asg, xsg] = meshgrid(ASI,XSI);

%% Read Orthophoto
% [I,X]=geotiffread(FNAME);
[m,n,p]=size(I);
ei = linspace(X.XWorldLimits(1),X.XWorldLimits(2),n);
ni = linspace(X.YWorldLimits(2),X.YWorldLimits(1),m);
Igray = rgb2gray(I(:,:,1:3));

%% Read Kayak Data
kayak = readControlData(KAYAKNAME);
[kayak.Xs, kayak.As] = calcXsAs(kayak.e,kayak.n,pt,az);

%% Grid Ortho to new grid
[imeg,imng]=meshgrid(ei,ni);
[imxs,imas]=calcXsAs(imeg,imng,pt,az);

%% Interpolate Ortho
I2 = roundgridfun(imas,imxs,Igray,asg,xsg,@mean);
I2 = repmat(uint8(I2),[1 1 3]);

%% Visualize
figure(1);clf
ax = axes('position',[0.1 0.1 0.8 0.8]);
imagesc(ASI,XSI,I2);
set(gca,'ydir','normal');
hold on
scatter(kayak.As,kayak.Xs,10,-kayak.depth,'filled');

set(gca,'fontsize',18);
set(gca,'TickLabelInterpreter','latex');

colormap(parula(256));
c = colorbar;
ylabel(c,'Sonar Depth(m)','fontsize',20,'interpreter','latex');
caxis([-2 0]);
vals = c.Ticks;
valstr = num2labelstr(vals,'$%+2.1f$');
c.TickLabels = valstr;
c.TickLabelInterpreter = 'latex';

axis equal
axis tight
grid on

xlim([ASI(1) ASI(end)]);
ylim([XSI(1) XSI(end)]);

xlabel('Along-shore Position(m)','fontsize',18,'interpreter','latex');
ylabel('Cross-shore Position(m)','fontsize',18,'interpreter','latex');
title('Single Beam Sonar Depths','fontsize',24,'interpreter','latex');
bigtitleax('Rod Bay, USVI, March 30, 2018',ax,-0.04,'fontsize',18,'interpreter','latex','color','w');
