% tag all images
clc
close all
[~,b]=dirname('P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\01_RAWDATA\20180325_BUCK\02_UAS');
b([6 8 10])= [];
[~,d]=dirname('P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\01_RAWDATA\20180328_WHALEPOINT\02_UAS');

foldernames = [b; d];

for i=1:numel(foldernames)
    try
        piksisbp = dirname([foldernames{i} '\05_CARRIERPHASEGNSS\*.sbp']);
        imFolder = [foldernames{i} '\02_MAPIMAGES'];
        trajName = [foldernames{i} '\05_CARRIERPHASEGNSS\ppk\ppkproc.pos'];
        savedir  = [foldernames{i} '\05_CARRIERPHASEGNSS\imagetags'];
        mkdir(savedir);
        tagImages(piksisbp{1}, imFolder, trajName, savedir);
        fprintf('success: %s\n',imFolder);
    catch
        fprintf('failed on: %s\n',imFolder);
    end
end