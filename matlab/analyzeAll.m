% function analyzeAll()
% ANALYZE POINTCLOUD
%
% - camera X,Y,Z error
% - land gcp X,Y,Z error
% - water gcp X,Y,Z error
%   - separated into (used/unused)
% 
% - pointcloud density
% - pointcloud ncameras viewing each point
% - pointcloud classification (in AOI, out AOI, etc)
% 
% - pointcloud vs control
% - pointcloud w/ deitrich vs control
%  - z bias
%  - z std
%  - 2D xcorr RMSE
DX = 4;
DXCOMPARE = 2;

SEARCHDIR = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\06_PROCIMAGES\*\06_QUICKPROC\';
[fnames,~] = dirname('*.psx',5,SEARCHDIR);
[dnames, justname, ext] = filepartsstruct(fnames);
[D,F2,~]=filepartsstruct(dnames);
[D,~,~]=filepartsstruct(D);
[~,F1,~]=filepartsstruct(D);

for i=1:numel(dnames)
   dname = dnames{i};
   justname = [F1{i} F2{i}];
   fprintf('Processing %-40s...%s\n',justname,datestr(now));
   %% Make Analysis Directory
   analysisdir = [dname '/analysis'];
   if ~exist(analysisdir,'dir')
      mkdir(analysisdir); 
   end
   %% Data Filenames 
   trajectoryname   = [dname '/../../02_TRAJECTORY/imageposUTM.csv'];
   pstrajectoryname = [dname '/trajectory.txt'];
   cameracalibname  = [dname '/sensorcalib.xml'];

   densepcname      = [dname '/dense.las'];
   sparsepcname     = [dname '/sparse.las'];
   
   tidevalname      = [dname '/../../07_TIDE/tideval.txt'];
   %% Load Data
   [pt,AsAz]=getUSVIXsAsCoords(justname);
   
   fprintf('   loading %-20s ... %s\n','photoscan cameras',datestr(now));
   pstrajectory = readCameras(pstrajectoryname);
   [pstrajectory.Xs, pstrajectory.As] = calcXsAs(pstrajectory.E,pstrajectory.N,pt,AsAz);
   
   fprintf('   loading %-20s ... %s\n','trajectory',datestr(now));
   trajectoryAll = readPreTrajectory(trajectoryname);
   [trajectoryAll.Xs, trajectoryAll.As] = calcXsAs(trajectoryAll.E,trajectoryAll.N,pt,AsAz);
   
   trajectory = trimTrajectory(trajectoryAll,pstrajectory);
   [trajectory.Xs, trajectory.As] = calcXsAs(trajectory.E,trajectory.N,pt,AsAz);

   fprintf('   loading %-20s ... %s\n','camera calibration',datestr(now));
   sensor = readSensor(cameracalibname);
   
   fprintf('   loading %-20s ... %s\n','dense pointcloud',datestr(now));
   dense = readLAS(densepcname);
   [dense.Xs, dense.As] = calcXsAs(dense.E,dense.N,pt,AsAz);

   fprintf('   loading %-20s ... %s\n','sparse pointcloud',datestr(now));
   sparse = readLAS(sparsepcname);
   [sparse.Xs, sparse.As] = calcXsAs(sparse.E,sparse.N,pt,AsAz);
   %% Load Comparison Data based on date
   % fprintf('   loading %-20s ... %s\n','Ortho (this is slow)',datestr(now));
   % ortho = getOrtho(justname);
   fprintf('   loading %-20s ... %s\n','Control Data',datestr(now));
   [controldata, lidarcontrol] = getControl(justname);
   
   % get tide
   tideval = importdata(tidevalname);
   %% Analyze Data
   % generate ortho
   fprintf('   calculating %-20s ... %s\n','Ortho',datestr(now));
   ortho = makeortho(dense,DX,justname,pstrajectory,sensor);

   % compute camera position errors
   fprintf('   calculating %-20s ... %s\n','Trajectory Error',datestr(now));
   camposerror = calccamposerror(pstrajectory,trajectory); 

   % compare raw SfM control/lidar
   fprintf('   calculating %-20s ... %s\n','Control Comparison',datestr(now));
   sfmcompare = calcsfm2control(sparse,dense,controldata,lidarcontrol,DXCOMPARE, justname);
   
   % compute Dietrich and compare dietrich
   fprintf('   calculating %-20s ... %s\n','Dietrich',datestr(now));
   dietrich = calcdietrich(tideval, pstrajectory, sensor, sfmcompare);
   
   %% Make SfM Stats Plot
   try
       f1 = makeSfMStatsPlot(sprintf('test%3i.png',i),justname,pstrajectory,trajectory,sensor,dense,sparse,tideval, ortho, camposerror, trajectoryAll);
   catch
       fprintf('failed to make F1\n');
   end
   %% Make SfM2Control
   try
       f2 = makeSfM2controlPlot(ortho,sfmcompare, justname);
   catch
       fprintf('failed to make F2\n');
   end
   
   %% Make SfM2Lidar
   try
       f3 = makeSfM2lidarPlot(ortho,sfmcompare, justname);
   catch
       fprintf('failed to make F3\n');
   end
   
   %% Make Dietrich
   try
       f4 = plotDietrich(ortho,dietrich,tideval,sfmcompare, justname);
   catch
       fprintf('failed to make F4\n');
   end
   
   %% Make Dietrich2Control
   try
       f5 = plotDietrich2control(ortho,dietrich, sfmcompare, justname);
   catch
       fprintf('failed to make F5\n');
   end
   %% Make Dietrich2lidar
   try
       f6 = plotDietrich2lidar(ortho,dietrich,tideval,sfmcompare, justname);
   catch
       fprintf('failed to make F6\n');
   end
   %% Make DietrichAnalysis
   try
       f7 = makeDietrichAnalysis(ortho,dietrich,tideval,sfmcompare, justname);
   catch
       fprintf('failed to make F7\n');
   end
   %% Make 2D Correlation Error
   
   %% Output Data
   
   %% Save Figures
   try
       saveas(f1,['img/' justname '_A.png']);
       saveas(f1,['img/fig/' justname '_A.fig']);
       saveas(f2,['img/' justname '_B.png']);
       saveas(f2,['img/fig/' justname '_B.fig']);
       saveas(f3,['img/' justname '_C.png']);
       saveas(f3,['img/fig/' justname '_C.fig']);
       saveas(f4,['img/' justname '_D.png']);
       saveas(f4,['img/fig/' justname '_D.fig']);
       saveas(f5,['img/' justname '_E.png']);
       saveas(f5,['img/fig/' justname '_E.fig']);
       saveas(f6,['img/' justname '_F.png']);
       saveas(f6,['img/fig/' justname '_F.fig']);
       saveas(f7,['img/' justname '_G.png']);
       saveas(f7,['img/fig/' justname '_G.fig']);
   catch
       fprintf('didnt want to save %s\n',justname);
   end
end


