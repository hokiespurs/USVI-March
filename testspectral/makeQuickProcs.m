% %% Set processing XML 
% %   - only add gcps if they exist
% xmlname_nogcps = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\06_PROCIMAGES\0320_BUCK_MAVIC_200FT\06_QUICKPROC\quickprocnogcps.xml';
% xmlname_gcps = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\06_PROCIMAGES\0320_BUCK_MAVIC_200FT\06_QUICKPROC\quickprocgcps.xml';
% 
% [~,dnames] = dirname('P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\06_PROCIMAGES\*',0);
% 
% for i=2:numel(dnames)
%     dname = dnames{i};
%     if ~exist([dname '/06_QUICKPROC'],'dir')
%         mkdir([dname '/06_QUICKPROC']);
%     end
%     if exist([dname '\03_IMAGEMARKERS\gcps.xml'],'file')
%         destination = [dname '/06_QUICKPROC/quickprocgcps.xml'];
%         copyfile(xmlname_gcps,destination);
%     else
%         destination = [dname '/06_QUICKPROC/quickprocnogcps.xml'];
%         copyfile(xmlname_nogcps,destination);
%     end
%     
% end

%% Test
[~,dnames] = dirname('P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\06_PROCIMAGES\*',0);

for i=1:numel(dnames)
   dname = dnames{i};
   if ~exist([dname '/06_QUICKPROC'],'dir')
        mkdir([dname '/06_QUICKPROC']);
   end
   if exist([dname '\03_IMAGEMARKERS\gcps.xml'],'file')
       name = [dname '/06_QUICKPROC/gcps'];
       controlname = '03_IMAGEMARKERS/gcps.xml';
       outputroot = 'gcps';
   else
       name = [dname '/06_QUICKPROC/nogcps']; 
       controlname = '';
       outputroot = 'nogcps';
   end
   
   [~,justname,~]=fileparts(dname);
   trajname = '02_TRAJECTORY/imageposUTM.xml';
   
   downsamplenames = dirname([dname '/05_DOWNSAMPLE/*.csv']);
   [~,downsamples] = filepartsstruct(downsamplenames);
   
   if numel(downsamples)==0
       procnames = [];
       procnames{1} = '';
   else
       procnames = downsamples;
   end
   
   for j=1:numel(procnames)
       if ~strcmp(procnames{j},'')
           useimages = importdata([dname '/05_DOWNSAMPLE/' procnames{j} '.csv']);
           imnamesfull = dirname([dname '/01_IMAGES/']);
           [~,imnames] = filepartsstruct(imnamesfull,1);
           
           imagestouse = contains(imnames,useimages)';
       else
           imagestouse = '';
       end
       
       if contains(name,'MAVIC')
           camposacc = 1;
       else
           camposacc = 1/20;
       end
       
       args = {'projectname',[strrep(justname,'_','') '_' procnames{j} '_trajacc'],...
               'trajectory',trajname,...
               'control',controlname,...
               'imagestouse',imagestouse,...
               'outputroot',['./' outputroot procnames{j} '_trajacc'],...
               'camposacc',camposacc};
           
       writeprocsettings([name procnames{j} '_trajacc.xml'],args{:})
   end
    
end

%% Do NOGCPS no matter what
[~,dnames] = dirname('P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\06_PROCIMAGES\*',0);

for i=1:numel(dnames)
   dname = dnames{i};
   if ~exist([dname '/06_QUICKPROC'],'dir')
        mkdir([dname '/06_QUICKPROC']);
   end
   name = [dname '/06_QUICKPROC/nogcps'];
   controlname = '';
   outputroot = 'nogcps';

   [~,justname,~]=fileparts(dname);
   trajname = '02_TRAJECTORY/imageposUTM.xml';
   
   downsamplenames = dirname([dname '/05_DOWNSAMPLE/*.csv']);
   [~,downsamples] = filepartsstruct(downsamplenames);
   
   if numel(downsamples)==0
       procnames = [];
       procnames{1} = '';
   else
       procnames = downsamples;
   end
   
   for j=1:numel(procnames)
       if ~strcmp(procnames{j},'')
           useimages = importdata([dname '/05_DOWNSAMPLE/' procnames{j} '.csv']);
           imnamesfull = dirname([dname '/01_IMAGES/']);
           [~,imnames] = filepartsstruct(imnamesfull,1);
           
           imagestouse = contains(imnames,useimages)';
       else
           imagestouse = '';
       end
       
       if contains(name,'MAVIC')
           camposacc = 1;
       else
           camposacc = 1/20;
       end
       
       args = {'projectname',[strrep(justname,'_','') '_' procnames{j} '_trajacc'],...
               'trajectory',trajname,...
               'control',controlname,...
               'imagestouse',imagestouse,...
               'outputroot',['./' outputroot procnames{j} '_trajacc'],...
               'camposacc',camposacc};
           
       writeprocsettings([name procnames{j} '_trajacc.xml'],args{:})
   end
    
end