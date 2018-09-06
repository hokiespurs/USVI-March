function make1traj()
%%
cd 

[~,dnames] = dirname('P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\06_PROCIMAGES\*S900*',0);

for i=1:numel(dnames)
   imnames = dirname([dnames{i} '/01_IMAGES/*.dng']);
   
   for j=1:numel(imnames)
      [~,justname,ext]=fileparts(imnames{j});
      imnames{j}=[justname ext];
   end
   
   trajnames = dirname('taggedImages.csv',3,dnames{i});
   data = [];
   for j=1:numel(trajnames)
       [jdata,header] = readtxtcsv(trajnames{j});
       data = [data jdata];
   end
   
   trajimnames = cellfun(@(x) x{2},data,'UniformOutput',false);
   
   isgood = ismember(trajimnames,imnames);
   
   data = data(isgood);
   mkdir([dnames{i} '/02_TRAJECTORY']);
   outname = [dnames{i} '/02_TRAJECTORY/imagepos.csv'];
   
   fprintf('Removed Images:\n');
   fprintf('  - %s\n',trajimnames{~isgood});
   
   fid=fopen(outname,'w+t');
   fprintf(fid,'%s\n',header{:}(1:end-1));
   for j=1:numel(data)
       fprintf(fid,'%s,',data{j}{1:end-1});
       fprintf(fid,'%s\n',data{j}{end}(1:end-1));
   end
   fclose(fid);
   
   %% Make Readme
   readmename = [dnames{i} '/02_TRAJECTORY/readme.txt'];
   
   fid = fopen(readmename,'w+t');
   str = [];
   str{1} = 'Data from PPK Piksi Multi';
   str{2} = 'Z offset is applied to approximate camera center';
   str{3} = 'DATUM';
   str{4} = '  Horizontal: NAD83 (2011) meters';
   str{5} = '  Vertical: NAD83 (2011) ellipsoid height meters';
   str{6} = '  Vertical: Geoid 12B when Orthometric height is present';
   
   fprintf(fid,'%s\n',str{:});
   fclose(fid);
   %% rid of old "allimagetags.csv"
   if exist([dnames{i} '/allimagetags.csv'],'file')
      delete([dnames{i} '/allimagetags.csv']);
   end
end

end

%%
function [data,header] = readtxtcsv(fname)
    fid = fopen(fname,'r');
    alldat = fread(fid,'*char');
    alllines = strsplit(alldat','\n');
    header = alllines(1);
    alllines(1)=[];
    if isempty(alllines{end})
        alllines(end)=[];
    end
    data = cellfun(@(x) strsplit(x,','),alllines,'UniformOutput',false);
    fclose(fid);
end
