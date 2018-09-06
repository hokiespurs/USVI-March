imnames = dirname('P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\01_RAWDATA/*/02*/*/02*/*.dng',9);
%%
maindir = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\05_S900DNG\';
for i=1:numel(imnames)
[~,dname1] = fileparts(fileparts(fileparts(fileparts(fileparts(imnames{i})))));
[~,dname2]=fileparts(fileparts(fileparts(imnames{i})));
[~,dngname,ext]=fileparts(imnames{i});
fromname = imnames{i};
toname = [maindir dname1 '/' dname2 '/' dngname ext];
if ~exist(toname,'file')
   fprintf('%s\n',toname);
   movefile(fromname,toname);
else
   warning('%s already exists\n',dngname);
end
end

%%
[a,b]=dirname('P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\01_RAWDATA\20180325_BUCK\02_UAS');
b([6 8 10])= [];
[c,d]=dirname('P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\01_RAWDATA\20180328_WHALEPOINT\02_UAS');
foldernames = [b; d];