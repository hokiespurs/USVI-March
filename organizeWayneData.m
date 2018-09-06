%organize wayne data
DRIVENAME = 'E:\2018-USVI-cwwright\';

[~,dnames]=dirname('2018_03*',0,DRIVENAME);
figure(1);clf

fprintf('Date,StartTime,EndTime,Nimages\n')

for i=1:numel(dnames)
   csvname = dirname([dnames{i} '/raw_dng/*.csv']); 
   dng_info = importdata(csvname{1});
   alldat = cellfun(@(x) strsplit(x,','),dng_info,'UniformOutput',false);
   
   nimages = numel(alldat);
   imnames = cell(nimages,1);
   imtime = nan(nimages,1);
   
   for j=1:nimages
       imnames{j} = alldat{j}{1};
       imtime(j) = datenum(alldat{j}{2},'yyyy:mm:dd HH:MM:ss');
   end
   
   ind = [0; find(diff(imtime)*24*60*60>60); nimages];
   [~,justname,~]=fileparts(dnames{i});
   
   starttime = imtime(ind(1:end-1)+1);
   endtime = imtime(ind(2:end));
   nflightimages = diff(ind);
   
   for j=1:numel(starttime)
       fprintf('%s,%s,%s,%.0f\n',datestr(starttime(j),'dd-mmm-yy'),...
           datestr(starttime(j),'HH:MM'),datestr(endtime(j),'HH:MM'),nflightimages(j))
   end
   
%    subplot(3,3,i)
%    plot((imtime-imtime(1))*24*60*60,'b.-');
%    hold on
%    plot(ind(2:end),(imtime(ind(2:end))-imtime(1))*24*60*60,'r.','markersize',40);
%    grid on
%    
%    title(fixfigstring(justname),'interpreter','latex','fontsize',18);
%    xlabel('Image Number','interpreter','latex','fontsize',16)
%    ylabel('Time(s)','interpreter','latex','fontsize',16)
%    
%    drawnow
end

% Make imageposUTM.csv for every DNG wayne has
%%
all_trajcsvnames = dirname([DRIVENAME '*/Trajectories/*.csv']);
goodones = [1 5 6 7 9 15 16 17];
all_trajcsvnames = all_trajcsvnames(goodones);
allnames = [];
alltimes = [];
alllat   = [];
alllon   = [];
alle     = [];
alln     = [];
allz     = [];
allstdz  = [];

figure(2);clf
figure(3);clf
for i=1:numel(all_trajcsvnames)
    alldat = importdata(all_trajcsvnames{i});
    if isstruct(alldat)
        inames = alldat.textdata(7:end-1,2);
        itime = datenum(alldat.textdata(7:end-1,3),'yyyy:mm:dd HH:MM:ss');
        
        ilat = alldat.data(:,1);
        ilon = alldat.data(:,2);
        iz = alldat.data(:,3);
        istdz = alldat.data(:,9);
        
        [ie,in] = deg2utm(ilat,ilon);
        
        allnames = [allnames; inames];
        alltimes = [alltimes; itime];
        alllat   = [alllat; ilat];
        alllon   = [alllon; ilon];
        alle     = [alle; ie];
        alln     = [alln; in];
        allz     = [allz; iz];
        allstdz  = [allstdz; istdz];
        
        %
        [~,justname,~]=fileparts(fileparts(fileparts(all_trajcsvnames{i})));
        
%         figure(2)
%         subplot(3,3,i)
%         scatter(itime,iz,20,ie,'filled')
%         datetick
%         title(fixfigstring(justname),'interpreter','latex','fontsize',18);
%         ylabel('Ellipsoid Ht (m)','interpreter','latex','fontsize',16)
%         xlabel('Time(s)','interpreter','latex','fontsize',16)
%         
%         figure(3);
%         subplot(3,3,i)
%         scatter(ie,in,20,(itime-itime(1))*24*60*60,'filled');
        
    end
end

%% Figure out flights
addbreaks = [5900 18850]';
ind = sort([0; find(diff(alltimes)*24*60*60>60); addbreaks; numel(alltimes)]);

figure(3);clf
figure(4);clf

manualinds = [54 408;
              1 1;
              60 423;
              45 462;
              1 1;
              43 522;
              1 1;
              30 468;
              1 1;
              68 315;
              44 465;
              42 467;
              88 329;
              39 165;
              76 343;
              1 1;
              57 497;
              113 517;
              1 1;
              1 1;
              201 463;
              87 421;
              1 1;
              52 430;
              51 430;
              61 282;
              51 355;
              50 345;
              68 292;
              53 180;
              43 235;
              80 435;
              63 269;
              80 490;
              90 510;
              96 515;
              163 577;
              82 500;
              185 586;
              98 521;
              81 505];

allstarts = [];
allends = [];
          
for i=1:numel(ind)-1
    flightinds = ind(i)+1:ind(i+1);
    goodflightinds = flightinds(manualinds(i,1):manualinds(i,2));
    
    f = figure(3);clf
    subplot(1,2,1)
    it = (alltimes(flightinds)-alltimes(flightinds(1)))*60*60*24;
    it2 = (alltimes(goodflightinds)-alltimes(flightinds(1)))*60*60*24;
    plot(it,allz(flightinds),'r.-');
    hold on
    plot(it2,allz(goodflightinds),'b.-');
    hold off
    xlabel('Time From Takeoff (s)','interpreter','latex','fontsize',16);
    ylabel('Ellipsoid Height(m)','interpreter','latex','fontsize',16);
    legend({'Unused Images','Used Images'},'interpreter','latex','fontsize',16);
    grid on
    
    subplot(1,2,2);
    ix = alle(flightinds)-alle(flightinds(1));
    iy = alln(flightinds)-alln(flightinds(1));

    ix2 = alle(goodflightinds)-alle(flightinds(1));
    iy2 = alln(goodflightinds)-alln(flightinds(1));

    plot(ix,iy,'r.-');
    hold on
    plot(ix2,iy2,'b.-');
    hold off
    xlabel('Relative Easting (m)','interpreter','latex','fontsize',16);
    ylabel('Relative Northing(m)','interpreter','latex','fontsize',16);
    grid on
    axis equal
    bigtitle([sprintf('%.0f) ',i) datestr(alltimes(goodflightinds(1)))],0.5,0.95,'fontsize',20,'interpreter','latex');
    
    % allstarts and allends
    if manualinds(i,1)~=1
        allstarts = [allstarts goodflightinds(1)];
        allends = [allends goodflightinds(end)];
    end
    
    saveas(f,sprintf('WayneFlight%.0f.png',i));
%     
%     figure(10);
%     plot(alle(goodflightinds),alln(goodflightinds),'.-');
%     hold on
%     
%     pause(1)
end

clc
fprintf('Date,StartTime,EndTime,MedianZ,Nimages\n')
for i=1:numel(allstarts)  
    firsttime = alltimes(allstarts(i));
    lasttime = alltimes(allends(i));
    NImages = allends(i)-allstarts(i)+1;
    medianZ = nanmedian(allz(allstarts(i):allends(i)))+40;
    fprintf('%s,%s,%s,%.1f,%.0f\n',datestr(firsttime,'dd-mmm-yy'),...
           datestr(firsttime,'HH:MM:ss'),datestr(lasttime,'HH:MM:ss'),medianZ,NImages)
    
end

%% Make Folder Structure
OUTDIR = 'P:\Slocum\USVI_project\01_DATA\WAYNEFLIGHTS\';
totnum = sum(allends-allstarts+1);
count=0;

for i=1:numel(allstarts)
    firsttime = alltimes(allstarts(i));
    lasttime = alltimes(allends(i));
    NImages = allends(i)-allstarts(i)+1;
    ht = (nanmedian(allz(allstarts(i):allends(i)))+40)/.3048;

    dname1 = datestr(firsttime,'mmdd');
    
    mkdir([OUTDIR dname1]);
    
    dname = [datestr(firsttime,'mmdd/HHMM') sprintf('_SOLO_%.0fft',ht)];
   
    mkdir([OUTDIR dname]);
    
    mkdir([OUTDIR dname '/01_IMAGES']);
    mkdir([OUTDIR dname '/02_TRAJECTORY']);
    mkdir([OUTDIR dname '/03_IMAGEMARKERS']);
    mkdir([OUTDIR dname '/04_IMAGEMASKS']);
    mkdir([OUTDIR dname '/05_DOWNSAMPLE']);
    mkdir([OUTDIR dname '/06_QUICKPROC']);
    % make trajectory
    fid = fopen([OUTDIR dname '/02_TRAJECTORY/imageposUTM.csv'],'w+t');
    fprintf(fid,'ImageName,Lon,Lat,UTME,UTMN,Z,stdX,stdY,stdZ\n');
    
    % copy images to images folder
    starttime = now;
    for j=allstarts(i):allends(i)
        count=count+1;
        iname = dirname(allnames{j},100,DRIVENAME);
        newname = [OUTDIR dname '/01_IMAGES/' allnames{j}];
        if ~exist(newname,'file')
            copyfile(iname{1},newname);
        end
        % add to trajectory
        fprintf(fid,'%s,%.9f,%.9f,%.3f,%.3f,%.3f,%.2f,%.2f,%.2f\n',allnames{j},...
            alllon(j),alllat(j),alle(j),alln(j),allz(j),0.03,0.03,allstdz(j));
        
        loopStatus(starttime,count,totnum,10);
    end
    fclose(fid);

end
