%% Get Mapping Image Info
DNAME = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY';
allimages = dirname('*.jpg',inf,DNAME);
ismapimages = cellfun(@(x) contains(x,'MAPIMAGES'),allimages);

mapimages = allimages(ismapimages);
nmapimages = numel(mapimages);
% nmapimages = 10;

starttime = now;
I = struct('lat', NaN, 'lon', NaN, 't', NaN, 'alt', NaN, 'make', 'fail');
I(nmapimages).lat = NaN;
for i=1:nmapimages
I(i) = getimageinfo(allimages{i});
loopStatus(starttime,i,nmapimages,10);
end
save('imagelatlon.mat','I','mapimages');
%%
lat = [I.lat];
lon = [I.lon];
H = [I.t];

f = figure(1);clf
scatter(-lon,lat,20,H,'filled');