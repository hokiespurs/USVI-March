%% Example PlotCameraPyramid
K = [5000 0 2000;0 5000 1500;0 0 1];
R = [1 0 0;0 1 0; 0 0 -1];
[xcoords, ycoords]=meshgrid(-10:2:10,-10:2:10);

pix = [4000 3000];
optLine = {'linewidth',1,'color','k'};
optSides = {'faceColor','k','faceAlpha',0.1};
cmap = parula(numel(xcoords));
figure(1);clf;
for iCamera = 1:numel(xcoords)
    optPatch = {'facecolor',cmap(iCamera,:),'faceAlpha',0.5};
    C = [xcoords(iCamera), ycoords(iCamera), 20];
    plotCameraPyramid(K,R,C,pix,'s',2,...
        'optLine',optLine,'optPatch',optPatch,'optSides',optSides);
    axis equal;
    grid on
    zlim([0 20])
end

%%
figure(2);clf
K = [5000 0 2000;0 5000 1500;0 0 1];
R = [1 0 0;0 1 0; 0 0 -1];
C = [0 0 20];
pix = [4000 3000];
optLine = {'linewidth',3,'color','k'};
optPatch = {'facecolor','b','faceAlpha',0.5};
plotCameraPyramid(K,R,C,pix,'s',0.5,'optLine',optLine,'optPatch',optPatch)

%% 
figure(3);clf
R = euler2dcm(20*pi/180,180*pi/180,0*pi/180,'zyx');
optLine = {'linewidth',3,'color','k'};
optPatch = {'facecolor','b','faceAlpha',0.5};
plotCameraPyramid(K,R,C,pix,'s',0.5,'optLine',optLine,'optPatch',optPatch)
axis equal
