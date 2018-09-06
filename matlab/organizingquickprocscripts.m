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
xmlname = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\06_PROCIMAGES\0320_BUCK_MAVIC_200FT\06_QUICKPROC\quickproc4.xml';
[~,dnames] = dirname('P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\06_PROCIMAGES\*',0);

for i=2:numel(dnames)
    dname = dnames{i};
    if ~exist([dname '/06_QUICKPROC'],'dir')
        mkdir([dname '/06_QUICKPROC']);
    end
    destination = [dname '/06_QUICKPROC/quickproc4.xml'];
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
