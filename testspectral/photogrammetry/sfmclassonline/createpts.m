% Create an image pair with known rotation and translation between the
% views, and corresponding image points.

clear all
close all
 
L = 300;        % size of image in pixels
I1 = zeros(L,L);
 
% Define f, u0, v0
f = L;
u0 = L/2;
v0 = L/2;
 
%  Create the matrix of intrinsic camera parameters
K = [ f  0  u0;
      0  f  v0;
      0  0   1];
  
DEG_TO_RAD = pi/180;
 
% Create some points on the face of a cube
P_M = [
    0   0   0   0   0   0   0   0   0   1   2   1   2   1   2;
    2   1   0   2   1   0   2   1   0   0   0   0   0   0   0;
    0   0   0   -1  -1  -1  -2  -2  -2  0   0   -1  -1  -2  -2;
    1   1   1   1   1   1   1   1   1   1   1   1   1   1   1;
    ];
NPTS = length(P_M);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define pose of model with respect to camera1
ax = 120 * DEG_TO_RAD;
ay = 0 * DEG_TO_RAD;
az = 60 * DEG_TO_RAD;

Rx = [ 1    0            0;
       0    cos(ax)     -sin(ax);
       0    sin(ax)      cos(ax) ];
Ry = [ cos(ay)    0     sin(ay);
       0          1     0;
      -sin(ay)    0     cos(ay) ];
Rz = [ cos(az)    -sin(az)   0;
       sin(az)     cos(az)   0;
       0           0         1 ];
R_m_c1 = Rx * Ry * Rz;   
Pmorg_c1 = [0; 0; 5];   % translation of model wrt camera

M = [ R_m_c1 Pmorg_c1 ];    % Extrinsic camera parameter matrix

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Render image 1
p1 = M * P_M;
 
p1(1,:) = p1(1,:) ./ p1(3,:);
p1(2,:) = p1(2,:) ./ p1(3,:);
p1(3,:) = p1(3,:) ./ p1(3,:);
 
u1 = K * p1;  % Convert image points from normalized to unnormalized
for i=1:length(u1)
    x = round(u1(1,i));   y = round(u1(2,i));
    I1(y-2:y+2, x-2:x+2) = 255;
end
figure(1), imshow(I1, []), title('View 1');
pause


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set up second view.
% Define rotation of camera1 with respect to camera2
ax = 0 * DEG_TO_RAD;
ay = -25 * DEG_TO_RAD;
az = 0;
 
Rx = [ 1    0            0;
       0    cos(ax)     -sin(ax);
       0    sin(ax)      cos(ax) ];
Ry = [ cos(ay)    0     sin(ay);
       0          1     0;
      -sin(ay)    0     cos(ay) ];
Rz = [ cos(az)    -sin(az)   0;
       sin(az)     cos(az)   0;
       0           0         1 ];
R_c2_c1 = Rx * Ry * Rz;   
 
% Define translation of camera2 with respect to camera1
Pc2org_c1 = [3; 0; 1];
 
% Figure out pose of model wrt camera 2.
H_m_c1 = [ R_m_c1 Pmorg_c1 ;  0 0 0 1];
H_c2_c1 = [ R_c2_c1 Pc2org_c1 ;   0 0 0 1];
H_c1_c2 = inv(H_c2_c1);
H_m_c2 = H_c1_c2 * H_m_c1;
 
R_m_c2 = H_m_c2(1:3,1:3);
Pmorg_c2 = H_m_c2(1:3,4);
 
% Extrinsic camera parameter matrix
M = [ R_m_c2 Pmorg_c2 ];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Render image 2
I2 = zeros(L,L);
p2 = M * P_M;
 
p2(1,:) = p2(1,:) ./ p2(3,:);
p2(2,:) = p2(2,:) ./ p2(3,:);
p2(3,:) = p2(3,:) ./ p2(3,:);
 
% Convert image points from normalized to unnormalized
u2 = K * p2;
for i=1:length(u2)
    x = round(u2(1,i));   y = round(u2(2,i));
    I2(y-2:y+2, x-2:x+2) = 255;
end
figure(2), imshow(I2, []), title('View 2');

disp('Points in image 1:');
disp(u1);
disp('Points in image 2:');
disp(u2);
imwrite(I1, 'I1.tif');
imwrite(I2, 'I2.tif');


% This is the "true" essental matrix between the views
t = Pc2org_c1;
E = [ 0 -t(3) t(2); t(3) 0 -t(1); -t(2) t(1) 0] * R_c2_c1;
disp('True essential matrix:');
disp(E);

save('u1.mat', 'u1');   % Save points to files
save('u2.mat', 'u2');
save('E.mat', 'E');     % Save to file


