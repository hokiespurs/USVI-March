[~,dnames] = dirname('P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\06_PROCIMAGES\*MAVIC*',0);
clc;figure(1);clf
fprintf('%40s | %6s | %6s | %6s | %6s | %6s \n','Name','Actual','Median','CSV','Min','Max');
actualH = [200 400 247 300 250 250 100 200 200 328 328 328 400 100 200 200 200 200 200 175 225 300 400 400 200 200 200 200 175 225 300 400 400 400 400];

for i=1:numel(dnames)
   dname = dnames{i};
   [~,justname,~]=fileparts(dname);
   imnames = dirname([dnames{i} '/01_IMAGES/*.jpg']);
   
   traj = importdata([dnames{i} '/02_TRAJECTORY/imagepos.csv']);
   trajZ = (median(traj.data(:,3))+40.26)*3.28084;
   
   nimages = numel(imnames);
   
   I = struct('lat', NaN, 'lon', NaN, 't', NaN, 'alt', NaN, 'make', 'fail');
   I(nimages).lat = NaN;
   for j=1:nimages
       I(j) = getimageinfo(imnames{j});
   end
   lat = [I.lat];
   lon = [I.lon];
   H = [I.alt]*3.28084; %feet
   
   f = figure(1);
   plot(-lon,lat,'.-');
   hold on
   drawnow;
   fprintf('%40s | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f \n',justname,actualH(i),median(H),trajZ,min(H),max(H));
end