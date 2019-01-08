function base = getBase(lidarname,lidarbiasz,densepcname,DX)
%%
%base.x
%base.y
%base.zg
%base.rgb

%% Load lidar
fprintf('loading lidar...%s\n',datestr(now));
laspts = readLAS(lidarname);
% apply z
laspts.Z = laspts.Z-lidarbiasz;

%% Load ortho
fprintf('loading sfm pc...%s\n',datestr(now));
sfm = readLAS(densepcname);

%% Grid all to common grid
base.xi=min(sfm.E):DX:max(sfm.E);
base.yi=min(sfm.N):DX:max(sfm.N);
[base.x,base.y]=meshgrid(base.xi,base.yi);

fprintf('gridding lidar z...%s\n',datestr(now));
lidarz=roundgridfun(laspts.E,laspts.N,laspts.Z,base.x,base.y,@mean);

fprintf('gridding sfm pc R...%s\n',datestr(now));
[r,npts] = roundgridfun(sfm.E,sfm.N,double(sfm.R),base.x,base.y,@mean);
r = uint8(r);
r(npts==0)=255;

fprintf('gridding sfm pc G...%s\n',datestr(now));
g = uint8(roundgridfun(sfm.E,sfm.N,double(sfm.G),base.x,base.y,@mean));
g(npts==0)=255;

fprintf('gridding sfm pc B...%s\n',datestr(now));
b = uint8(roundgridfun(sfm.E,sfm.N,double(sfm.B),base.x,base.y,@mean));
b(npts==0)=255;

fprintf('gridding sfm pc Zg...%s\n',datestr(now));
sfmzg = roundgridfun(sfm.E,sfm.N,sfm.Z,base.x,base.y,@mean);

base.z = sfmzg;
base.dz = sfmzg-lidarz;

base.rgb=cat(3,r,g,b);

end