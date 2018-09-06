MAKECONTROLMAPS = false;
% FOLDER LOCATIONS
DNAME = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\03_DELIVERABLES\01_GEOSPATIAL\';
SAVEDIR = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\03_DELIVERABLES\01_GEOSPATIAL\06_SITEORTHOS\';
% BUCK
ORTHO_BUCK  = [DNAME '06_SITEORTHOS/bigbuck.tif'];
KAYAK_BUCK  = [DNAME '01_CONTROL/20180323_BUCK_SONAR_APPLIEDDEPTH.csv'];
TS_BUCK     = [DNAME '01_CONTROL/20180325_BUCK_TS.csv'];
RIEGL_BUCK  = [DNAME '05_OLDCONTROL/2014_NGSTOPOBATHYRIEGL/Buck.las'];
LADS_BUCK   = [DNAME '05_OLDCONTROL/2011_LADSMK2/Job427951_2011_usvi_bathymetry.las'];
EAARLB_BUCK = [DNAME '05_OLDCONTROL/2014_EAARLB/Job427949_2014_eaarlb_usvi.las'];
JABLTCX_BUCK = [DNAME '05_OLDCONTROL/2018_JABLTCX/allbuck.las'];

% WHALE
ORTHO_WHALE  = [DNAME '06_SITEORTHOS/whale.tif'];
KAYAK_WHALE  = [DNAME '01_CONTROL/20180328_WHALEPOINT_SONAR_APPLIEDDEPTH.csv'];
TS_WHALE     = [DNAME '01_CONTROL/20180328_WHALEPOINT_TS.csv'];
RIEGL_WHALE  = [DNAME '05_OLDCONTROL/2014_NGSTOPOBATHYRIEGL/WhalePoint.las'];

% ISAAC
ORTHO_ISAAC  = [DNAME '06_SITEORTHOS/Isaac.tif'];
TS_ISAAC     = [DNAME '01_CONTROL/20180329_ISAAC_TS.csv'];
RIEGL_ISAAC  = [DNAME '05_OLDCONTROL/2014_NGSTOPOBATHYRIEGL/Isaac.las'];

% ROD
ORTHO_ROD  = [DNAME '06_SITEORTHOS/rod.tif'];
KAYAK_ROD  = [DNAME '01_CONTROL/20180330_RODBAY_SONAR_APPLIEDDEPTH.csv'];
TS_ROD     = [DNAME '01_CONTROL/20180331_RODBAY_TS.csv'];
RIEGL_ROD  = [DNAME '05_OLDCONTROL/2014_NGSTOPOBATHYRIEGL/Rod.las'];

% JACKS
ORTHO_JACKS  = [DNAME '06_SITEORTHOS/jacks.tif'];
TS_JACKS     = [DNAME '01_CONTROL/20180401_JACKS_TS.csv'];
RIEGL_JACKS  = [DNAME '05_OLDCONTROL/2014_NGSTOPOBATHYRIEGL/Jacks.las'];

if MAKECONTROLMAPS
    %% MAKE BUCK CONTROL MAP
    % CONSTANTS
    FIGNUM = 1;
    CAX = [-45 -41];
    XAX = [0 600];
    YAX = [0 500];
    OFFX = 450;
    OFFY = 725;
    TITLESTR = 'Buck Island, USVI, March 25, 2018';
    TSLABELIND = 1:15;
    TSIGNORE = 1:4;
    % Make Map
    f = makeControlMap(ORTHO_BUCK,KAYAK_BUCK,TS_BUCK,TSIGNORE,FIGNUM,CAX,XAX,YAX,OFFX,OFFY,TITLESTR,TSLABELIND);
    % saveas(f,[SAVEDIR '/buck.png'])
    
    %% MAKE WHALE CONTROL MAP
    % CONSTANTS
    FIGNUM = 2;
    CAX = [-44 -41];
    XAX = [0 300];
    YAX = [0 300];
    OFFX = 50;
    OFFY = 0;
    TITLESTR = 'Whale Point, USVI, March 28, 2018';
    TSLABELIND = 1:11;
    TSIGNORE = 1:4;
    % Make Map
    f = makeControlMap(ORTHO_WHALE,KAYAK_WHALE,TS_WHALE,TSIGNORE,FIGNUM,CAX,XAX,YAX,OFFX,OFFY,TITLESTR,TSLABELIND);
    % saveas(f,[SAVEDIR '/whale.png'])
    
    %% MAKE ISAAC CONTROL MAP
    % CONSTANTS
    FIGNUM = 3;
    CAX = [-44 -41];
    XAX = [0 500];
    YAX = [0 400];
    OFFX = 300;
    OFFY = 350;
    TITLESTR = 'Isaac Bay, USVI, March 29, 2018';
    TSLABELIND = 1:10;
    TSIGNORE = 1:4;
    
    % Make Map
    f = makeControlMap(ORTHO_ISAAC,[],TS_ISAAC,TSIGNORE,FIGNUM,CAX,XAX,YAX,OFFX,OFFY,TITLESTR,TSLABELIND);
    % saveas(f,[SAVEDIR '/isaac.png'])
    
    %% MAKE ROD CONTROL MAP
    % CONSTANTS
    FIGNUM = 4;
    CAX = [-44 -41];
    XAX = [0 300];
    YAX = [0 300];
    OFFX = 600;
    OFFY = 450;
    TITLESTR = 'Rod Bay, USVI, March 30/31, 2018';
    TSLABELIND = 1:12;
    TSIGNORE = 1:4;
    % Make Map
    f = makeControlMap(ORTHO_ROD,KAYAK_ROD,TS_ROD,TSIGNORE,FIGNUM,CAX,XAX,YAX,OFFX,OFFY,TITLESTR,TSLABELIND);
    % saveas(f,[SAVEDIR '/rod.png'])
    
    %% MAKE JACKS CONTROL MAP
    % CONSTANTS
    FIGNUM = 5;
    CAX = [-44 -41];
    XAX = [0 250];
    YAX = [0 250];
    OFFX = 250;
    OFFY = 75;
    TITLESTR = 'Jacks Bay, USVI, April 1, 2018';
    TSLABELIND = 1:11;
    TSIGNORE = 1:4;
    % Make Map
    f = makeControlMap(ORTHO_JACKS,[],TS_JACKS,TSIGNORE,FIGNUM,CAX,XAX,YAX,OFFX,OFFY,TITLESTR,TSLABELIND);
    % saveas(f,[SAVEDIR '/jacks.png']);
end
%% BUCK COMPARE LADS Lidar vs Kayak/TS
% CONSTANTS
CAX = [-45 -41];
XAX = [0 600];
YAX = [0 500];
OFFX = 450;
OFFY = 725;
TSLABELIND = 1:15;
TSIGNORE = [1:4 18 19];
% make Map
FIGNUM = 100;
TITLESTR = 'LADS';
[fLADS,statsBuckLADS] = comparecontrol2lidar(LADS_BUCK,ORTHO_BUCK,KAYAK_BUCK,TS_BUCK,TSIGNORE,FIGNUM,CAX,XAX,YAX,OFFX,OFFY,TITLESTR,TSLABELIND);
TITLESTR = 'EAARLB';
FIGNUM = 101;
[fEAARL,statsBuckEAARL] = comparecontrol2lidar(EAARLB_BUCK,ORTHO_BUCK,KAYAK_BUCK,TS_BUCK,TSIGNORE,FIGNUM,CAX,XAX,YAX,OFFX,OFFY,TITLESTR,TSLABELIND);
TITLESTR = 'RIEGL';
FIGNUM = 102;
[fRiegl,statsBuckRiegl] = comparecontrol2lidar(RIEGL_BUCK,ORTHO_BUCK,KAYAK_BUCK,TS_BUCK,TSIGNORE,FIGNUM,CAX,XAX,YAX,OFFX,OFFY,TITLESTR,TSLABELIND);
TITLESTR = 'JABLTCX';
FIGNUM = 103;
[fJABLTCX,statsBuckJABLTCX] = comparecontrol2lidar(JABLTCX_BUCK,ORTHO_BUCK,KAYAK_BUCK,TS_BUCK,TSIGNORE,FIGNUM,CAX,XAX,YAX,OFFX,OFFY,TITLESTR,TSLABELIND);
%% Compare Buck Histograms
f = figure(50);clf
histogram(statsBuckJABLTCX.dz,[-1:0.01:1],'normalization','probability')
hold on
histogram(statsBuckEAARL.dz,[-1:0.01:1],'normalization','probability')

xlabel('Elevation Difference (m)','interpreter','latex','fontsize',LABELFONTSIZE)
ylabel('Probability','interpreter','latex','fontsize',LABELFONTSIZE)
title('Total Station Accuracy Comparison','fontsize',18,'interpreter','latex')

set(gca,'TickLabelInterpreter','latex','fontsize',14)
grid on

text(-0.8,0.05,'2014 EAARLB lidar','interpreter','latex','fontsize',16,'color','r');
text(-0.8,0.0475,sprintf('$\\mu = %.2fm$',nanmean(statsBuckEAARL.dz(:))),...
    'interpreter','latex','fontsize',18,'color','r');
text(-0.8,0.045,sprintf('$\\sigma = %.2fm$',nanstd(statsBuckEAARL.dz(:))),...
    'interpreter','latex','fontsize',18,'color','r');
text(-0.8,0.0425,sprintf('$N = %.0f$',numel(statsBuckEAARL.dz(:))),...
    'interpreter','latex','fontsize',18,'color','r');

text(0.4,0.05,'2018 JABLTCX lidar','interpreter','latex','fontsize',16,'color','b');
text(0.4,0.0475,sprintf('$\\mu = %.2fm$',nanmean(statsBuckJABLTCX.dz(:))),...
    'interpreter','latex','fontsize',18,'color','b');
text(0.4,0.045,sprintf('$\\sigma = %.2fm$',nanstd(statsBuckJABLTCX.dz(:))),...
    'interpreter','latex','fontsize',18,'color','b');
text(0.4,0.0425,sprintf('$N = %.0f$',numel(statsBuckJABLTCX.dz(:))),...
    'interpreter','latex','fontsize',18,'color','b');

%% WHALE
% CONSTANTS
FIGNUM = 11;
CAX = [-44 -41];
XAX = [0 300];
YAX = [0 300];
OFFX = 50;
OFFY = 0;
TITLESTR = 'Whale Point, USVI, March 28, 2018';
TSLABELIND = 1:11;
TSIGNORE = 1:4;
% Make Map
TITLESTR = 'RIEGL';
[fRiegl1,statsBuckRiegl1] = comparecontrol2lidar(RIEGL_WHALE,ORTHO_WHALE,KAYAK_WHALE,TS_WHALE,TSIGNORE,FIGNUM,CAX,XAX,YAX,OFFX,OFFY,TITLESTR,TSLABELIND);

%% ISAAC
% CONSTANTS
FIGNUM = 12;
CAX = [-44 -41];
XAX = [0 500];
YAX = [0 400];
OFFX = 300;
OFFY = 350;
TITLESTR = 'Isaac Bay, USVI, March 29, 2018';
TSLABELIND = 1:10;
TSIGNORE = 1:4;

% Make Map
TITLESTR = 'RIEGL';
[fRiegl2,statsBuckRiegl2] = comparecontrol2lidar(RIEGL_ISAAC,ORTHO_ISAAC,[],TS_ISAAC,TSIGNORE,FIGNUM,CAX,XAX,YAX,OFFX,OFFY,TITLESTR,TSLABELIND);

%% ROD
FIGNUM = 13;
CAX = [-44 -41];
XAX = [0 300];
YAX = [0 300];
OFFX = 600;
OFFY = 450;
TITLESTR = 'Rod Bay, USVI, March 30/31, 2018';
TSLABELIND = 1:12;
TSIGNORE = 1:4;
% Make Map
TITLESTR = 'RIEGL';
[fRiegl3,statsBuckRiegl3] = comparecontrol2lidar(RIEGL_ROD,ORTHO_ROD,KAYAK_ROD,TS_ROD,TSIGNORE,FIGNUM,CAX,XAX,YAX,OFFX,OFFY,TITLESTR,TSLABELIND);

%% JACKS
FIGNUM = 14;
CAX = [-44 -41];
XAX = [0 250];
YAX = [0 250];
OFFX = 250;
OFFY = 75;
TITLESTR = 'Jacks Bay, USVI, April 1, 2018';
TSLABELIND = 1:11;
TSIGNORE = 1:4;
% Make Map
TITLESTR = 'RIEGL';
[fRiegl4,statsBuckRiegl4] = comparecontrol2lidar(RIEGL_JACKS,ORTHO_JACKS,[],TS_JACKS,TSIGNORE,FIGNUM,CAX,XAX,YAX,OFFX,OFFY,TITLESTR,TSLABELIND);
