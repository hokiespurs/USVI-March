%% CONSTANTS
DNAME = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\03_DELIVERABLES\01_GEOSPATIAL\';

ORTHO_BUCK  = [DNAME '06_SITEORTHOS/bigbuck.tif'];
RIEGL_BUCK  = [DNAME '05_OLDCONTROL/2014_NGSTOPOBATHYRIEGL/Buck.las'];
LADS_BUCK   = [DNAME '05_OLDCONTROL/2011_LADSMK2/Job427951_2011_usvi_bathymetry.las'];
EAARLB_BUCK = [DNAME '05_OLDCONTROL/2014_EAARLB/Job427949_2014_eaarlb_usvi.las'];
JABLTCX_BUCK = [DNAME '05_OLDCONTROL/2018_JABLTCX/allbuck.las'];

CAX = [-48 -41];
CAX2 = [-0.55 0.55];
CAX3 = [-0.225 0.225];
XAX = [0 600];
YAX = [0 500];
OFFX = 450;
OFFY = 725;
TSLABELIND = 1:15;
TSIGNORE = [1:4 18 19];

CMAP = [ ...
    94    79   162
    50   136   189
   102   194   165
   171   221   164
   230   245   152
   255   255   191
   254   224   139
   253   174    97
   244   109    67
   213    62    79
   158     1    66  ] / 255;

BIGTITLESIZE = 20;
SMALLTITLESIZE = 18;
LABELFONTSIZE = 16;
AXESFONTSIZE = 14;
%% LOAD ORTHO
[basemap, basemap_geo] = geotiffread(ORTHO_BUCK);
basmapgray = rgb2gray(basemap(:,:,1:3));

minX = min(basemap_geo.XWorldLimits) + OFFX;
minY = min(basemap_geo.YWorldLimits) + OFFY;

orthoX = basemap_geo.XWorldLimits-minX;
orthoY = basemap_geo.YWorldLimits-minY;

%% LOAD EAARLB
eaarlb = lasdata(EAARLB_BUCK);
eaarlb_xyz = [eaarlb.x-minX eaarlb.y-minY eaarlb.z];

%% LOAD JABLTCX
jabltcx = lasdata(JABLTCX_BUCK);
jabltcx_xyz = [jabltcx.x-minX jabltcx.y-minY jabltcx.z];

%% GRID DATA
DX = 2;
XI = XAX(1):DX:XAX(2);
YI = YAX(1):DX:YAX(2);
[xg,yg]=meshgrid(XI,YI);

zg_eaarlb = roundgridfun(eaarlb_xyz(:,1),eaarlb_xyz(:,2),eaarlb_xyz(:,3),xg,yg,@mean);
zg_jabltcx = roundgridfun(jabltcx_xyz(:,1),jabltcx_xyz(:,2),jabltcx_xyz(:,3),xg,yg,@mean);
dz = zg_jabltcx-zg_eaarlb;
dz2 = zg_jabltcx-zg_eaarlb - nanmean(zg_jabltcx(:)-zg_eaarlb(:));
%% 
f = figure(1);clf
set(f,'units','normalized','position',[0.05 0.05 0.8 0.8]);

axg = axgrid(2,2,0.1,0.05,0.05,0.9,0.1,0.9);
% set up axes
h_rgb = axg(1);
h_z = axg(2);
h_z_bg = axes('Position',h_z.Position);
h_dz = axg(4);
h_dz_bg = axes('Position',h_dz.Position);
h_hist = axg(3);

% hrgb
axes(h_rgb);
imagesc(orthoX,orthoY,flipud(basemap(:,:,1:3)));
set(h_rgb,'ydir','normal');
axis equal
xlim(XAX);
ylim(YAX);
grid on
xlabel('Relative Easting (m)','interpreter','latex','fontsize',LABELFONTSIZE)
ylabel('Relative Northing (m)','interpreter','latex','fontsize',LABELFONTSIZE)
title('UAS Generated Orthophoto','interpreter','latex','fontsize',18);

% h elevation
axes(h_z_bg)
imagesc(orthoX,orthoY,flipud(basmapgray));
set(h_z_bg,'ydir','normal');
axis equal
xlim(XAX);
ylim(YAX);
colormap(h_z_bg,gray);
grid on
xlabel('Relative Easting (m)','interpreter','latex','fontsize',LABELFONTSIZE)
ylabel('Relative Northing (m)','interpreter','latex','fontsize',LABELFONTSIZE)
title('JABLTCX Gridded Elevation','interpreter','latex','fontsize',18);

axes(h_z);
h_pcolorz = pcolor(XI,YI,zg_jabltcx);
h_pcolorz.FaceAlpha = 0.5;
shading flat
axis equal
xlim(XAX);
ylim(YAX);
caxis(CAX);
colormap(h_z,parula(10));
h_z.Visible = 'off';

h_colorbarZ = bigcolorbarax(h_z,0.01,0.03,'NAD83 Ellipsoid Height (m)','fontsize',16,'interpreter','latex');
h_colorbarZ.FontSize = AXESFONTSIZE;
h_colorbarZ.TickLabelInterpreter = 'latex';
colormap(h_colorbarZ,parula(10));
caxis(CAX);

% h dz
axes(h_dz);
h_pcolordz = pcolor(XI,YI,dz);
h_pcolordz.FaceAlpha = 0.5;
shading flat
axis equal
xlim(XAX);
ylim(YAX);
colormap(parula);
caxis([-0.5 0.5]);
colormap(h_dz,CMAP)
grid on
xlabel('Relative Easting (m)','interpreter','latex','fontsize',LABELFONTSIZE)
ylabel('Relative Northing (m)','interpreter','latex','fontsize',LABELFONTSIZE)
title('JABLTCX vs EAARLB Elevation Differences','interpreter','latex','fontsize',18);

h_colorbarDZ = bigcolorbarax(h_dz,0.01,0.03,'$Z_{JABLTCX} - Z_{EAARLB}$','fontsize',16,'interpreter','latex');
h_colorbarDZ.FontSize = AXESFONTSIZE;
h_colorbarDZ.TickLabelInterpreter = 'latex';
colormap(h_colorbarDZ,CMAP);
caxis([-0.5 0.5]);

axes(h_dz_bg)
h_img = imagesc(orthoX,orthoY,flipud(basmapgray));
set(h_dz_bg,'ydir','normal');
axis equal
xlim(XAX);
ylim(YAX);
colormap(h_dz_bg,gray);
h_img.AlphaData = 0.4;
h_dz_bg.Visible = 'off';

% h histogram
axes(h_hist);
histogram(dz(:),-1:0.025:1);
xlabel('Elevation Difference','interpreter','latex','fontsize',LABELFONTSIZE)
ylabel('Probability','interpreter','latex','fontsize',LABELFONTSIZE)
grid on
title('JABLTCX vs EAARLB Elevation Differences','interpreter','latex','fontsize',18);

% 
linkaxes([h_rgb,h_z,h_dz]);

% title
bigtitleax('2018 JABLTCX Data Comparison',[h_rgb h_z],0.02,'fontsize',24,'interpreter','latex');
%% 
f = figure(2);clf
set(f,'units','normalized','position',[0.01 0.05 0.88 0.8]);

axg = axgrid(2,3,0.1,0.1,0.05,0.85,0.05,0.9);
% set up axes
h_rgb = axg(1);
h_z = axg(2);
h_z2 = axg(3);
h_dz = axg(5);
h_hist = axg(4);
h_dz2 = axg(6);

% hrgb
axes(h_rgb);
imagesc(orthoX,orthoY,flipud(basemap(:,:,1:3)));
set(h_rgb,'ydir','normal');
hold on
contour(xg,yg,zg_jabltcx,[-50:1:-40],'w');

axis equal
xlim(XAX);
ylim(YAX);
grid on
xlabel('Relative Easting (m)','interpreter','latex','fontsize',LABELFONTSIZE)
ylabel('Relative Northing (m)','interpreter','latex','fontsize',LABELFONTSIZE)
title('UAS Generated Orthophoto','interpreter','latex','fontsize',18);

% h elevation
axes(h_z);
h_pcolorz = pcolor(XI,YI,zg_jabltcx);
shading flat
axis equal
xlim(XAX);
ylim(YAX);
caxis(CAX);
colormap(h_z,parula(256));
hold on
contour(xg,yg,zg_jabltcx,[-50:1:-40],'k');
grid on

xlabel('Relative Easting (m)','interpreter','latex','fontsize',LABELFONTSIZE)
ylabel('Relative Northing (m)','interpreter','latex','fontsize',LABELFONTSIZE)
title('JABLTCX Gridded Elevation','interpreter','latex','fontsize',18);

h_colorbarZ = bigcolorbarax(h_z,0.01,0.015,'NAD83 Ellipsoid Height (m)','fontsize',16,'interpreter','latex');
h_colorbarZ.FontSize = AXESFONTSIZE;
h_colorbarZ.TickLabelInterpreter = 'latex';
colormap(h_colorbarZ,parula(256));
caxis(CAX);

% h elevation
axes(h_z2);
h_pcolorz = pcolor(XI,YI,zg_eaarlb);
shading flat
axis equal
xlim(XAX);
ylim(YAX);
caxis(CAX);
colormap(h_z2,parula(256));
hold on
contour(xg,yg,zg_jabltcx,[-50:1:-40],'k');
grid on

xlabel('Relative Easting (m)','interpreter','latex','fontsize',LABELFONTSIZE)
title('EAARLB Gridded Elevation','interpreter','latex','fontsize',18);

h_colorbarZ = bigcolorbarax(h_z2,0.01,0.015,'NAD83 Ellipsoid Height (m)','fontsize',16,'interpreter','latex');
h_colorbarZ.FontSize = AXESFONTSIZE;
h_colorbarZ.TickLabelInterpreter = 'latex';
colormap(h_colorbarZ,parula(256));
caxis(CAX);

% h dz
axes(h_dz);
h_pcolordz = pcolor(XI,YI,dz);
hold on
contour(xg,yg,zg_jabltcx,[-50:1:-40],'k');

shading flat
axis equal
xlim(XAX);
ylim(YAX);
colormap(parula);
caxis([-0.55 0.55]);
colormap(h_dz,CMAP)
grid on
xlabel('Relative Easting (m)','interpreter','latex','fontsize',LABELFONTSIZE)
ylabel('Relative Northing (m)','interpreter','latex','fontsize',LABELFONTSIZE)
title('JABLTCX vs EAARLB Elevation Differences','interpreter','latex','fontsize',18);

h_colorbarDZ = bigcolorbarax(h_dz,0.01,0.015,'$Z_{JABLTCX} - Z_{EAARLB}$ (m)','fontsize',16,'interpreter','latex');
h_colorbarDZ.FontSize = AXESFONTSIZE;
h_colorbarDZ.TickLabelInterpreter = 'latex';
h_colorbarDZ.Ticks = [-0.5:0.1:0.5];
h_colorbarDZ.TickLabels = num2str((-.5:0.1:.5)','$%+.1f$');
colormap(h_colorbarDZ,CMAP);
caxis([-0.55 0.55]);

% h dz
axes(h_dz2);
h_pcolordz = pcolor(XI,YI,dz2);
hold on
contour(xg,yg,zg_jabltcx,[-50:1:-40],'k');

shading flat
axis equal
xlim(XAX);
ylim(YAX);
colormap(parula);
caxis([-0.275 0.275]);
colormap(h_dz2,CMAP)
grid on
xlabel('Relative Easting (m)','interpreter','latex','fontsize',LABELFONTSIZE)
title('JABLTCX vs EAARLB Elevation (De-meaned)','interpreter','latex','fontsize',18);

h_colorbarDZ2 = bigcolorbarax(h_dz2,0.01,0.015,'$Z_{JABLTCX} - Z_{EAARLB} - 0.11m$ (m)','fontsize',16,'interpreter','latex');
h_colorbarDZ2.FontSize = AXESFONTSIZE;
h_colorbarDZ2.TickLabelInterpreter = 'latex';
h_colorbarDZ2.Ticks = [-0.25:0.05:0.25];
h_colorbarDZ2.TickLabels = num2str((-.25:0.05:.25)','$%+.2f$');
colormap(h_colorbarDZ2,CMAP);
caxis([-0.275 0.275]);

% h histogram
axes(h_hist);
histogram(dz(:),-1:0.05:1,'Normalization','probability');
xlabel('Elevation Difference','interpreter','latex','fontsize',LABELFONTSIZE)
ylabel('Probability','interpreter','latex','fontsize',LABELFONTSIZE)
grid on
title('JABLTCX vs EAARLB Elevation Differences','interpreter','latex','fontsize',18);
hold on

notoutliers = abs(dz)<1.5;
meandz = nanmean(dz(notoutliers));
stddz = nanstd(dz(notoutliers));
mypdf = normpdf(-1:0.05:1,meandz,stddz)*0.05;
plot(-1:0.05:1,mypdf,'k-','linewidth',3);
text(0.7,0.85,sprintf('$\\mu = %.3fm$',meandz),...
    'interpreter','latex','fontsize',16,'units','normalize');
text(0.7,0.8,sprintf('$\\sigma = %.3fm$',stddz),...
    'interpreter','latex','fontsize',16,'units','normalize');



% 
linkaxes([h_rgb,h_z,h_dz]);

% title
bigtitleax('NW Buck Island, USVI',[h_rgb h_z h_z2],0.08,'fontsize',28,'interpreter','latex');
bigtitleax('2018 JABLTCX - 2014 EAARLB Comparison',[h_rgb h_z h_z2],0.035,'fontsize',28,'interpreter','latex');

