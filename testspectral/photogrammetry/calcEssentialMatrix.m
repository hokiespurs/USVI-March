function E = calcEssentialMatrix(xy1,xy2,K)
% xy1 = [N x 2]
% xy2 = [N x 2]
% K = [f 0 cx;0 f cy;0 0 1];
%
% taken from http://inside.mines.edu/~whoff/courses/EENG512/lectures/

u1 = [xy1 ones(size(xy1,1),1)]';
u2 = [xy2 ones(size(xy2,1),1)]';

p1 = inv(K)*u1;
p2 = inv(K)*u2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Scale and translate image points so that the centroid of
% the points is at the origin, and the average distance of the points to the
% origin is equal to sqrt(2).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xn = p1(1:2,:);             % xn is a 2xN matrix
N = size(xn,2);
t = (1/N) * sum(xn,2);      % this is the (x,y) centroid of the points
xnc = xn - t*ones(1,N);     % center the points; xnc is a 2xN matrix
dc = sqrt(sum(xnc.^2));     % dist of each new point to 0,0; dc is 1xN vector
davg = (1/N)*sum(dc);       % average distance to the origin
s = sqrt(2)/davg;           % the scale factor, so that avg dist is sqrt(2)
T1 = [s*eye(2), -s*t ; 0 0 1];
p1s = T1 * p1;
 
xn = p2(1:2,:);             % xn is a 2xN matrix
N = size(xn,2);
t = (1/N) * sum(xn,2);      % this is the (x,y) centroid of the points
xnc = xn - t*ones(1,N);     % center the points; xnc is a 2xN matrix
dc = sqrt(sum(xnc.^2));     % dist of each new point to 0,0; dc is 1xN vector
davg = (1/N)*sum(dc);       % average distance to the origin
s = sqrt(2)/davg;           % the scale factor, so that avg dist is sqrt(2)
T2 = [s*eye(2), -s*t ; 0 0 1];
p2s = T2 * p2;


% Compute essential matrix E from point correspondences.
% We know that p1s' E p2s = 0, where p1s,p2s are the scaled image coords.
% We write out the equations in the unknowns E(i,j)
%   A x = 0
A = [p1s(1,:)'.*p2s(1,:)'   p1s(1,:)'.*p2s(2,:)'  p1s(1,:)' ...
         p1s(2,:)'.*p2s(1,:)'   p1s(2,:)'.*p2s(2,:)'  p1s(2,:)' ...
         p2s(1,:)'             p2s(2,:)'  ones(length(p1s),1)];       
 
% The solution to Ax=0 is the singular vector of A corresponding to the
% smallest singular value; that is, the last column of V in A=UDV'
[U,D,V] = svd(A);
x = V(:,size(V,2));                  % get last column of V

% Put unknowns into a 3x3 matrix.  Transpose because Matlab's "reshape"
% uses the order E11 E21 E31 E12 ...
Escale = reshape(x,3,3)';

% Force rank=2 and equal eigenvalues
[U,D,V] = svd(Escale);
Escale = U*diag([1 1 0])*V';

% Undo scaling
E = T1' * Escale * T2;

end