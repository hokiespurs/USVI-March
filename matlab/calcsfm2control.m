function sfmcompare = calcsfm2control(sparse,dense,controldata,lidarcontrol,dx, justname)

Xsi = min(dense.Xs(:)):dx:max(dense.Xs(:));
Asi = min(dense.As(:)):dx:max(dense.As(:));
[sfmcompare.AsGrid,sfmcompare.XsGrid]=meshgrid(Asi,Xsi);

[pt,AsAz]=getUSVIXsAsCoords(justname);
[sfmcompare.Eg,sfmcompare.Ng]=calcXsAs(sfmcompare.XsGrid,sfmcompare.AsGrid,pt,AsAz,true);

% grid pointcloud
sfmcompare.dense.Zg = roundgridfun(dense.As,dense.Xs,dense.Z,sfmcompare.AsGrid,sfmcompare.XsGrid,@mean);
sfmcompare.sparse.Zg = roundgridfun(sparse.As,sparse.Xs,sparse.Z,sfmcompare.AsGrid,sfmcompare.XsGrid,@mean);

% grid control data
sfmcompare.control.Zg = roundgridfun(controldata.As,controldata.Xs,controldata.Z,sfmcompare.AsGrid,sfmcompare.XsGrid,@mean);
sfmcompare.lidar.Zg = roundgridfun(lidarcontrol.As,lidarcontrol.Xs,lidarcontrol.Z,sfmcompare.AsGrid,sfmcompare.XsGrid,@mean);

% change detection
sfmcompare.dense.dControl = sfmcompare.dense.Zg - sfmcompare.control.Zg;
sfmcompare.dense.dLidar = sfmcompare.dense.Zg - sfmcompare.lidar.Zg;
sfmcompare.sparse.dControl = sfmcompare.sparse.Zg - sfmcompare.control.Zg;
sfmcompare.sparse.dLidar = sfmcompare.sparse.Zg - sfmcompare.lidar.Zg;

end