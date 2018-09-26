function makeSfMStatsPlot(fname,justname,pstrajectory,trajectory,sensor,dense,sparse,tideval, ortho, camposerror)
%% Make 3x3 figure with lots of info
f = figure(100);clf
axg = axgrid(3,3,0.1,0.1,0.05,0.9,0.05,0.95);
h = nan(1,9);
XLABELARGS = {'interpreter','latex','fontsize',16};
YLABELARGS = {'interpreter','latex','fontsize',16};
TITLEARGS = {'interpreter','latex','fontsize',20};
COLORBARARGS = {'interpreter','latex','fontsize',20};
LEGENDARGS = {'interpreter','latex','fontsize',14};
TEXTARGS = {'interpreter','latex','fontsize',14};
%% Ortho
h(1) = axg(1);
imagesc(ortho.As,ortho.Xs,ortho.rgb);
hold on
plot(trajectory.As,trajectory.Xs,'m.','markersize',5);
plot(pstrajectory.As,pstrajectory.Xs,'g.','markersize',5);

set(gca,'ydir','normal');
axis equal

xlabel('Along-shore(m)',XLABELARGS{:});
ylabel('Cross-shore(m)',YLABELARGS{:});
title('Dense RGB',TITLEARGS{:});

%% Elevation
h(2) = axg(2);
pcolor(ortho.As,ortho.Xs,ortho.Zg-tideval);shading flat

c = colorbar;
ylabel(c,'Ellipsoid Elevation(m)',COLORBARARGS{:});

axis equal

colormap(h(2),parula(11));

xlabel('Along-shore(m)',XLABELARGS{:});
ylabel('Cross-shore(m)',YLABELARGS{:});
title('Elevation(m)',TITLEARGS{:});

%% Camera Calibration Table
h(3) = axg(3);
text(0,1.0,sprintf('Width : %10.0f',sensor.pixx),TEXTARGS{:});
text(0,0.9,sprintf('Height : %10.0f',sensor.pixy),TEXTARGS{:});
text(0,0.8,sprintf('f : %10.2f',sensor.f),TEXTARGS{:});
text(0,0.7,sprintf('cx : %10.2f',sensor.cx),TEXTARGS{:});
text(0,0.6,sprintf('cy : %10.2f',sensor.cy),TEXTARGS{:});
text(1,1.0,sprintf('b1 : %10.6f',sensor.b1),TEXTARGS{:});
text(1,0.9,sprintf('b2 : %10.6f',sensor.b2),TEXTARGS{:});
text(1,0.8,sprintf('k1 : %10.6f',sensor.k1),TEXTARGS{:});
text(1,0.7,sprintf('k2 : %10.6f',sensor.k2),TEXTARGS{:});
text(1,0.6,sprintf('k3 : %10.6f',sensor.k3),TEXTARGS{:});
text(1,0.5,sprintf('k4 : %10.6f',sensor.k4),TEXTARGS{:});
text(1,0.4,sprintf('p1 : %10.6f',sensor.p1),TEXTARGS{:});
text(1,0.3,sprintf('p2 : %10.6f',sensor.p2),TEXTARGS{:});
ylim([0.2 1.1]);
xlim([-0.1 2.1]);
grid on
axis off;
%% Gray Ortho + Camera Locations + Direction
h(6) = axg(6);
hold off
orthogray = rgb2gray(ortho.rgb);
orthogray = cat(3,orthogray,orthogray,orthogray);
hi = imagesc(ortho.As,ortho.Xs,orthogray);
hold on
hq = quiver(camposerror.As,camposerror.Xs,camposerror.dAs,camposerror.dXs,'r');
hs = scatter(camposerror.As,camposerror.Xs,30,camposerror.dZ,'filled');

hl = legend({sprintf('XY Error (Scale=%.1f)',hq.AutoScaleFactor),'Z Error'},LEGENDARGS{:},'location','northoutside');
oldlegendpos = hl.Position;
newlegendpos = oldlegendpos + [0 0.075 0 0];
hl.Position = newlegendpos;

c = colorbar;
ylabel(c,'Z Error(m)',COLORBARARGS{:});

axis equal

colormap(h(6),cmapdiverge);

xlabel('Along-shore(m)',XLABELARGS{:});
ylabel('Cross-shore(m)',YLABELARGS{:});
title('Camera Error',TITLEARGS{:});

set(gca,'ydir','normal');
axis equal
%% NCameras
h(5) = axg(5);
pcolor(ortho.As,ortho.Xs,ortho.ncameras);shading flat

labelnums = (1:9).^2;
labelinds = 2*(labelnums(1:end-1)+diff(labelnums)/2);
labelstr = {' 1 (<50%)',' 2 (50%)',' 3 (66%)',' 4 (75%)',' 5 (80%)',' 6 (83.7%)',' 7 (85%)',' 8 (88%)'};
colors = parula(8);

cmap = nan(labelinds(end),3);
cmap(1:labelinds(1),:)=repmat(colors(1,:),numel(1:labelinds(1)),1);
for i=2:numel(labelinds)
    cmap(labelinds(i-1)+1:labelinds(i),:)=repmat(colors(i,:),numel(labelinds(i-1)+1:labelinds(i)),1);
end

c = colorbar;
ylabel(c,'Number of Cameras',COLORBARARGS{:});
c.Ticks = labelnums;
c.TickLabels = labelstr;

caxis([0 labelinds(end)/2]);
colormap(h(5),cmap);

axis equal;

xlabel('Along-shore(m)',XLABELARGS{:});
ylabel('Cross-shore(m)',YLABELARGS{:});
title('Number of Cameras',TITLEARGS{:});
%% Point Density
h(4) = axg(4);
pcolor(ortho.As,ortho.Xs,ortho.ptdensity);shading flat
axis equal;

c = colorbar;
ylabel(c,'Dense Point Density',COLORBARARGS{:});

meanptdensity = nanmean(ortho.ptdensity(:));
stdptdensity  = nanstd(ortho.ptdensity(:));
caxlow = meanptdensity-2*stdptdensity;
caxhigh = meanptdensity+2*stdptdensity;
caxis([caxlow caxhigh]); 

colormap(h(4),parula(11));

xlabel('Along-shore(m)',XLABELARGS{:});
ylabel('Cross-shore(m)',YLABELARGS{:});
title('Points / $m^2$',TITLEARGS{:});

%% Histogram Camera Error
h(9) = axg(9);
hold off
histogram(camposerror.dAs,-3:0.1:3);
hold on
histogram(camposerror.dXs,-3:0.1:3);
histogram(camposerror.dZ,-3:0.1:3);

legendstr = {'$\Delta$ As','$\Delta$ Xs','$\Delta$ Z'};
legend(legendstr,LEGENDARGS{:});

xlabel('Camera Error',XLABELARGS{:});
ylabel('Frequency',YLABELARGS{:});
title('Camera Error',TITLEARGS{:});

%% Histogram N Cameras
h(8) = axg(8);
histogram(ortho.ncameras(:),0:1:60);

xlabel('Number of Cameras',XLABELARGS{:});
ylabel('Frequency',YLABELARGS{:});
title('Number of Cameras',TITLEARGS{:});

%% Histogram Point Density
h(7) = axg(7);
histogram(ortho.ptdensity(:),0:100:2000);

xlabel('Point Density',XLABELARGS{:});
ylabel('Frequency',YLABELARGS{:});
title('Point Density',TITLEARGS{:});

%% Big Title
bigtitle(justname,0.5,0.95,'interpreter','latex','fontsize',24);

%% Save Figure
saveas(f,fname);
end