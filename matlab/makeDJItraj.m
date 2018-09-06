function [lon,lat,Z] = makeDJItraj(imnames,savename,Zoffset)
if nargin==2
   Zoffset = 0; 
end

lon = nan(1,numel(imnames));
lat = nan(1,numel(imnames));
Z = nan(1,numel(imnames));

starttime = now;
fid=fopen(savename,'w+t');
fprintf(fid,'ImageName,lon,lat,Z\n');
for i=1:numel(imnames)
    [~,data]=system(['exiftool.exe -n ' imnames{i}]);
    [lon(i),lat(i),Z(i)] = getGPS(data);
    [~,justname,ext] = fileparts(imnames{i});
    loopStatus(starttime,i,numel(imnames),1);
    fprintf(fid,'%s,%.9f,%.9f,%.2f\n',[justname ext],lon(i),lat(i),Z(i)+Zoffset);
end
fclose(fid);

end

function [lon,lat,Z] = getGPS(data)
    alllines = strsplit(data,'\n');
    lon = getval('GPS Longitude   ',alllines);
    lat = getval('GPS Latitude   ',alllines);
    Z = getval('Relative Altitude',alllines);
end

function val = getval(matchstr,alllines)
    ind = find(cellfun(@(x) funmatchstr(matchstr,x),alllines));
    if ~isempty(ind)
        splitdat = strsplit(alllines{ind},':');
        val = str2double(splitdat(2));
    else
       val = nan; 
    end
end

function val = funmatchstr(matchstr,x)
    if (numel(x)<numel(matchstr))
       val = false;
    else
        val = strcmp(matchstr,x(1:numel(matchstr)));
    end

end