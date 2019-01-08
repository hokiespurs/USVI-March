function [R, T] = calcNormRelativeRotation(xy1,xy2,K)
%%
% https://www.youtube.com/watch?v=5wuWKTJCV1w
E = calcEssentialMatrix(xy1,xy2,K); % fundamental for 1 to 2

u1 = [xy1 ones(size(xy1,1),1)]';
u2 = [xy2 ones(size(xy2,1),1)]';

p1 = inv(K)*u1;
p2 = inv(K)*u2;

[U,D,V]=svd(E);
W = [0 -1 0;
    1 0 0;
    0 0 1];

H(:,:,1) = [U*W*V' U(:,3);0 0 0 1];
H(:,:,2) = [U*W*V' -U(:,3);0 0 0 1];
H(:,:,3) = [U*W'*V' U(:,3);0 0 0 1];
H(:,:,4) = [U*W'*V' -U(:,3);0 0 0 1];

for i=1:4
    if det(H(1:3,1:3,i))<0 % ensure legal rotation matrix
        H(1:3,1:3,i)=-H(1:3,1:3,i);
    end
end

M1 = [eye(3) zeros(3,1)];
%plot 
% figure(114);clf
CAMK   = [3000 0 2000;0 3000 1500;0 0 1];
% plotCameraPyramid(CAMK,eye(3),[0 0 0],[4000 3000],'optpatch',{'facecolor','g'});

cmap = lines(4);

%
p1x = [ 0        -p1(3,1)   p1(2,1);
        p1(3,1)   0        -p1(1,1);
       -p1(2,1)   p1(1,1)   0  ];

p2x = [ 0        -p2(3,1)   p2(2,1);
        p2(3,1)   0        -p2(1,1);
       -p2(2,1)   p2(1,1)   0  ];

for i=1:4
   
   iH = inv(H(:,:,i)); 
   M2 = iH(1:3,1:4);
   
   A = [p1x*M1;p2x*M2];
   
   [U,D,V] = svd(A);
   P = V(:,4);
   P1est = P/P(4);
   P2est = iH * P1est;
%    fprintf('Option %g: P1: %g P2:%g ...',i,P1est(3)>0,P2est(3)>0)
   if P1est(3)>0 && P2est(3)>0
      ind = i;
      linecolor = 'g';
%       fprintf('bingo\n');
%       plot3(P1est(1),P1est(2),P1est(3),'b.')
   else
%        fprintf('fail\n');
       linecolor = 'r';
   end
% plotCameraPyramid(CAMK,M2(:,1:3),M2(:,4),[4000 3000],'optpatch',...
%     {'facecolor',cmap(i,:)},'optline',{'color',linecolor});
%    grid on
end

R = H(1:3,1:3,ind);
T = H(1:3,4);

end

function hisway
%%
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


p1 = xy1;
p2 = xy2;

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
        fprintf('%g\n',i);      % break out of for loop; can stop searching
    end
end

% Now we have the transformation between the cameras (up to a scale factor)
fprintf('Reconstructed pose of camera2 wrt camera1:\n');
disp(Hest_c2_c1);

end