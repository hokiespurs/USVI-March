function [x,y,z,gcpx,gcpy,gcpz] = fakeSfMData(datasourceid, npts, dodebug)
%% Makes Fake Data

switch datasourceid
    case 1
        % max z = 10
        zg = peaks(npts)*10/max(max(peaks(npts)));
        xi = linspace(0,100,npts);
        yi = linspace(0,100,npts);
        [xg,yg]=meshgrid(xi,yi);
        [gcpx, gcpy] = meshgrid(25:25:75,25:25:75);
        F = scatteredInterpolant(xg(:),yg(:),zg(:));
        gcpz = F(gcpx,gcpy);
    case 2
        
end

x = xg(:);
y = yg(:);
z = zg(:);
gcpx = gcpx(:);
gcpy = gcpy(:);
gcpz = gcpz(:);

% dodebug
if dodebug
    scatter3(x,y,z,10,z,'filled');axis equal
    hold on
    surface(xg,yg,zg,'facecolor','k','facealpha',0.05,'edgecolor','k');
    hold on
    scatter3(x,y,z,10,z,'filled');axis equal
    plot3(gcpx,gcpy,gcpz,'r.','markersize',20)
end

end