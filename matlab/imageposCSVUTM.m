function imageposCSVUTM
[~,dnames] = dirname('P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\06_PROCIMAGES\*MAVIC*',0);
for i=1:numel(dnames)
   traj = importdata([dnames{i} '/02_TRAJECTORY/imagepos.csv']);
   
   trajNames = traj.textdata(2:end,1);

   lat = traj.data(:,2);
   lon = traj.data(:,1);
   [utmX,utmY]=deg2utm(lat,lon);
   Z = traj.data(:,3);
   
   fid = fopen([dnames{i} '/02_TRAJECTORY/imageposUTM.csv'],'w+t');
   fprintf(fid,'%s,%s,%s,%s,%s,%s,%s,%s,%s\n','ImageName','Lon','Lat','UTME','UTMN','Z','stdX','stdY','stdZ');
   for j=1:numel(trajNames)
        fprintf(fid,'%s,%.9f,%.9f,%.3f,%.3f,%.3f,%.0f,%.0f,%.0f\n',trajNames{j},...
            lon(j),lat(j),utmX(j),utmY(j),Z(j),2,2,5);
   end
   fclose(fid);

end

[~,dnames] = dirname('P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\06_PROCIMAGES\*S900*',0);
for i=1:numel(dnames)
   traj = importdata([dnames{i} '/02_TRAJECTORY/imagepos.csv']);
   
   trajNames = traj.textdata(2:end,2);

   lat = traj.data(:,1);
   lon = traj.data(:,2);
   utmX = traj.data(:,3);
   utmY = traj.data(:,4);
   Z = traj.data(:,5);
   stdX = traj.data(:,6);
   stdY = traj.data(:,7);
   stdZ = traj.data(:,8);
   
   fid = fopen([dnames{i} '/02_TRAJECTORY/imageposUTM.csv'],'w+t');
   fprintf(fid,'%s,%s,%s,%s,%s,%s,%s,%s,%s\n','ImageName','Lon','Lat','UTME','UTMN','Z','stdX','stdY','stdZ');
   for j=1:numel(trajNames)
        fprintf(fid,'%s,%.9f,%.9f,%.3f,%.3f,%.3f,%.4f,%.4f,%.4f\n',trajNames{j},...
            lon(j),lat(j),utmX(j),utmY(j),Z(j),stdX(j)*10,stdY(j)*10,stdZ(j)*10);
   end
   fclose(fid);
   
   fid = fopen([dnames{i} '/02_TRAJECTORY/readmeStd.txt'],'w+t');
   fprintf(fid,'std(X,Y,Z) are from the PPK output, and scaled by 10 to be more realistic\n'); 
   fclose(fid);
end

end