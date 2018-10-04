% coral head figure for tim
fname = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\06_PROCIMAGES\0323_BUCK_MAVIC_100FT\06_QUICKPROC\gcps4_trajacc\dense.las';
tideval = -41.23;
%% Read Data
dense = LASread(fname);
xyz = [dense.record.x dense.record.y dense.record.z-tideval];
rgb = uint8([dense.record.red dense.record.green dense.record.blue]/255);

%% Convert to Xs - As
pt = [327500, 1967500];
az = 56.55;
[Xs, As] = calcXsAs(xyz(:,1),xyz(:,2),pt,az);

%% Grid Data to RGB and Zg
XSLIM = [20 160];
ASLIM = [200 360];
DX = 0.1;

Xsi = XSLIM(1):DX:XSLIM(2);
Asi = ASLIM(1):DX:ASLIM(2);

% make rgb image
R = uint8(roundgridfun(As,Xs,double(rgb(:,1)),Asi,Xsi,@mean));
G = uint8(roundgridfun(As,Xs,double(rgb(:,2)),Asi,Xsi,@mean));
B = uint8(roundgridfun(As,Xs,double(rgb(:,3)),Asi,Xsi,@mean));

rgb_grid = cat(3,R,G,B);

% make Z grid
Zg = roundgridfun(As,Xs,xyz(:,3),Asi,Xsi,@mean);

%% Extract Profile 
P1 = [327654 1967724];
% P2 = [327709 1967750];
P2 = [327652 1967776];

PROFWIDTH = 0.1;
DOWNLINETHRESH = 0;

[PXs, PAs] = calcXsAs([P1(1) P2(1)],[P1(2) P2(2)],pt,az);

[profileinds, downlineoffline] = extractProfile(P1,P2,PROFWIDTH,DOWNLINETHRESH,xyz(:,1:2));

%% Make Plots
XYLABELARGS = {'interpreter','latex','fontsize',18};
LINEARGS = {'.-','color','m','linewidth',2,'markersize',20};
TITLEARGS = {'interpreter','latex','fontsize',20};
LEGENDARGS = {'interpreter','latex','fontsize',14};
GRIDARGS = {'-','color',[1 1 1]/2,'linewidth',0.1};
DOGRID = false;
DOAREA = true;
EXPORTNAME = 'fortim_D.png';
DOBIGTITLE = true;
% BIGTITLEARGS = {'interpreter','latex','fontsize',18};

SCATTERPTSIZE = 4;
f = figure(2);clf
set(f,'units','normalize','position',[0.05 0.05 0.8 0.9]);
axg = axgrid(5,2,0.1,0.025,0.1,0.9,0.1,0.9);

% Make ortho
h1 = axg([1 2 3],[1 1 1]);
image(Asi-min(Asi),Xsi-min(Xsi),rgb_grid);
hold on
plot(PAs-min(Asi),PXs-min(Xsi),LINEARGS{:});

set(h1,'ydir','normal');
axis equal
axis tight

set(gca,'fontsize',14,'ticklabelinterpreter','latex');
xlabel('Along-shore (m)',XYLABELARGS{:});
ylabel('Cross-shore (m)',XYLABELARGS{:});
title('SfM Derived Orthomosaic',TITLEARGS{:});

legend({'Extracted Profile'},LEGENDARGS{:})
grid on

% Make DEM
h2 = axg([1 2 3],[2 2 2]);
plot(PAs-min(Asi),PXs-min(Xsi),LINEARGS{:});
hold on
pcolor(Asi-min(Asi),Xsi-min(Xsi),Zg-0.75);shading flat
plot(PAs-min(Asi),PXs-min(Xsi),LINEARGS{:});

axis equal
axis tight

set(gca,'fontsize',14,'ticklabelinterpreter','latex');
xlabel('Along-shore (m)',XYLABELARGS{:});

demcmap([-3 2])
c = colorbar('location','eastoutside');
ylabel(c,'Elevation (m)','interpreter','latex','fontsize',16);
set(c,'ticklabelinterpreter','latex')

title('SfM Derived Bathymetry',TITLEARGS{:});
legend({'Extracted Profile'},LEGENDARGS{:})
grid on



% Make profile
di = 0:0.1:max(downlineoffline(:,2));
zi = roundgridfun(downlineoffline(:,2),xyz(profileinds,3)-0.75,di,@median);

h3 = axg(7:10);
hold off
if DOAREA
    area(di,ones(size(di))*-3,'FaceColor',[249, 245, 217]/255)
    hold on
    area(di,zi,'FaceColor',[181, 248, 255]/255)
else
    plot([0 60],[0 0],'k--');
end
hold on
axis tight
scatter(downlineoffline(:,2),xyz(profileinds,3)-0.75,SCATTERPTSIZE,double(rgb(profileinds,:))/255,'filled')
xlim([0 52]);

yticks(-3:0.5:1)
if DOGRID
    ZVALS = yticks;
    for i=1:numel(ZVALS)
        plot([0 di(end)],[ZVALS(i) ZVALS(i)],GRIDARGS{:})
    end
    
    XVALS = xticks;
    for i=1:numel(XVALS)
        plot([XVALS(i) XVALS(i)],[ZVALS(1) ZVALS(end)],GRIDARGS{:})
    end
end
ylim([-3 1])
grid on

h = text(10,-0.02,'WATERLINE','interpreter','latex','fontsize',14,'VerticalAlignment','bottom');

set(gca,'fontsize',14,'ticklabelinterpreter','latex');
xlabel('Distance Down Line (m)',XYLABELARGS{:});
ylabel('Elevation (m)',XYLABELARGS{:});
title('Extracted Profile Elevation',TITLEARGS{:});

if DOBIGTITLE
   bigtitle('UAS SfM Bathymetric Obstruction Detection',0.5,0.94,'interpreter','latex','fontsize',30) 
end
saveas(f,EXPORTNAME);

%% Make Plots
XYLABELARGS = {'interpreter','latex','fontsize',18};
LINEARGS = {'.-','color','r','linewidth',3,'markersize',20};
TITLEARGS = {'interpreter','latex','fontsize',20};
LEGENDARGS = {'interpreter','latex','fontsize',14};
GRIDARGS = {'--','color',[1 1 1]/2,'linewidth',0.1};
DOGRID = false;
DOAREA = true;
EXPORTNAME = 'fortimB_E.png';
DOBIGTITLE = true;
% BIGTITLEARGS = {'interpreter','latex','fontsize',18};

SCATTERPTSIZE = 4;
f = figure(1);clf
set(f,'units','normalize','position',[0.05 0.05 0.8 0.9]);
axg = axgrid(5,2,0.1,0.025,0.1,0.9,0.1,0.9);

% Make ortho
h1 = axg([1 2 3],[1 1 1]);
image(Asi-min(Asi),Xsi-min(Xsi),rgb_grid);
hold on
plot(PAs-min(Asi),PXs-min(Xsi),LINEARGS{:});

set(h1,'ydir','normal');
axis equal
axis tight

set(gca,'fontsize',14,'ticklabelinterpreter','latex');
xlabel('Along-shore (m)',XYLABELARGS{:});
ylabel('Cross-shore (m)',XYLABELARGS{:});
title('SfM Derived Orthomosaic',TITLEARGS{:});

legend({'Extracted Profile'},LEGENDARGS{:})
grid on

% Make DEM
h2 = axg([1 2 3],[2 2 2]);
plot(PAs-min(Asi),PXs-min(Xsi),LINEARGS{:});
hold on
pcolor(Asi-min(Asi),Xsi-min(Xsi),Zg-0.75);shading flat
plot(PAs-min(Asi),PXs-min(Xsi),LINEARGS{:});

axis equal
axis tight

set(gca,'fontsize',14,'ticklabelinterpreter','latex');
xlabel('Along-shore (m)',XYLABELARGS{:});

demcmap([-3 2])
c = colorbar('location','eastoutside');
ylabel(c,'Elevation (m)','interpreter','latex','fontsize',16);
set(c,'ticklabelinterpreter','latex')

title('SfM Derived Bathymetry',TITLEARGS{:});
legend({'Extracted Profile'},LEGENDARGS{:})
grid on



% Make profile
di = 0:0.1:max(downlineoffline(:,2));
zi = roundgridfun(downlineoffline(:,2),xyz(profileinds,3)-0.75,di,@median);

h3 = axg(7:10);
hold off
if DOAREA
    area(di,ones(size(di))*3,'FaceColor',[181, 248, 255]/255)
    hold on
    ylim([-3 1]+3)
    ZVALS = yticks;
    for i=1:numel(ZVALS)-3
        plot([0 di(end)],[ZVALS(i) ZVALS(i)],GRIDARGS{:})
    end
    area(di,zi+3,'FaceColor',[249, 245, 217]/255)
else
    plot([0 60],[0 0],'k--');
end
hold on
axis tight
scatter(downlineoffline(:,2),xyz(profileinds,3)-0.75+3,SCATTERPTSIZE,double(rgb(profileinds,:))/255,'filled')
xlim([0 52]);

yticks([-3:0.5:1]+3)

if DOGRID
    ZVALS = yticks;
    for i=1:numel(ZVALS)
        plot([0 di(end)],[ZVALS(i) ZVALS(i)],GRIDARGS{:})
    end
    
    XVALS = xticks;
    for i=1:numel(XVALS)
        plot([XVALS(i) XVALS(i)],[ZVALS(1) ZVALS(end)],GRIDARGS{:})
    end
end
ylim([-3 1]+3)

yticklabels(num2labelstr(-3:0.5:1,'$%+3.1f$'))

h = text(10,3-0.02,'WATERLINE','interpreter','latex','fontsize',14,'VerticalAlignment','bottom');

set(gca,'fontsize',14,'ticklabelinterpreter','latex');
xlabel('Distance Down Line (m)',XYLABELARGS{:});
ylabel('Elevation (m)',XYLABELARGS{:});
title('Extracted Profile Elevation',TITLEARGS{:});



if DOBIGTITLE
   bigtitle('UAS SfM Bathymetric Obstruction Detection',0.5,0.94,'interpreter','latex','fontsize',30) 
end
saveas(f,EXPORTNAME);