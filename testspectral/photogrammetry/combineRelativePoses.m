function C = combineRelativePoses(X)

ncams = size(X,1);

indpairs = find(cellfun(@(x) ~isempty(x),X));
[indm,indn]=ind2sub(size(X),indpairs);

npairs = sum(sum(cellfun(@(x) ~isempty(x),X)));

x = nan(npairs,6);
b = zeros(ncams * 6,1);

y = zeros(npairs*6,1);

for i=1:npairs
    iX = X{indm(i),indn(i)};
    
    [iw,ip,ik]=dcm2angle(iX.R);
    iT = iX.T;
    
    x(i,:) = [iw ip ik iT(:)'];
end

modelfun = @(b,x) lsrmodelfun(b,x,indm,indn);

betacoef = lsr(x,y,modelfun);

end


function y = lsrmodelfun(b,x,m,n)
% beta = [x2,y2,z2,w2,p2,k2,x3,y3,z3,w3,p3,k3,...,xn,yn,zn,wn,pn,kn];
% x    = [xmn,ymn,zmn,wmn,pmn,kmn;]
% m    = ind cam1
% n    = ind cam2

bwithcam1locked = [zeros(6,1); b];

y = zeros(numel(m)*6,1);

for i=1:numel(m)
    yind = (i-1)*6+1:i*6;
    
    M12 = calcM(x(i,:));
    
    bindm = (m-1)*6+1:m*6;
    M1 = calcM(bwithcam1locked(bindm));
    
    bindn = (n-1)*6+1:n*6;
    M2 = calcM(bwithcam1locked(bindn));
    
    dM = M12 * M1 - M2;
    
    dT = dM(1:3,4);
    [dw,dp,dk]=dcm2angle(dM(1:3,1:3));
    
    y(yind) = [dT; dw; dp; dk];
    
end

end

function M = calcM(x)
M = [angle2dcm(x(1),x(2),x(3)) [x(4);x(5);x(6)];0 0 0 1];

end