%% Make Table
DNAME = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\06_PROCIMAGES\';

%%
id = 42+[1:numel(flightfolders)];

[~,flightfolders] = dirname('*SOLO*',0,DNAME);

clc;
fprintf('ID, Date, Folder, Altitude(ft), nImages\n')
for i=1:numel(flightfolders)
    [~,folderstr,~] = fileparts(flightfolders{i});
    
    strmmdd = folderstr(1:4);
    
    trajcsv = importdata([flightfolders{i} '/02_TRAJECTORY/imageposUTM.csv']);
    z = trajcsv.data(:,5)+40;
    zft = z/0.3048;
    zmedian = median(zft);
    
    nimages = numel(z);
    
    fprintf('%.0f,%s,%s,%.0f,%.0f\n',id(i),[strmmdd(1:2) '/' strmmdd(3:4) '/2018'],folderstr,zmedian,nimages);
end

