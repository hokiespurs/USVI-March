function f = makeControlMap(orthoname,kayakname,tsname,tsignore,FIGNUM,CAX,XAX,YAX,OFFX,OFFY,TITLESTR,TSLABELIND)

%% CONSTANTS
KAYAKPTSIZE = 20;
TSPTSIZE = 30;
CMAP = parula;

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

%%
% Organize Data
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

% Organize subplots
f = figure(FIGNUM);clf
set(f,'units','normalized','position',[0.05 0.1 0.8 0.8]);
axg = axgrid(2,2,0.1,0.15,0.075,0.9,0.1,0.85);

ax_basemapkayak = axg(1);
ax_kayakscatter = axes('Position',ax_basemapkayak.Position);
ax_basemapts = axg(3);
ax_tsscatter = axes('Position',ax_basemapts.Position);

linkaxes([ax_basemapkayak,ax_kayakscatter]);
linkaxes([ax_basemapts,ax_tsscatter]);

colormap(ax_kayakscatter,CMAP);
colormap(ax_tsscatter,CMAP);
colormap(ax_basemapkayak,gray);
colormap(ax_basemapts,gray);

% Kayak Basemap
axes(ax_basemapkayak)
imagesc(orthoX,orthoY,flipud(basmapgray));
title('Kayak Single Beam Sonar Survey','interpreter','latex','fontsize',SMALLTITLESIZE);
set(gca,'fontsize',AXESFONTSIZE,'TickLabelInterpreter','latex');
ylabel('Relative Northing (m)','interpreter','latex','fontsize',LABELFONTSIZE)
xlabel('Relative Easting (m)','interpreter','latex','fontsize',LABELFONTSIZE)
grid on

% TS Basemap
axes(ax_basemapts)
imagesc(orthoX,orthoY,flipud(basmapgray));
grid on

set(gca,'fontsize',AXESFONTSIZE,'TickLabelInterpreter','latex');
title('Total Station Survey','interpreter','latex','fontsize',SMALLTITLESIZE);
ylabel('Relative Northing (m)','interpreter','latex','fontsize',LABELFONTSIZE)
xlabel('Relative Easting (m)','interpreter','latex','fontsize',LABELFONTSIZE)

% scatter Kayak Data
axes(ax_kayakscatter);
scatter(kayakX,kayakY,KAYAKPTSIZE,kayakZ,'filled')
caxis(CAX);
if isempty(kayakname)
    h = text(mean(XAX),mean(YAX),'NO KAYAK DATA',...
        'HorizontalAlignment','center','color','red','interpreter','latex',...
        'fontsize',16);
end

% scatter TS Data
axes(ax_tsscatter);
hold on
scatter(tsX(TSLABELIND),tsY(TSLABELIND),TSPTSIZE,tsZ(TSLABELIND),'filled')
scatter(tsX,tsY,KAYAKPTSIZE,tsZ,'filled')
plot(tsX(TSLABELIND),tsY(TSLABELIND),'ro','markersize',TSPTSIZE/4)

caxis(CAX);
text(tsX(TSLABELIND)+2,tsY(TSLABELIND),fixfigstring(tsID(TSLABELIND)),...
    'color','r','fontsize',12,'interpreter','tex','FontWeight','bold');

% hide front axes
ax_kayakscatter.Visible = 'off';
ax_tsscatter.Visible = 'off';

axis([ax_basemapkayak,ax_kayakscatter,ax_basemapts,ax_tsscatter],'equal')
set([ax_basemapkayak,ax_kayakscatter,ax_basemapts,ax_tsscatter],'ydir','normal');
set([ax_basemapkayak,ax_kayakscatter,ax_basemapts,ax_tsscatter],...
    'Xlim',XAX,'Ylim',YAX,'ydir','normal');

% make big colorbar
c = bigcolorbarax([ax_kayakscatter ax_tsscatter],0.01,0.025,'Ellipsoid Height(m)','fontsize',LABELFONTSIZE,'interpreter','latex');
c.FontSize = AXESFONTSIZE;
c.TickLabelInterpreter = 'latex';
colormap(c,CMAP);
caxis(CAX)

% make big title
bigtitleax(TITLESTR,ax_basemapkayak,0.025,'fontsize',BIGTITLESIZE,'interpreter','latex');

%% Compare TS to Kayak in new Figure
xyz_kayak = [kayakX' kayakY' kayakZ'];
xyz_ts    = [tsX' tsY' tsZ'];

datadelta = pointcloud2control(xyz_kayak,xyz_ts,2,'makenormalZ',true);

% figure(10+FIGNUM);clf
% axg = axgrid(1,3,0.05,0.05,0.1,0.8,0.1,0.9);

ax_basemap = axg(2);
ax_delta = axes('Position',ax_basemap.Position);

% Basemap
axes(ax_basemap)
imagesc(orthoX,orthoY,flipud(basmapgray));
set(gca,'fontsize',AXESFONTSIZE,'TickLabelInterpreter','latex');

xlabel('Relative Easting (m)','interpreter','latex','fontsize',LABELFONTSIZE)
ylabel('Relative Northing (m)','interpreter','latex','fontsize',LABELFONTSIZE)
title('Survey Points','interpreter','latex','fontsize',SMALLTITLESIZE);

grid on

% Delta
axes(ax_delta);
plot(kayakX,kayakY,'g.');
hold on
plot(tsX,tsY,'r.','markersize',10);
% scatter(tsX,tsY,KAYAKPTSIZE,[datadelta.median]','filled')
caxis([-0.5 0.5]);
[h,icons,plots,legend_text] = legend({'Sonar','Total Station'},'interpreter','latex','fontsize',16);
icons(4).MarkerSize = 20;
icons(6).MarkerSize = 20;

% Histogram
ax_histogram = axg(4);
histogram([datadelta.median],-1:0.05:1)
xlabel('Sonar vs Total Station Elevation Difference (m)','interpreter','latex','fontsize',LABELFONTSIZE)
ylabel('Frequency (count)','interpreter','latex','fontsize',LABELFONTSIZE)
title('Elevation Difference','interpreter','latex','fontsize',SMALLTITLESIZE);
grid on

% colormaps
colormap(ax_delta,CMAP);
colormap(ax_basemap,gray);

% link axes
axis([ax_basemap,ax_delta],'equal')
set([ax_basemap,ax_delta],'ydir','normal');
set([ax_basemap,ax_delta],'Xlim',XAX,'Ylim',YAX,'ydir','normal');
linkaxes([ax_basemap,ax_delta]);
ax_delta.Visible = 'off';

bigtitleax(TITLESTR,ax_basemapkayak,0.025,'fontsize',BIGTITLESIZE,'interpreter','latex');

drawnow
end
