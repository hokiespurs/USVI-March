function ortho = makeortho(dense,dx,justname,pstrajectory,sensor)
xi = min(dense.As(:)):dx:max(dense.As(:));
yi = min(dense.Xs(:)):dx:max(dense.Xs(:));
[xg,yg]=meshgrid(xi,yi);

ortho.As = xi;
ortho.Xs = yi;

[pt,AsAz]=getUSVIXsAsCoords(justname);
[ortho.Eg,ortho.Ng]=calcXsAs(yg,xg,pt,AsAz,true);

R = uint8(roundgridfun(dense.As,dense.Xs,double(dense.R),xg,yg,@mean));
G = uint8(roundgridfun(dense.As,dense.Xs,double(dense.G),xg,yg,@mean));
B = uint8(roundgridfun(dense.As,dense.Xs,double(dense.B),xg,yg,@mean));

[ortho.Zg,npts] = roundgridfun(dense.As,dense.Xs,double(dense.Z),xg,yg,@mean);
R(npts==0)=255;
G(npts==0)=255;
B(npts==0)=255;

ortho.ptdensity = npts./(dx^2);
ortho.ptdensity(npts==0)=nan;

ortho.rgb = cat(3,R,G,B);

ortho.gray = repmat(rgb2gray(ortho.rgb),[1 1 3]);

ortho.ncameras = calcncameras(ortho,pstrajectory,sensor);

end