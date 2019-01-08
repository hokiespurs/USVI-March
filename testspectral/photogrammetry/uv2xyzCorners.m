function [x1,y1,z1,x2,y2,z2,x3,y3,z3,x4,y4,z4] = ...
    uv2xyzCorners(projectionfun,u,v)
%calculate corner points of a pixel
[x1,y1,z1] = projectionfun(u-0.5,v-0.5); % top left
[x2,y2,z2] = projectionfun(u+0.5,v-0.5); % top right
[x3,y3,z3] = projectionfun(u+0.5,v+0.5); % bottom right
[x4,y4,z4] = projectionfun(u-0.5,v+0.5); % bottom left
end