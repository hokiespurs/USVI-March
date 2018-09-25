function tUTC = getFolderImagesTime(dname)
    imnames = dirname([dname '/01_IMAGES/*.jpg']);
    if contains(dname,'MAVIC')
        x = dir([dname '/01_IMAGES/*.jpg']);
        allt = [x.datenum]';
        tUTC = nanmean(allt) - 4/24;
        
    elseif contains(dname,'SOLO')
        x = dir([dname '/01_IMAGES/*.dng']);
        allt = [x.datenum]';
        tUTC = nanmean(allt) - 3/24;
        
    else %S900
        imagepos = [dname '/02_TRAJECTORY/imagepos.csv'];
        dat = importdata(imagepos);
        tstart = datenum(dat.textdata(2,3),'yyyymmdd-HHMMss.fff');
        tend = datenum(dat.textdata(end,3),'yyyymmdd-HHMMss.fff');
        tUTC = mean([tstart tend]);
        
    end
    
end