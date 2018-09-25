%%
[fnames] = dirname('imageposUTM.csv',10,'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\06_PROCIMAGES\');

for i=1:numel(fnames)
    fname = fnames{i};
    dname = fileparts(fname);
    
    dat = importdata(fname);
    X = dat.data(:,3);
    Y = dat.data(:,4);
    Z = dat.data(:,5);
    imnames = dat.textdata(2:end,1);
    
    imnames2 = cellfun(@(x) x(1:end-4),imnames,'uniformOutput',false);
    imnamesBoth = [imnames imnames2];
    outname = [dname '/imageposUTM.xml'];
    
    writeOutputTrajectoryNames(outname,imnamesBoth,[X;X],[Y;Y],[Z;Z]);
end

%%
xmlname = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\06_PROCIMAGES\0320_BUCK_MAVIC_200FT\06_QUICKPROC\quickproc5.xml';
[~,dnames] = dirname('P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\06_PROCIMAGES\*',0);

for i=2:numel(dnames)
    dname = dnames{i};
    if ~exist([dname '/06_QUICKPROC'],'dir')
        mkdir([dname '/06_QUICKPROC']);
    end
    destination = [dname '/06_QUICKPROC/quickproc5.xml'];
    copyfile(xmlname,destination);
end

%%
[~,dnames] = dirname('P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\06_PROCIMAGES\*',0);
for i=1:numel(dnames)
    dname = dnames{i};
    if exist([dname '/06_QUICKPROC'],'dir')
        if exist([dname '/06_QUICKPROC/quickproc/autoproc.log'],'file') && ...
                ~exist([dname '/06_QUICKPROC/quickproc/dense.las'],'file')
           fprintf('remove: %s\n',[dname '/06_QUICKPROC/quickproc']);
%            delete([dname '/06_QUICKPROC/quickproc/autoproc.log']);
%            delete([dname '/06_QUICKPROC/quickproc/proctime.log']);
        end
    end
    
end
%%
[fnames] = dirname('imageposUTM.csv',10,'P:\Slocum\USVI_project\01_DATA\WAYNEFLIGHTS\');

for i=1:numel(fnames)
    fname = fnames{i};
    dname = fileparts(fname);
    
    dat = importdata(fname);
    X = dat.data(:,3);
    Y = dat.data(:,4);
    
    Z = dat.data(:,5);
    imnames = dat.textdata(2:end,1);
    
    imnames2 = cellfun(@(x) x(1:end-4),imnames,'uniformOutput',false);
    imnamesBoth = [imnames imnames2];
    outname = [dname '/imageposUTM.xml'];
    
    writeOutputTrajectoryNames(outname,imnamesBoth,[X;X],[Y;Y],[Z;Z]);
end

%% 
%%
fnames = dirname('P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\06_PROCIMAGES\*SOLO*\02_TRAJECTORY\*.csv');

for i=1:numel(fnames)
    x = importdata(fnames{i});
    
    names = x.textdata(2:end,1);
    x.data(:,5)=x.data(:,5)-0.182;
    
    dname = fileparts(fnames{i});
    movefile(fnames{i},[dname '/nooffset.csv']);
    
    fid = fopen(fnames{i},'w+t');
    fprintf(fid,'ImageName,Lon,Lat,UTME,UTMN,Z,stdX,stdY,stdZ\n');
    
    for j=1:numel(names)
        fprintf(fid,'%s,%.9f,%.9f,%.3f,%.3f,%.3f,%.2f,%.2f,%.2f\n',names{j},x.data(j,:));
    end
    
    fclose(fid);
    
end

%% Get tide for each dataset
% SOLO has time in text file
% MAVIC in image date modified
% S900 in trajectory
[~,dnames] = dirname('P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\06_PROCIMAGES\');
tidedata = importdata('P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\03_DELIVERABLES\01_GEOSPATIAL\02_ANCILLARY\01_TIDAL\9751364_EllipsoidNAD83-2011_meters.csv');
tide_t = [];
tide_z = [];
for i=1:size(tidedata.data,1)
    tide_t(i) = datenum(tidedata.textdata{i+1,1});
end
tide_z = tidedata.data(:,2);

for i=1:numel(dnames)
    tUTC = getFolderImagesTime(dnames{i});
    [~,justname] = fileparts(dnames{i});
    fprintf('%-40s: %s\n',justname,datestr(tUTC));
    tideval = interp1(tide_t,tide_z,tUTC);
    mkdir([dnames{i} '/07_TIDE']);
    fid = fopen([dnames{i} '/07_TIDE/tideval.txt'],'w+t');
    fprintf(fid,'%.2f',tideval);
    fclose(fid);
    fid = fopen([dnames{i} '/07_TIDE/readme.txt'],'w+t');
    fprintf(fid,'Tide value in NAD83 Ellipsoid computed by interpolating tide data from\n');
    fprintf(fid,'P:\\Slocum\\USVI_project\\01_DATA\\20180319_USVI_UAS_BATHY\\03_DELIVERABLES\\01_GEOSPATIAL\\02_ANCILLARY\\01_TIDAL\\9751364_EllipsoidNAD83-2011_meters.csv');
    fclose(fid);
end
