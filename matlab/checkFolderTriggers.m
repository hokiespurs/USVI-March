function checkFolderTriggers(foldernames)
% check foldernames to see how many triggers and images are in each
%
%
%
%
clc
close all
[~,b]=dirname('P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\01_RAWDATA\20180325_BUCK\02_UAS');
b([6 8 10])= [];
[~,d]=dirname('P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\01_RAWDATA\20180328_WHALEPOINT\02_UAS');

foldernames = [b; d];

for i = 1:numel(foldernames)
    dname = foldernames{i};
    try
        imfolder = [dname '/02_MAPIMAGES'];
        imnamesA = dirname([imfolder '/*.arw']);
        nImages = numel(imnamesA);
        exifA = getImagesExif(imnamesA);
        
        imfolder = [dname '/03_EXTRAIMAGES'];
        imnamesB = dirname([imfolder '/*.arw']);
        nExtraImages = numel(imnamesB);
        exifB = getImagesExif(imnamesB);
        
        sbpname = dirname([dname '/05_CARRIERPHASEGNSS/*.sbp']);
        sbpname = sbpname{1};
        
        warning off
        sbp = readSbpMessages2(sbpname);
        warning on
        nTriggers = numel(sbp.EXT_EVENT.data);
        
        [~,justdname,~]=fileparts(dname); 
        fprintf('%s\n%s\n',repmat('-',1,50),justdname);
        fprintf('Ntriggers = %.1f\n',nTriggers/2);
        fprintf('Nimages = %.0f\n',nImages);
        fprintf('NExtraImages = %.0f\n',nExtraImages);
        
        f = figure(i);clf;
        plot(diff(sbp.EXT_EVENT.tow(1:2:end)),'b.-');
        hold on
        plot(diff(exifA.imtow),'r.-');
        title(fixfigstring(justdname),'fontsize',18,'interpreter','latex');

        
    catch
        
    end
end











end