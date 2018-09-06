function data = readControlData(fname,badinds)
    fid=fopen(fname,'r');
    alldat = fread(fid,'*char');
    fclose(fid);
    alllines = strsplit(alldat','\n');
    nchar = cellfun(@numel,alllines);
    alllines(nchar==0)=[];
    idata = cellfun(@getcontroldata,alllines(2:end));
    data.id = {idata.id};
    data.e = [idata.e];
    data.n = [idata.n];
    data.lat = [idata.lat];
    data.lon = [idata.lon];
    data.ellip = [idata.ellip];
    data.orth = [idata.orth];
    data.depth = [idata.depth];
    if nargin==2
        data.id(badinds)=[];
        data.e(badinds)=[];
        data.n(badinds)=[];
        data.lat(badinds)=[];
        data.lon(badinds)=[];
        data.ellip(badinds)=[];
        data.orth(badinds)=[];
        data.depth(badinds)=[];
    end
end




function data = getcontroldata(x)
    y = split(x,',');
    data.id = y{1};
    data.e = str2double(y{2});
    data.n = str2double(y{3});
    data.lat = str2double(y{4});
    data.lon = str2double(y{5});
    data.ellip = str2double(y{6});
    data.orth = str2double(y{7});
    data.depth = str2double(y{8});
end