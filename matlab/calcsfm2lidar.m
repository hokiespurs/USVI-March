function sfm2lidar = calcsfm2lidar(lidarpc, controldata)
Xsi = min(lidarpc.Xs(:)):dx:max(lidarpc.Xs(:));
Asi = min(lidarpc.As(:)):dx:max(lidarpc.As(:));

% grid pointcloud
[sfm2lidar.AsGrid,sfm2lidar.XsGrid]=meshgrid(Asi,Xsi);

sfm2lidar.Zg = roundgridfun(lidarpc.As,lidarpc.Xs,lidarpc.Z,sfm2lidar.AsGrid,sfm2lidar.XsGrid,@mean);
sfm2lidar.Cg = roundgridfun(controldata.As,controldata.Xs,controldata.Z,sfm2lidar.AsGrid,sfm2lidar.XsGrid,@mean);

% change detection
sfm2lidar.dZg = Zg-Cg;

end