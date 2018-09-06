% control sanity check
dname = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\03_DELIVERABLES\01_GEOSPATIAL\01_CONTROL';
fnames = dirname([dname '/*.csv']);
close all
for i=1:numel(fnames)
   data = readControlData(fnames{i});
   [~,justname]=fileparts(fnames{i});
   f = figure((i-1)*2+1);hold on
   plot(data.e,data.n','.')
%    text(data.e,data.n,data.id)
   title(fixfigstring(justname))
   drawnow
   pause(1);
   f = figure((i-1)*2+2);hold on
   plot(data.lon,data.lat,'.')
%    text(data.lon,data.lat,data.id)
   title(fixfigstring(justname))
   drawnow
   pause(1);
end

