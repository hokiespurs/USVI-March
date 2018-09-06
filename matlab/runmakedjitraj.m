[~,dnames] = dirname('P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\06_PROCIMAGES\*MAVIC*',0);
Zoffset = 1; % meter above sealevel
Zellip = -41.26; % Tide Level

for i=1:numel(dnames)
   dname = dnames{i};
   [~,justname,~]=fileparts(dname);
   imnames = dirname([dnames{i} '/01_IMAGES/*.jpg']);
   nimages = numel(imnames);

   savename = [dnames{i} '/02_TRAJECTORY/imagepos.csv'];
   makeDJItraj(imnames,savename,Zellip+Zoffset);
   readmename = [dnames{i} '/02_TRAJECTORY/readme.txt'];
   
   fid = fopen(readmename,'w+t');
   str = [];
   str{1} = 'Horizontal Lon/Lat is directly from exiftool.';
   str{2} = 'Vertical is from exif "Relative Altitude" field';
   str{3} = 'A vertical offset of -40.26 is applied to convert "Relative Altitude" to NAD83-2011 ellipsoid';
   str{4} = '  This is estimated based on takeoff position (~+1m from tide) and mean tide level (-41.26m)';
   str{5} = ' *This was used to replace of the default exif "absolute" position, due to that value having huge errors';
   clc
   fprintf(fid,'%s\n',str{:});
   fclose(fid);
   
end

%%

[~,dnames] = dirname('P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\06_PROCIMAGES\*ALLBUCK*',0);
IMFOLDER = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\02_RECOLORIMAGES\ALLBUCK';
Zoffset = 1; % meter above sealevel
Zellip = -41.26; % Tide Level

for i=1:numel(dnames)
   dname = dnames{i};
   [~,justname,~]=fileparts(dname);
   imnames = dirname([dnames{i} '/01_IMAGES/*.jpg']);
   nimages = numel(imnames);
   
   imnames_raw = imnames;
   imnames_full = imnames; 
   for j=1:numel(imnames)
       [~,justname,ext] = fileparts(imnames{j});
       justname = [justname ext];
       imnames_full{j} = justname;
       imnames_raw{j} = [IMFOLDER '\' justname(1:end-13) '\02_MAPIMAGES\' justname(end-11:end)];
   end
   
   savename = [dnames{i} '/02_TRAJECTORY/imagepos2.csv'];
   [lon,lat,z] = makeDJItraj(imnames_raw,savename,Zellip+Zoffset);
   [x,y]=deg2utm(lat,lon);
   writeOutputTrajectoryNames([dnames{i} 'imageposUTM.xml'],imnames_full,x,y,z+Zellip+Zoffset)
end