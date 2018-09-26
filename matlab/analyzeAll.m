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
DX = 2;
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
   try
        controldata = getControl(justname);
   catch
      controldata = []; 
   end
   tideval = importdata(tidevalname);
   %% Analyze Data
   % generate ortho
   fprintf('   calculating %-20s ... %s\n','Ortho',datestr(now));
   ortho = makeortho(dense,DX,justname,pstrajectory,sensor);

   % compute camera position errors
   fprintf('   calculating %-20s ... %s\n','Trajectory Error',datestr(now));
   camposerror = calccamposerror(pstrajectory,trajectory); 
   
   
   %% Make SfM Stats Plot
   makeSfMStatsPlot(sprintf('test%3i.png',i),justname,pstrajectory,trajectory,sensor,dense,sparse,tideval, ortho, camposerror);
   
   %% Make SfM2Control
   
   %% Make SfM2Lidar
   
   %% Make Dietrich
   
   %% Make Dietrich2Control
   
   %% Make Dietrich2lidar
   
   %% Make DietrichAnalysis
   
   %% Make 2D Correlation Error
   
   %% Output Data
   
end


