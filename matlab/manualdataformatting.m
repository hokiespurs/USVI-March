baddataname = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\01_CONTROLPROC\20180416_BUCK0323_SONAR\20180323_BUCK_adjusted.csv';
gooddataname = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\01_CONTROLPROC\20180416_BUCK0323_SONAR\buck_sonar3_utm20_NAD83ellip.csv';
trimmedgood = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\01_CONTROLPROC\20180416_BUCK0323_SONAR\BUCK_FINAL_TRIMMED.csv';

a = importdata(baddataname);
b = importdata(gooddataname,',',3);

Aid = a.data(:,1);
Bid = b.data(:,1);

goodind = ismember(Bid,Aid);
ngoodpts = sum(goodind);

Btrim = b.data(goodind,:);

fid = fopen(trimmedgood,'w+t');
fprintf(fid,'PtID,EAST,NORTH,LAT,LON,ELEVATION,DEPTH\n');
for i=1:ngoodpts
    PTID = Btrim(i,1);
    E = Btrim(i,2);
    N = Btrim(i,3);
    h = Btrim(i,4);
    d = Btrim(i,5);
    [Lat,Lon] = utm2deg(E,N,'20 N');
    
    fprintf(fid,'%.0f,%.3f,%.3f,%.8f,%.8f,%.3f,%.3f\n',...
        PTID,E,N,Lat,Lon,h,d);
end
fclose(fid);

%%
dataname = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\01_CONTROLPROC\20180412_WHALEPOINT_Control\sonar\20180328_WhlPnt_SONAR_UTM20_NAD83ellip.csv';
trimmedgood = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\01_CONTROLPROC\20180412_WHALEPOINT_Control\sonar\WHALE_FINAL_TRIMMED.csv';
dat = importdata(dataname);
lines = cellfun(@(x) str2double(split(x,',')),dat(7:end),'UniformOutput',false);
alldata = cell2mat(lines')';

fid = fopen(trimmedgood,'w+t');
fprintf(fid,'PtID,EAST,NORTH,LAT,LON,ELEVATION,DEPTH\n');
for i=1:size(alldata,1)
    PTID = alldata(i,1);
    E = alldata(i,3);
    N = alldata(i,2);
    h = alldata(i,4);
    d = alldata(i,5);
    [Lat,Lon] = utm2deg(E,N,'20 N');
    fprintf(fid,'%.0f,%.3f,%.3f,%.8f,%.8f,%.3f,%.3f\n',...
        PTID,E,N,Lat,Lon,h,d);
end
fclose(fid);

%%
dataname = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\01_CONTROLPROC\20180411_RODBAY_Control\Sonar\20180330_ROD_SONAR_UTM20_NAD83ellip.csv';
trimmedgood = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\01_CONTROLPROC\20180411_RODBAY_Control\Sonar\ROD_FINAL_TRIMMED.csv';
dat = importdata(dataname);
lines = cellfun(@(x) str2double(split(x,',')),dat(7:end),'UniformOutput',false);
alldata = cell2mat(lines')';

fid = fopen(trimmedgood,'w+t');
fprintf(fid,'PtID,EAST,NORTH,LAT,LON,ELEVATION,DEPTH\n');
for i=1:size(alldata,1)
    PTID = alldata(i,1);
    E = alldata(i,3);
    N = alldata(i,2);
    h = alldata(i,4);
    d = alldata(i,5);
    [Lat,Lon] = utm2deg(E,N,'20 N');
    fprintf(fid,'%.0f,%.3f,%.3f,%.8f,%.8f,%.3f,%.3f\n',...
        PTID,E,N,Lat,Lon,h,d);
end
fclose(fid);

%%
fname = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\03_DELIVERABLES\01_GEOSPATIAL\01_CONTROL\20180322_BUCK_GNSS.csv';
fname2 = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\03_DELIVERABLES\01_GEOSPATIAL\01_CONTROL\20180322_BUCK_GNSS_2.csv';

dat = importdata(fname);

fid = fopen(fname2,'w+t');
fprintf(fid,'PtID,EAST,NORTH,LAT,LON,ELEVATION\n');
for i=2:size(dat.textdata,1)
    PTID = dat.textdata{i,1};
    Lat = dms2degrees(str2double((split(dat.textdata{i,2},' ')')));
    Lon = dms2degrees(str2double((split(dat.textdata{i,3},' ')')));
    h = dat.data(i-1);
    [E,N]=deg2utm(Lat,Lon);
    fprintf(fid,'%s,%.3f,%.3f,%.8f,%.8f,%.3f\n',...
        PTID,E,N,Lat,Lon,h);
end
fclose(fid);
% %% 
% allnames = dirname('P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\03_DELIVERABLES\01_GEOSPATIAL\01_CONTROL\*.csv');
% 
% for i=1:numel(allnames)
%    [dname,fname,ext] = fileparts(allnames{i});
%    newname = [dname '/reformat/' fname ext];
%    data = importdata(allnames{i});
%    clear PTID E N Lat Lon h d o
%    if strcmp(fname(end-1:end),'SS') % GNSS
%        for j=1:size(data.textdata,1)-1
%            PTID{j}=data.textdata{j+1,1};
%        end
%        E = data.data(:,1);
%        N = data.data(:,2);
%        Lat = data.data(:,3);
%        Lon = data.data(:,4);
%        h = data.data(:,5);
%        d = nan(size(h));
%        o = nan(size(h));
%    elseif strcmp(fname(end-1:end),'TS') % TS
%        for j=1:size(data.textdata,1)-1
%            PTID{j}=data.textdata{j+1,1};
%            E(j)=str2double(data.textdata{j+1,2});
%            N(j) = str2double(data.textdata{j+1,3});
%            Lat(j) = dms2degrees(str2double(split(data.textdata{j+1,5},'-'))');
%            Lon(j) = dms2degrees(str2double(split(data.textdata{j+1,6}(2:end),'-'))');
%            o(j) = str2double(data.textdata{j+1,4});
%        end
%         h = data.data(:,1);
%         d = nan(size(h));
% 
%    elseif strcmp(fname(end-1:end),'AR') % SONAR
%        for j=1:size(data.data,1)
%             PTID{j} = sprintf('%.0f',data.data(j,1));
%        end
%        E = data.data(:,2);
%        N = data.data(:,3);
%        Lat = data.data(:,4);
%        Lon = data.data(:,5);
%        h = data.data(:,6);
%        d = data.data(:,7);
%        o = nan(size(h));
%    end
%    % OUTPUT FILE
%    fid = fopen(newname,'w+t');
%    fprintf(fid,'PTID,EAST,NORTH,LAT,LON,ELLIPSOID_ELEV,ORTHOMETRIC_ELEV,SONARDEPTH\n');
% 
%    for j=1:numel(E)
%         fprintf(fid,'%s,%.3f,%.3f,%.8f,%.8f,',...
%         PTID{j},E(j),N(j),Lat(j),Lon(j));
%         if isnan(h(j))
%            fprintf(fid,' ,'); 
%         else
%            fprintf(fid,'%.3f,',h(j));
%         end
%         
%         if isnan(o(j))
%            fprintf(fid,' ,'); 
%         else
%            fprintf(fid,'%.3f,',o(j));
%         end
%         
%         if isnan(d(j))
%            fprintf(fid,' \n'); 
%         else
%            fprintf(fid,'%.3f\n',d(j));
%         end
%    end
%    fclose(fid);
% end
    
%% Fix Longitude
dname = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\03_DELIVERABLES\01_GEOSPATIAL\01_CONTROL';
fnames = dirname([dname '/*.csv']);

for i=1:numel(fnames)
    [~,justname]=fileparts(fnames{i});
    newname = [justname '.csv'];
    
    data = readControlData(fnames{i});
   
   PTID = data.id;
   E = data.e;
   N = data.n;
   Lat = data.lat;
   Lon = data.lon;
   h = data.ellip;
   d = data.depth;
   o = data.orth;
   
   if Lon>0
      Lon = Lon*-1; 
   end
   
   fid = fopen(newname,'w+t');
   fprintf(fid,'PTID,EAST,NORTH,LAT,LON,ELLIPSOID_ELEV,ORTHOMETRIC_ELEV,SONARDEPTH\n');
   
   for j=1:numel(E)
       fprintf(fid,'%s,%.3f,%.3f,%.8f,%.8f,',...
           PTID{j},E(j),N(j),Lat(j),Lon(j));
       if isnan(h(j))
           fprintf(fid,' ,');
       else
           fprintf(fid,'%.3f,',h(j));
       end
       
       if isnan(o(j))
           fprintf(fid,' ,');
       else
           fprintf(fid,'%.3f,',o(j));
       end
       
       if isnan(d(j))
           fprintf(fid,' \n');
       else
           fprintf(fid,'%.3f\n',d(j));
       end
   end
   fclose(fid);
end
%% Apply Sonar Depths
data = readControlData('P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\03_DELIVERABLES\01_GEOSPATIAL\01_CONTROL\20180330_RODBAY_SONAR.csv');
outname = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\03_DELIVERABLES\01_GEOSPATIAL\01_CONTROL\20180330_RODBAY_SONAR_APPLIEDDEPTH.csv';

fid=fopen(outname,'w+t');
fprintf(fid,'PTID,EAST,NORTH,LAT,LON,ELLIPSOID_ELEV,ORTHOMETRIC_ELEV,SONARDEPTH\n');
for i=1:numel(data.id)
   fprintf(fid,'%s,%.3f,%.3f,%.9f,%.9f,%.3f, ,%.3f\n',...
       data.id{i},data.e(i),data.n(i),data.lat(i),data.lon(i),data.ellip(i)-data.depth(i),data.depth(i));
end

fclose(fid);
    
%% Apply Offset
OFFSET = 0.765;

fid=fopen('P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\03_DELIVERABLES\01_GEOSPATIAL\01_CONTROL\20180330_RODBAY_SONAR_FIXED.csv','w+t');
fprintf(fid,'PTID,EAST,NORTH,LAT,LON,ELLIPSOID_ELEV,ORTHOMETRIC_ELEV,SONARDEPTH\n');
for i=1:numel(data.id)
   fprintf(fid,'%s,%.3f,%.3f,%.9f,%.9f,%.3f, ,%.3f\n',...
       data.id{i},data.e(i),data.n(i),data.lat(i),data.lon(i),data.ellip(i)+OFFSET,data.depth(i));
end

fclose(fid);
    
    