% rinexRover = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\01_RAWDATA\20180325_BUCK\02_UAS\0939_S900_30MM_75OL_09MMGSD_A\05_CARRIERPHASEGNSS\0005-00000.obs';
% rinexBase  = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\01_RAWDATA\20180325_BUCK\01_CONTROL\04_TRIMBLE_STATIC\81050841.18o';
% navfile   = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\01_RAWDATA\20180325_BUCK\01_CONTROL\04_TRIMBLE_STATIC\81050841.18n';
% baseLatLonHt = [17.7899283194444 -64.6249347388889 -37.249]; %NAD83 2011
% outdir     = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\01_RAWDATA\20180325_BUCK\02_UAS\0939_S900_30MM_75OL_09MMGSD_A\05_CARRIERPHASEGNSS\ppk_auto';
% 
% gpsephmeris     = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\01_CONTROLPROC\PRECISE_EPHEMERIS\igs19940.sp3';
% glonassephmeris = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\01_CONTROLPROC\PRECISE_EPHEMERIS\igl19940.sp3';
% clkfile   = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\01_CONTROLPROC\PRECISE_EPHEMERIS\igs19940.clk';
% inpfiles = {gpsephmeris, glonassephmeris, clkfile}; 
% 
% rtklibbin  = 'C:\Users\slocumr\Downloads\RTKLIB_bin-master\bin\rnx2rtkp.exe';
% baseDatum = 'NAD83(2011) - Ellipsoid Height';
% 
% rtklibppk(rtklibbin,rinexRover,rinexBase,navfile,baseLatLonHt,baseDatum, outdir,inpfiles)
% 
% 
%% Find all rinex files that need to be processed
DNAME = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\01_RAWDATA\20180325_BUCK\02_UAS';
fnames = dirname([DNAME '/*/05_CARRIERPHASEGNSS/*.obs']);

rtklibbin  = 'C:\Users\slocumr\Downloads\RTKLIB_bin-master\bin\rnx2rtkp.exe';
baseDatum = 'NAD83(2011) - Ellipsoid Height - from OPUS';

rinexBase  = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\01_RAWDATA\20180325_BUCK\01_CONTROL\04_TRIMBLE_STATIC\81050841.18o';
navfile   = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\01_RAWDATA\20180325_BUCK\01_CONTROL\04_TRIMBLE_STATIC\81050841.18n';
baseLatLonHt = [17.7899283194444 -64.6249347388889 -37.249]; %NAD83 2011
gpsephmeris     = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\01_CONTROLPROC\PRECISE_EPHEMERIS\igs19940.sp3';
glonassephmeris = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\01_CONTROLPROC\PRECISE_EPHEMERIS\igl19940.sp3';
clkfile   = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\01_CONTROLPROC\PRECISE_EPHEMERIS\igs19940.clk';
inpfiles = {gpsephmeris, glonassephmeris, clkfile}; 

for i=1:3
   rinexRover = fnames{i};
   dname = fileparts(fnames{i});
   outdir = [dname '/ppk'];
   mkdir(outdir);
   rtklibppk(rtklibbin,rinexRover,rinexBase,navfile,baseLatLonHt,baseDatum, outdir,inpfiles)
end

%
rinexBase  = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\01_RAWDATA\20180325_BUCK\01_CONTROL\04_TRIMBLE_STATIC\81050842.18o';
navfile   = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\01_RAWDATA\20180325_BUCK\01_CONTROL\04_TRIMBLE_STATIC\81050842.18n';
baseLatLonHt = [17.7899283194444 -64.6249347388889 -37.249]; %NAD83 2011
gpsephmeris     = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\01_CONTROLPROC\PRECISE_EPHEMERIS\igs19940.sp3';
glonassephmeris = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\01_CONTROLPROC\PRECISE_EPHEMERIS\igl19940.sp3';
clkfile   = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\01_CONTROLPROC\PRECISE_EPHEMERIS\igs19940.clk';
inpfiles = {gpsephmeris, glonassephmeris, clkfile}; 

for i=4:7
   rinexRover = fnames{i};
   dname = fileparts(fnames{i});
   outdir = [dname '/ppk'];
   mkdir(outdir);
   rtklibppk(rtklibbin,rinexRover,rinexBase,navfile,baseLatLonHt,baseDatum, outdir,inpfiles)
end
%%
DNAME = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\01_RAWDATA\20180328_WHALEPOINT\02_UAS';
fnames = dirname([DNAME '/*/05_CARRIERPHASEGNSS/*.obs']);

%%
rtklibbin  = 'C:\Users\slocumr\Downloads\RTKLIB_bin-master\bin\rnx2rtkp.exe';
baseDatum = 'NAD83(2011) - Ellipsoid Height - from OPUS';

rinexBase  = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\01_RAWDATA\20180328_WHALEPOINT\01_CONTROL\04_TRIMBLE_STATIC\81050870.18o';
navfile   = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\01_RAWDATA\20180328_WHALEPOINT\01_CONTROL\04_TRIMBLE_STATIC\81050870.18n';
baseLatLonHt = [17.7600938805556 -64.5743606194444 -33.203]; %NAD83 2011
gpsephmeris     = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\01_CONTROLPROC\PRECISE_EPHEMERIS\igs19943.sp3';
glonassephmeris = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\01_CONTROLPROC\PRECISE_EPHEMERIS\igl19943.sp3';
clkfile   = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\01_CONTROLPROC\PRECISE_EPHEMERIS\igs19943.clk';
inpfiles = {gpsephmeris, glonassephmeris, clkfile}; 

for i=1:9
   rinexRover = fnames{i};
   dname = fileparts(fnames{i});
   outdir = [dname '/ppk'];
   mkdir(outdir);
   rtklibppk(rtklibbin,rinexRover,rinexBase,navfile,baseLatLonHt,baseDatum, outdir,inpfiles)
end

rinexBase  = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\01_RAWDATA\20180328_WHALEPOINT\01_CONTROL\04_TRIMBLE_STATIC\81050871.18o';
navfile   = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\01_RAWDATA\20180328_WHALEPOINT\01_CONTROL\04_TRIMBLE_STATIC\81050871.18n';
baseLatLonHt = [17.7585202388889 -64.5724706388889 -39.900]; %NAD83 2011
gpsephmeris     = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\01_CONTROLPROC\PRECISE_EPHEMERIS\igs19943.sp3';
glonassephmeris = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\01_CONTROLPROC\PRECISE_EPHEMERIS\igl19943.sp3';
clkfile   = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\01_CONTROLPROC\PRECISE_EPHEMERIS\igs19943.clk';
inpfiles = {gpsephmeris, glonassephmeris, clkfile}; 
for i=10:11
   rinexRover = fnames{i};
   dname = fileparts(fnames{i});
   outdir = [dname '/ppk'];
   mkdir(outdir);
   rtklibppk(rtklibbin,rinexRover,rinexBase,navfile,baseLatLonHt,baseDatum, outdir,inpfiles)
end
