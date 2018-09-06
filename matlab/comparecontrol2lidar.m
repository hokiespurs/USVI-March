function [f,stats] = comparecontrol2lidar(lidarname,orthoname,kayakname,tsname,tsignore,FIGNUM,CAX,XAX,YAX,OFFX,OFFY,TITLESTR,TSLABELIND);

%% CONSTANTS
KAYAKPTSIZE = 20;
TSPTSIZE = 30;
CMAP = parula;

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
%% Read Data
[~,justname,~]=fileparts(orthoname);
fprintf('Processing "%s"... %s\n',justname,datestr(now));
fprintf('loading basemap...%s\n',datestr(now));
[basemap, basemap_geo] = geotiffread(orthoname);
basmapgray = rgb2gray(basemap(:,:,1:3));
if isempty(kayakname)
    kayak.e=nan;
    kayak.n=nan;
    kayak.ellip=nan;
else
    fprintf('loading kayak data...%s\n',datestr(now));

    kayak = readControlData(kayakname);
end
fprintf('loading ts data...%s\n',datestr(now));
ts = readControlData(tsname,tsignore);
%% Organize Data
minX = min(basemap_geo.XWorldLimits) + OFFX;
minY = min(basemap_geo.YWorldLimits) + OFFY;

orthoX = basemap_geo.XWorldLimits-minX;
orthoY = basemap_geo.YWorldLimits-minY;

kayakX = kayak.e-minX;
kayakY = kayak.n-minY;
kayakZ = kayak.ellip;

tsX = ts.e-minX;
tsY = ts.n-minY;
tsZ = ts.ellip;
tsID = ts.id;
%% Make xyzcontrol
xyz_ts = [tsX' tsY' tsZ'];
xyz_kayak = [kayakX' kayakY' kayakZ'];

xyz_control = [xyz_ts; xyz_kayak];

%% Read Lidar
lidarpts = lasdata(lidarname);

xyz_lidar = [lidarpts.x-minX lidarpts.y-minY lidarpts.z];
%% Grid Both Datasets
DX = 1;
[xg,yg]=meshgrid(XAX(1):DX:XAX(2),YAX(1):DX:YAX(2));
[zg_control,npts_control] = roundgridfun(xyz_control(:,1),xyz_control(:,2),xyz_control(:,3),xg,yg,@mean);
[zg_lidar,npts_lidar] = roundgridfun(xyz_lidar(:,1),xyz_lidar(:,2),xyz_lidar(:,3),xg,yg,@mean);
dz = zg_lidar - zg_control;

goodind = ~isnan(dz);
stats.x = xg(goodind);
stats.y = yg(goodind);
stats.dz = dz(goodind);
%% Compare Data
% stats = pointcloud2control(xyz_lidar, xyz_control, 1, 'makenormalZ',true,'dodebug',10);

%% Make Plot
f = figure(FIGNUM);clf
set(f,'units','normalized','position',[0.05 0.1 0.8 0.8]);

axg = axgrid(1,3,0.1,0.1);

ax_basemap = axg(1:2);
ax_delta = axes('Position',ax_basemap.Position);

% Basemap
axes(ax_basemap)
imagesc(orthoX,orthoY,flipud(basmapgray)*1.25);
set(gca,'fontsize',AXESFONTSIZE,'TickLabelInterpreter','latex');

xlabel('Relative Easting (m)','interpreter','latex','fontsize',LABELFONTSIZE)
ylabel('Relative Northing (m)','interpreter','latex','fontsize',LABELFONTSIZE)
title('Survey Points','interpreter','latex','fontsize',SMALLTITLESIZE);
grid on

% delta
axes(ax_delta)
% plot(xyz_control(:,1),xyz_control(:,2),'m.','markersize',3)
% hold on
scatter(stats.x,stats.y,20,stats.dz,'filled')
caxis([-0.55 0.55]);

% colormaps
colormap(ax_delta,CMAP);
colormap(ax_basemap,gray);

% link axes
axis([ax_basemap,ax_delta],'equal')
set([ax_basemap,ax_delta],'ydir','normal');
set([ax_basemap,ax_delta],'Xlim',XAX,'Ylim',YAX,'ydir','normal');
linkaxes([ax_basemap,ax_delta]);
ax_delta.Visible = 'off';

%
c = bigcolorbarax(ax_basemap,0.01,0.025,'dZ(m)','fontsize',LABELFONTSIZE,'interpreter','latex');
c.FontSize = AXESFONTSIZE;
c.TickLabelInterpreter = 'latex';
colormap(c,CMAP);
caxis([-0.55 0.55]);

% Histogram
ax_histogram = axg(3);
axes(ax_histogram);
histogram(stats.dz,-1:0.05:1,'Normalization','probability');
xlabel('Elevation Difference','interpreter','latex','fontsize',LABELFONTSIZE)
ylabel('Probability','interpreter','latex','fontsize',LABELFONTSIZE)
grid on
hold on
ax = axis;
notoutliers = abs(stats.dz)<1.5;
meandz = nanmean(stats.dz(notoutliers));
stddz = nanstd(stats.dz(notoutliers));
mypdf = normpdf(-1:0.05:1,meandz,stddz)*0.05;
plot(-1:0.05:1,mypdf,'k-','linewidth',3);
text(0.75,0.85,sprintf('$\\mu = %.3fm$',nanmean(stats.dz)),...
    'interpreter','latex','fontsize',16,'units','normalize');
text(0.75,0.8,sprintf('$\\sigma = %.3fm$',nanstd(stats.dz)),...
    'interpreter','latex','fontsize',16,'units','normalize');

bigtitleax(TITLESTR,[ax_basemap ax_histogram],0.025,'fontsize',BIGTITLESIZE,'interpreter','latex');

end