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