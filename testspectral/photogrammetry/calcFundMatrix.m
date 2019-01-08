function F = calcFundMatrix(xy1,xy2)
% is it really nonlinear?
% prescale data so average distance is sqrt(2)
% postcondition to enforce rank 2 by decomposing SVD
%   [U,D,V] = svd(F)
%   Enew = U * diag([1 1 0]) * V'; 
% https://www.youtube.com/watch?v=kfN76APa4HE
x = data2x(xy1,xy2);
y = zeros(numel(xy1)/2,1);
betacoef0 = ones(8,1);

beta = lsr(x,y,@modelfun,betacoef0);

F = reshape([1;beta]',3,3)';

% enforce rank 2
[U,~,V]=svd(F);
F = U * diag([1 1 0]) * V';

end

function x = data2x(xy1,xy2)
x = [xy1(:,1) xy1(:,2) xy2(:,1) xy2(:,2)];

end

function y = modelfun(b,x)
% x = [x1,y1,x2,y2];
% b = [f11,f21,f31...,f33]';

x1 = x(:,1);
y1 = x(:,2);
x2 = x(:,3);
y2 = x(:,4);

F = [1; b(:)];

y = [x1(:).*x2(:), x1(:).*y2(:), x1(:),...
    y1(:).*x2(:), y1(:).*y2(:), y1(:), ...
    x2(:), y2(:), ones(size(x2(:))) ] * F(:);

end