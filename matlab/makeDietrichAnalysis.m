function f = makeDietrichAnalysis(ortho, dietrich, tideval, sfmcompare, justname)
%%
XLABELARGS = {'interpreter','latex','fontsize',16};
YLABELARGS = {'interpreter','latex','fontsize',16};
TITLEARGS = {'interpreter','latex','fontsize',20};
COLORBARARGS = {'interpreter','latex','fontsize',14};
LEGENDARGS = {'interpreter','latex','fontsize',14};
TEXTARGS = {'interpreter','latex','fontsize',14};
SCATTERPTSIZE = 10;
HISTRANGE = -2:0.05:2;
CAXDEPTH = [-1.25 4.25];
CONTOURLIMS = -1:4;

f = figure(106);clf
set(f,'units','normalize','position',[0.05 0.05 0.8 0.8])

axg = axgrid(3,3,0.075,0.075,0.05,0.85,0.05,0.9);
h = [];
%% Calculations
trueDepth = tideval - sfmcompare.lidar.Zg;
sfmDepth = tideval - sfmcompare.dense.Zg;
dietrichdepth = tideval - dietrich.dense.corDepth;

%% GroundTruth Depth
h(1) = axg(1);
pcolor(sfmcompare.AsGrid,sfmcompare.XsGrid,trueDepth);
hold on
contour(sfmcompare.AsGrid,sfmcompare.XsGrid,trueDepth,CONTOURLIMS,'k-');

shading flat
ylabel('Cross-shore(m)',YLABELARGS{:});
title('Lidar Groundtruth Depth',TITLEARGS{:});
caxis(CAXDEPTH);
colormap(h(1),flipud(parula(11)));
grid on
axis equal
%% Ortho w/ contours
h(2) = axg(2);
imagesc(ortho.As,ortho.Xs,ortho.rgb);
hold on
contour(sfmcompare.AsGrid,sfmcompare.XsGrid,trueDepth,CONTOURLIMS,'w-');

set(gca,'ydir','normal');
axis equal

title('Dense RGB',TITLEARGS{:});
grid on
%% Histogram
XLIMS = [-3 3];
XI = -3:0.1:3;
YI = -3:0.1:3;
YLIMS = [-3 3];
h(3) = axg([3 6]);
cmap = jet(11);
plotratio = 1:0.1:2;
[~,X] = heatmapscat(trueDepth,sfmDepth-trueDepth,XI,YI,false,false);

X(isnan(X))=0;
X = X./repmat(max(X),size(X,1),1);
pcolor(XI,YI,X);shading flat
grid on
set(gca,'GridColor',[1 1 1]);
hold on
for i=0:10
   plot([0 10],[0 -10*plotratio(i+1)+10],'-','color',cmap(i+1,:),'linewidth',1); 
end
% plot(trueDepth,sfmDepth-trueDepth,'k.','markersize',1);
xticks(XLIMS(1):1:XLIMS(2));
yticks(XLIMS(1):1:XLIMS(2));

colormap(h(3),'gray');

xlabel('True Depth(m)',XLABELARGS{:});
ylabel('Error(m)',YLABELARGS{:});
title('Dense SfM vs Truth',TITLEARGS{:});

axis equal
axis tight
xlim(XLIMS);
ylim(YLIMS);
%% No Correction SfM Depth
h(4) = axg(4);
pcolor(sfmcompare.AsGrid,sfmcompare.XsGrid,sfmDepth);shading flat
hold on
contour(sfmcompare.AsGrid,sfmcompare.XsGrid,trueDepth,CONTOURLIMS,'k-');

axis equal

colormap(h(4),flipud(parula(11)));

caxis(CAXDEPTH);

ylabel('Cross-shore(m)',YLABELARGS{:});
title('Dense SfM Depth',TITLEARGS{:});
grid on
%% Dietrich Ratio
h(5) = axg(5);
pcolor(sfmcompare.AsGrid,sfmcompare.XsGrid,trueDepth./sfmDepth);shading flat
caxis([1 2]);

grid on
colormap(h(5),jet(11));
axis equal

%% Dietrich Depth
% h(6) = axg(6);

%% Spatial Error
h(7) = axg(7);
pcolor(sfmcompare.AsGrid,sfmcompare.XsGrid,dietrichdepth);shading flat
hold on;
contour(sfmcompare.AsGrid,sfmcompare.XsGrid,trueDepth,CONTOURLIMS,'k-');

axis equal

colormap(h(7),flipud(parula(11)));

caxis(CAXDEPTH);

xlabel('Along-shore(m)',XLABELARGS{:});
ylabel('Cross-shore(m)',YLABELARGS{:});
title('Dietrich Depth',TITLEARGS{:});
grid on
%% Histogram
h(8) = axg(8);
pcolor(sfmcompare.AsGrid,sfmcompare.XsGrid,dietrichdepth./sfmDepth);shading flat
caxis([1 2]);

grid on
colormap(h(8),jet(11));
axis equal
xlabel('Along-shore(m)',XLABELARGS{:});

%% Spatial Error
h(9) = axg(9);
pcolor(sfmcompare.AsGrid,sfmcompare.XsGrid,trueDepth-dietrichdepth);shading flat
xlabel('Along-shore(m)',XLABELARGS{:});
title('Dietrich Error',TITLEARGS{:});
grid on
caxis([-1.05 1.05]);
colormap(h(9),cmapdiverge);
axis equal

%%
hc1 = bigcolorbarax([h(1) h(4) h(7)],0.01,0.02,'Depth(m)','interpreter','latex','fontsize',12);
caxis(CAXDEPTH);
colormap(hc1,flipud(parula(11)));

hc2 = bigcolorbarax([h(5) h(8)],0.01,0.02,'Ratio','interpreter','latex','fontsize',12);
caxis([0.95 2.05]);
colormap(hc2,jet(11));

hc3 = bigcolorbarax(h(9),0.01,0.02,'Difference(m)','interpreter','latex','fontsize',12);
caxis([-1.05 1.05]);
colormap(hc3,cmapdiverge);
%%
bigtitle('Dietrich Analysis',0.5,0.94,'fontsize',24,'interpreter','latex');
bigtitle(strrep(justname,'_','\_'),0.5,0.9,TITLEARGS{:});

end