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
        if i<8
            Zoffset = 0.381;
        else
            Zoffset = 0.344;
        end
        
        maindir = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\05_S900DNG\';
        [~,dname1] = fileparts(fileparts(fileparts(foldernames{i})));
        [~,dname2] = fileparts(foldernames{i});
        savedir2 = [maindir dname1 '/' dname2 '/imagetags/'];
        mkdir(savedir2);
        tagImages(piksisbp{1}, imFolder, trajName, savedir2, Zoffset);
        tagImages(piksisbp{1}, imFolder, trajName, savedir, Zoffset);
        
        fprintf('success: %s\n',imFolder);
    catch E
        fprintf('failed on: %s\n',imFolder);
    end
end