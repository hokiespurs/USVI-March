function markers = readMarkers(fname)
rawdat = importdata(fname);
if iscell(rawdat)
    markers.name = [];
    markers.enabled = nan;
    markers.E = nan;
    markers.N = nan;
    markers.Z = nan;
    markers.dE = nan;
    markers.dN = nan;
    markers.dZ = nan;
else
    markers.name = rawdat.textdata(3:end-1,:);
    markers.enabled = rawdat.data(1:end-1,1);
    markers.E = rawdat.data(1:end-1,2);
    markers.N = rawdat.data(1:end-1,3);
    markers.Z = rawdat.data(1:end-1,4);
    markers.dE = rawdat.data(1:end-1,5);
    markers.dN = rawdat.data(1:end-1,6);
    markers.dZ = rawdat.data(1:end-1,7);
end
end