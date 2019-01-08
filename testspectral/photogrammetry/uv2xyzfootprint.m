function [a,b,az,el,h]=uv2xyzfootprint(x1,y1,z1,x2,y2,z2,x3,y3,z3,x4,y4,z4)
% convert 4 corners to isosceles trapezoid parameters
% a = short base
% b = long base
% h = height
% az = azimuth
% el = elevation
% NEED TO CHECK HOW ROBUST THE A-B SIDE DETECTION IS

d12 = sqrt((x1-x2).^2+(y1-y2).^2+(z1-z2).^2); % top
d23 = sqrt((x3-x2).^2+(y3-y2).^2+(z3-z2).^2); % right
d34 = sqrt((x3-x4).^2+(y3-y4).^2+(z3-z4).^2); % bottom
d41 = sqrt((x4-x1).^2+(y4-y1).^2+(z4-z1).^2); % left

[a,inda] = min(cat(3,d12,d23,d34,d41),[],3);

%preallocate
b = nan(size(a));
p1x = nan(size(a));
p1y = nan(size(a));
p1z = nan(size(a));
p2x = nan(size(a));
p2y = nan(size(a));
p2z = nan(size(a));

% upside down cam or cam looking up at surface
i = inda==1;
b(i) = d34(i);
p1x(i) = (x1(i)+x2(i))/2;
p1y(i) = (y1(i)+y2(i))/2;
p1z(i) = (z1(i)+z2(i))/2;
p2x(i) = (x3(i)+x4(i))/2;
p2y(i) = (y3(i)+y4(i))/2;
p2z(i) = (z3(i)+z4(i))/2;

% rotated
i = inda==2;
b(i) = d41(i);
p1x(i) = (x3(i)+x2(i))/2;
p1y(i) = (y3(i)+y2(i))/2;
p1z(i) = (z3(i)+z2(i))/2;
p2x(i) = (x1(i)+x4(i))/2;
p2y(i) = (y1(i)+y4(i))/2;
p2z(i) = (z1(i)+z4(i))/2;

% right side up and looking down at surface
i = inda==3;
b(i) = d12(i);
p2x(i) = (x1(i)+x2(i))/2;
p2y(i) = (y1(i)+y2(i))/2;
p2z(i) = (z1(i)+z2(i))/2;
p1x(i) = (x3(i)+x4(i))/2;
p1y(i) = (y3(i)+y4(i))/2;
p1z(i) = (z3(i)+z4(i))/2;

% rotated
i = inda==4;
b(i) = d23(i);
p2x(i) = (x3(i)+x2(i))/2;
p2y(i) = (y3(i)+y2(i))/2;
p2z(i) = (z3(i)+z2(i))/2;
p1x(i) = (x1(i)+x4(i))/2;
p1y(i) = (y1(i)+y4(i))/2;
p1z(i) = (z1(i)+z4(i))/2;

[az,el,h]=cart2sph(p2x-p1x,p2y-p1y,p2z-p1z);
% convert math angle to azimuth angle from north
az = -az + pi/2;
end