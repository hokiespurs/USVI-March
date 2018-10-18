function [pt,az,orthoname, controlnames, lidarbiasz]=getUSVIXsAsCoords(str)
% get the 0,0 point and azimuth for each day of the acquisition
DNAME = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\03_DELIVERABLES\01_GEOSPATIAL\';
if contains(str,{'0320','0321','0322','0323','0324','0325'}) %NW Buck
    pt = [327500, 1967500];
    az = 56.55;
    
    orthoname = [DNAME '06_SITEORTHOS/bigbuck.tif'];
    kayakname = [DNAME '01_CONTROL/20180323_BUCK_SONAR_APPLIEDDEPTH.csv'];
    tsname    = [DNAME '01_CONTROL/20180325_BUCK_TS.csv'];
    tsignore  = 19;
    lidarname = [DNAME '05_OLDCONTROL/2018_JABLTCX/allbuck.las'];
    lidarbiasz = 0.113;
    
elseif contains(str,{'0326'}) %SE Buck
    pt = [329450, 1967500];
    az = 253.34;
    
    orthoname = [DNAME '06_SITEORTHOS/all_buck_noxyzcontrol.tif'];
    kayakname = [];
    tsname    = [];
    tsignore  = 0;
    lidarname = [DNAME '05_OLDCONTROL/2018_JABLTCX/allbuck.las'];
    lidarbiasz = 0.113;

elseif contains(str,{'0328'}) % Whale Point 
    pt = [333050 1964350];
    az = 132;
    
    orthoname = [DNAME '06_SITEORTHOS/whale.tif'];
    kayakname = [DNAME '01_CONTROL/20180328_WHALEPOINT_SONAR_APPLIEDDEPTH.csv'];
    tsname    = [DNAME '01_CONTROL/20180328_WHALEPOINT_TS.csv'];
    tsignore  = 15;
    lidarname = [DNAME '05_OLDCONTROL/2014_NGSTOPOBATHYRIEGL/WhalePoint.las'];
    lidarbiasz = -0.462;
    
elseif contains(str,{'0329'}) % Isaac
    pt = [333540 1963500];
    az =  220;
    
    orthoname = [DNAME '06_SITEORTHOS/Isaac.tif'];
    kayakname = [];
    tsname    = [DNAME '01_CONTROL/20180329_ISAAC_TS.csv'];
    tsignore  = 14;
    lidarname = [DNAME '05_OLDCONTROL/2014_NGSTOPOBATHYRIEGL/Isaac.las'];
    lidarbiasz = -0.329;
    
elseif contains(str,{'0330','0331'}) % Rod Bay
    pt = [328900 1961650];
    az =  243;
    
    orthoname = [DNAME '06_SITEORTHOS/rod.tif'];
    kayakname = [DNAME '01_CONTROL/20180330_RODBAY_SONAR_APPLIEDDEPTH.csv'];
    tsname = [DNAME '01_CONTROL/20180331_RODBAY_TS.csv'];
    tsignore = 16;
    lidarname = [DNAME '05_OLDCONTROL/2014_NGSTOPOBATHYRIEGL/Rod.las'];
    lidarbiasz = -0.305;
    
elseif contains(str,{'0401'}) % JacksBay
    pt = [332729 1962825];
    az =  -66.31;
    
    orthoname = [DNAME '06_SITEORTHOS/jacks.tif'];
    kayakname = [];
    tsname = [DNAME '01_CONTROL/20180401_JACKS_TS.csv'];
    tsignore = 15;
    lidarname = [DNAME '05_OLDCONTROL/2014_NGSTOPOBATHYRIEGL/Jacks.las'];
    lidarbiasz = -0.298;
else
    pt = [0,0];
    az = 90;
    
    orthoname = [DNAME '06_SITEORTHOS/jacks.tif'];
    kayakname = [];
    tsname = [DNAME '01_CONTROL/20180401_JACKS_TS.csv'];
    tsignore = 15;
    lidarname = [DNAME '05_OLDCONTROL/2014_NGSTOPOBATHYRIEGL/Jacks.las'];
    lidarbiasz = 0;
    
end
controlnames.kayakname = kayakname;
controlnames.tsname = tsname;
controlnames.tsignore = tsignore;
controlnames.lidarname = lidarname;



end
