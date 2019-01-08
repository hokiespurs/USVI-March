function [x,y,z] = uv2xyzConstZ(K,R,T,u,v,z)
% Computes xyz projection coordinates assuming a pinhole camera using:
%
%      s * [u;v;1] = K*R*[x-T(1);y-T(2);z-T(3)]
%
%  K : interior orientation [fx 0 cx;0 fy cy;0 0 1]
%  R : rotation matrix from world to camera 
%  T : camera xyz location in world coordinates
%  u : horizontal pixels 0==left side of image
%  v : vertical pixels 0==top of image
%  x : x position of projected pixel in world coordinates
%  y : y position of projected pixel in world coordinates
%  z : z position of projected pixel in world coordinates

%% Compute x and y
x = (R(1,1)*R(3,2)*T(1)*K(2,3)*K(1,1) - R(1,2)*R(3,1)*T(1)*K(2,3)*K(1,1) - R(1,2)*R(3,3)*T(3)*K(2,3)*K(1,1) + R(1,3)*R(3,2)*T(3)*K(2,3)*K(1,1) - R(2,1)*R(3,2)*T(1)*K(1,3)*K(2,2) + R(2,2)*R(3,1)*T(1)*K(1,3)*K(2,2) + R(2,2)*R(3,3)*T(3)*K(1,3)*K(2,2) - R(2,3)*R(3,2)*T(3)*K(1,3)*K(2,2) + R(1,1)*R(2,2)*T(1)*K(1,1)*K(2,2) - R(1,2)*R(2,1)*T(1)*K(1,1)*K(2,2) - R(1,2)*R(2,3)*T(3)*K(1,1)*K(2,2) + R(1,3)*R(2,2)*T(3)*K(1,1)*K(2,2) + R(2,1)*R(3,2)*T(1)*K(2,2)*u - R(2,2)*R(3,1)*T(1)*K(2,2)*u - R(2,2)*R(3,3)*T(3)*K(2,2)*u + R(2,3)*R(3,2)*T(3)*K(2,2)*u - R(1,1)*R(3,2)*T(1)*K(1,1)*v + R(1,2)*R(3,1)*T(1)*K(1,1)*v + R(1,2)*R(3,3)*T(3)*K(1,1)*v - R(1,3)*R(3,2)*T(3)*K(1,1)*v + R(1,2)*R(3,3)*K(2,3)*K(1,1)*z - R(1,3)*R(3,2)*K(2,3)*K(1,1)*z - R(2,2)*R(3,3)*K(1,3)*K(2,2)*z + R(2,3)*R(3,2)*K(1,3)*K(2,2)*z + R(1,2)*R(2,3)*K(1,1)*K(2,2)*z - R(1,3)*R(2,2)*K(1,1)*K(2,2)*z + R(2,2)*R(3,3)*K(2,2)*u*z - R(2,3)*R(3,2)*K(2,2)*u*z - R(1,2)*R(3,3)*K(1,1)*v*z + R(1,3)*R(3,2)*K(1,1)*v*z)./(R(1,1)*R(3,2)*K(2,3)*K(1,1) - R(1,2)*R(3,1)*K(2,3)*K(1,1) - R(2,1)*R(3,2)*K(1,3)*K(2,2) + R(2,2)*R(3,1)*K(1,3)*K(2,2) + R(1,1)*R(2,2)*K(1,1)*K(2,2) - R(1,2)*R(2,1)*K(1,1)*K(2,2) + R(2,1)*R(3,2)*K(2,2)*u - R(2,2)*R(3,1)*K(2,2)*u - R(1,1)*R(3,2)*K(1,1)*v + R(1,2)*R(3,1)*K(1,1)*v);
y = (R(1,1)*R(3,2)*T(2)*K(2,3)*K(1,1) - R(1,2)*R(3,1)*T(2)*K(2,3)*K(1,1) + R(1,1)*R(3,3)*T(3)*K(2,3)*K(1,1) - R(1,3)*R(3,1)*T(3)*K(2,3)*K(1,1) - R(2,1)*R(3,2)*T(2)*K(1,3)*K(2,2) + R(2,2)*R(3,1)*T(2)*K(1,3)*K(2,2) - R(2,1)*R(3,3)*T(3)*K(1,3)*K(2,2) + R(2,3)*R(3,1)*T(3)*K(1,3)*K(2,2) + R(1,1)*R(2,2)*T(2)*K(1,1)*K(2,2) - R(1,2)*R(2,1)*T(2)*K(1,1)*K(2,2) + R(1,1)*R(2,3)*T(3)*K(1,1)*K(2,2) - R(1,3)*R(2,1)*T(3)*K(1,1)*K(2,2) + R(2,1)*R(3,2)*T(2)*K(2,2)*u - R(2,2)*R(3,1)*T(2)*K(2,2)*u + R(2,1)*R(3,3)*T(3)*K(2,2)*u - R(2,3)*R(3,1)*T(3)*K(2,2)*u - R(1,1)*R(3,2)*T(2)*K(1,1)*v + R(1,2)*R(3,1)*T(2)*K(1,1)*v - R(1,1)*R(3,3)*T(3)*K(1,1)*v + R(1,3)*R(3,1)*T(3)*K(1,1)*v - R(1,1)*R(3,3)*K(2,3)*K(1,1)*z + R(1,3)*R(3,1)*K(2,3)*K(1,1)*z + R(2,1)*R(3,3)*K(1,3)*K(2,2)*z - R(2,3)*R(3,1)*K(1,3)*K(2,2)*z - R(1,1)*R(2,3)*K(1,1)*K(2,2)*z + R(1,3)*R(2,1)*K(1,1)*K(2,2)*z - R(2,1)*R(3,3)*K(2,2)*u*z + R(2,3)*R(3,1)*K(2,2)*u*z + R(1,1)*R(3,3)*K(1,1)*v*z - R(1,3)*R(3,1)*K(1,1)*v*z)./(R(1,1)*R(3,2)*K(2,3)*K(1,1) - R(1,2)*R(3,1)*K(2,3)*K(1,1) - R(2,1)*R(3,2)*K(1,3)*K(2,2) + R(2,2)*R(3,1)*K(1,3)*K(2,2) + R(1,1)*R(2,2)*K(1,1)*K(2,2) - R(1,2)*R(2,1)*K(1,1)*K(2,2) + R(2,1)*R(3,2)*K(2,2)*u - R(2,2)*R(3,1)*K(2,2)*u - R(1,1)*R(3,2)*K(1,1)*v + R(1,2)*R(3,1)*K(1,1)*v);
z = ones(size(x))*z;
end

function printEqns
%% symbolic toolbox 
syms fx fy cx cy 
syms T1 T2 T3 x y z u v

R = sym('R%d%d', [3 3]);
K = [fx 0 cx;0 fy cy;0 0 1];

UVS = K * R * [x-T1; y-T2; z-T3];

Eqn(1,1) = u == UVS(1)/UVS(3);
Eqn(2,1) = v == UVS(2)/UVS(3);

sol = solve(Eqn,[x y])

strXeqn = sprintf('x = %s',sol.x);
strYeqn = sprintf('y = %s',sol.y);

for i=1:3
    for j=1:3
        strXeqn = strrep(strXeqn,sprintf('R%i%i',i,j),sprintf('R(%i,%i)',i,j));
        strYeqn = strrep(strYeqn,sprintf('R%i%i',i,j),sprintf('R(%i,%i)',i,j));
    end
    strXeqn = strrep(strXeqn,sprintf('T%i',i),sprintf('T(%i)',i));
    strYeqn = strrep(strYeqn,sprintf('T%i',i),sprintf('T(%i)',i));
end
oldstr = {'fx','fy','cx','cy','/'};
newstr = {'K(1,1)','K(2,2)','K(1,3)','K(2,3)','./'};

for i=1:numel(oldstr)
strXeqn = strrep(strXeqn,oldstr{i},newstr{i});
strYeqn = strrep(strYeqn,oldstr{i},newstr{i});
end

fprintf('%s;\n%s;\n',strXeqn,strYeqn);
end
