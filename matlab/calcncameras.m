function ncamsperpoint = calcncameras(ortho,pstrajectory,sensor)
% ncamsperpoint = zeros(size(ortho.Eg));
% return;

xyz = [ortho.Eg(:) ortho.Ng(:) ortho.Zg(:)];

npoints = size(xyz,1);
ncameras = numel(pstrajectory.E);
ncamsperpoint = zeros(size(ortho.Eg));

for ipoint=1:npoints
    if isnan(ortho.Zg(ipoint))
        ncamsperpoint(ipoint) = nan;
    else
        for jcamera = 1:ncameras
            iK = sensor.K;
            iR = pstrajectory.R{jcamera};
            iT = [pstrajectory.E(jcamera);pstrajectory.N(jcamera);pstrajectory.Z(jcamera)];
            pixx = sensor.pixx;
            pixy = sensor.pixy;
            
            [~,~,~,isinframe]=isXYZinFrame(iK,iR,iT,xyz(ipoint,1),xyz(ipoint,2),xyz(ipoint,3),pixx,pixy);
            if isinframe %if camera sees the point
                ncamsperpoint(ipoint)=ncamsperpoint(ipoint)+1;
            end
        end
    end
end


end

function [u,v,s,isinframe] = isXYZinFrame(K,R,T,xw,yw,zw,pixx,pixy)
% calculate if a point is in a camera fov
[u,v,s] = xyz2uv(K,R,T,xw,yw,zw);

inx = u<pixx & u>=1;
iny = v<pixy & v>=0;
isinfront = s>0;

isinframe = inx & iny & isinfront;


end

function [u,v,s] = xyz2uv(K,Rw2c,Tw,xw,yw,zw)
% compute uv pixel coordinates assuming pinhole camera model using:
%
%      s * [u;v;1] = K*R*[xw-T(1);yw-T(2);zw-T(3)]
%
%  Where T represents the XYZ world coordinate of the camera
xw = xw(:)';
yw = yw(:)';
zw = zw(:)';

UVS = K*Rw2c*[xw-Tw(1);yw-Tw(2);zw-Tw(3)];
if numel(xw)==1
    u = UVS(1)./UVS(3);
    v = UVS(2)./UVS(3);
    s = UVS(3);
else
    u = UVS(1,:)./UVS(3,:);
    v = UVS(2,:)./UVS(3,:);
    s = UVS(3,:);
end
end