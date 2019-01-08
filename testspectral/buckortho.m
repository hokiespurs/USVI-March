%% Constants
FNAME = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\06_PROCIMAGES\0320_BUCK_MAVIC_400FT\06_QUICKPROC\nogcps4_trajacc\dense.las';
KAYAKNAME = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\03_DELIVERABLES\01_GEOSPATIAL\01_CONTROL/20180330_RODBAY_SONAR_APPLIEDDEPTH.csv';
justname = '0320_BUCK_MAVIC_400FT';

pt = [327500, 1967500];
az = 56.55;

ASI = -50:.1:400;
XSI = -50:.1:250;

[asg, xsg] = meshgrid(ASI,XSI);

dense = readLAS(FNAME);
[dense.Xs, dense.As] = calcXsAs(dense.E,dense.N,pt,az);

ortho = makeortho(dense,0.5,justname);
%%
CONTROLNAME = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\03_DELIVERABLES\01_GEOSPATIAL\05_OLDCONTROL\2018_JABLTCX\allbuck.las';
densecontrol = readLAS(CONTROLNAME);
[densecontrol.Xs, densecontrol.As] = calcXsAs(densecontrol.E,densecontrol.N,pt,az);
densecontrol.Zg = roundgridfun(densecontrol.As,densecontrol.Xs,densecontrol.Z,ortho.As(1:5:end,1:5:end),ortho.Xs(1:5:end,1:5:end),@mean);

%%
f= figure(2);clf
axg = axgrid(1,2,0.05,0.05,0.15,0.85,0.05,0.85);

axg(1);
image(ortho.As,ortho.Xs,ortho.rgb);
set(gca,'ydir','normal');

axis equal
xlim([50 600])
ylim([0 400])
    set(gca,'fontsize',16)
    set(gca,'TickLabelInterpreter','latex');
    
ylabel('Cross-shore Position(m)','interpreter','latex','fontsize',20);
xlabel('Along-shore Position(m)','interpreter','latex','fontsize',20);
title('Orthophoto','interpreter','latex','fontsize',24);


ax2=axg(2);
pcolor(ortho.As(1:5:end,1:5:end),ortho.Xs(1:5:end,1:5:end),densecontrol.Zg-idat.tideval);shading flat
caxis([-5 2]);

axis equal
xlim([50 600])
ylim([0 400])
    set(gca,'fontsize',16)
    set(gca,'TickLabelInterpreter','latex');
    
    ylabel('Cross-shore Position(m)','interpreter','latex','fontsize',20);
xlabel('Along-shore Position(m)','interpreter','latex','fontsize',20);
title('Bathymetry','interpreter','latex','fontsize',24);

grid on

c = bigcolorbarax(ax2,0.025,0.025,'Elevation (m)','interpreter','latex','fontsize',24);
caxis([-5 2]);
set(gca,'fontsize',24);
cticks = c.Ticks;
c.TickLabelInterpreter = 'latex';
c.TickLabels = num2labelstr(cticks,'$%+02.1f$ ');