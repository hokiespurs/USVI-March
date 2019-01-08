% Calculate structure and motion.

clear all
close all
 
I1 = imread('I1.tif');
I2 = imread('I2.tif');

% intrinsic camera parameters
K = [ 300  0  150;   
      0  300  150;
      0  0   1];
 
load E
load u1
load u2

     
% These are the normalized image points
p1 = inv(K)*u1;
p2 = inv(K)*u2;

% Display images
subplot(1,2,1), imshow(I1, []), title('View 1');
for i=1:length(u1)
    rectangle('Position', [u1(1,i)-4 u1(2,i)-4 8 8], 'EdgeColor', 'r');
    text(u1(1,i)+4, u1(2,i)+4, sprintf('%d', i), 'Color', 'r');
end
subplot(1,2,2), imshow(I2, []), title('View 2');
for i=1:length(u2)
    rectangle('Position', [u2(1,i)-4 u2(2,i)-4 8 8], 'EdgeColor', 'g');
    text(u2(1,i)+4, u2(2,i)+4, sprintf('%d', i), 'Color', 'g');
end
 
pause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extract motion parameters from essential matrix.
% We know that E = [tx] R, where
%  [tx] = [ 0 -t3 t2; t3 0 -t1; -t2 t1 0]
%
% If we take SVD of E, we get E = U diag(1,1,0) V'
% t is the last column of U
[U,D,V] = svd(E);
 
W = [0 -1 0; 1 0 0; 0 0 1];
Hresult_c2_c1(:,:,1) = [ U*W*V'   U(:,3) ; 0 0 0 1];
Hresult_c2_c1(:,:,2) = [ U*W*V'  -U(:,3) ; 0 0 0 1];
Hresult_c2_c1(:,:,3) = [ U*W'*V'  U(:,3) ; 0 0 0 1];
Hresult_c2_c1(:,:,4) = [ U*W'*V' -U(:,3) ; 0 0 0 1];

% make sure each rotation component is a legal rotation matrix
for k=1:4
    if det(Hresult_c2_c1(1:3,1:3,k)) < 0
        Hresult_c2_c1(1:3,1:3,k) = -Hresult_c2_c1(1:3,1:3,k);
    end
end


disp('Calculated possible poses, camera 2 to camera 1:');
disp(Hresult_c2_c1);

pause


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find the correct motion.  We will need to reconstruct the actual 3D
% position of one of the points (say, point 1).
%
% We have matching image points p1,p2.  We know that p1 x M1 P = 0 and
% p2 x M2 P = 0, where M1,M2 are the projection matrices and P is the
% unknown 3D point.  Or, we have
%   A P = 0, where
%       A = ( [p1x] M1 )
%           ( [p2x] M2 ) 
% Here, M1 is identity and M2 is H_c1_c2. 
M1 = [ 1 0 0 0;
       0 1 0 0;
       0 0 1 0];

% Get skew symmetric matrices for point number 1
p1x = [ 0        -p1(3,1)   p1(2,1);
        p1(3,1)   0        -p1(1,1);
       -p1(2,1)   p1(1,1)   0  ];

p2x = [ 0        -p2(3,1)   p2(2,1);
        p2(3,1)   0        -p2(1,1);
       -p2(2,1)   p2(1,1)   0  ];

% See which of the four solutions will yield a 3D point position that is in
% front of both cameras (ie, has its z>0 for both).
for i=1:4
    Hresult_c1_c2 = inv(Hresult_c2_c1(:,:,i));
    M2 = Hresult_c1_c2(1:3,1:4);
    
    A = [ p1x * M1; p2x * M2 ];
    % The solution to AP=0 is the singular vector of A corresponding to the
    % smallest singular value; that is, the last column of V in A=UDV'
    [U,D,V] = svd(A);
    P = V(:,4);                     % get last column of V
    P1est = P/P(4);                 % normalize

    P2est = Hresult_c1_c2 * P1est;
 
    if P1est(3) > 0 && P2est(3) > 0
        % We've found a good solution.
        Hest_c2_c1 = Hresult_c2_c1(:,:,i);
        break;      % break out of for loop; can stop searching
    end
end

% Now we have the transformation between the cameras (up to a scale factor)
fprintf('Reconstructed pose of camera2 wrt camera1:\n');
disp(Hest_c2_c1);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Hest_c1_c2 = inv(Hest_c2_c1);
M2est = Hest_c1_c2(1:3,:);
 
% Reconstruct point positions (these are good to the same scale factor)
fprintf('Reconstructed points wrt camera1:\n');
for i=1:length(p1)
    p1x = [ 0        -p1(3,i)   p1(2,i);
        p1(3,i)   0        -p1(1,i);
       -p1(2,i)   p1(1,i)   0  ];
    p2x = [ 0        -p2(3,i)   p2(2,i);
        p2(3,i)   0        -p2(1,i);
       -p2(2,i)   p2(1,i)   0  ];
 
    A = [ p1x * M1; p2x * M2est ];
    [U,D,V] = svd(A);
    P = V(:,4);                     % get last column of V  
    P1est(:,i) = P/P(4);                 % normalize
 
    fprintf('%f %f %f\n', P1est(1,i), P1est(2,i),P1est(3,i));
end
 
 
% Show the reconstruction result in 3D
figure;
plot3(P1est(1,:),P1est(2,:),P1est(3,:),'d');
axis equal;
axis vis3d




