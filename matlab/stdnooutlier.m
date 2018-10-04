function [ux,sx] = stdnooutlier(x,n)

if nargin==1
    n = 3;
end

noutliers = 1;
xnew = x(~isnan(x));
while(noutliers>0)
    ux = nanmean(xnew);
    sx = nanstd(xnew);
    indoutlier = xnew<(ux-sx*n) | xnew>(ux+sx*n);
    noutliers = nansum(indoutlier);
    xnew = xnew(~indoutlier);
end
sx = nanstd(xnew);
ux = nanmean(xnew);

end