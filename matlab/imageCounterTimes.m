%%
clc
ALLNAMES = 'E:\20180319_USVI_UAS_BATHY\';
[~,DNAMES] = dirname([ALLNAMES '*']);
DNAMES = DNAMES([1 3 5 6 8:16]); %change to 16 when cottongarden is in there
fprintf('%-20s\t %-35s\t %5s\t %9s\t %9s\n','FOLDER','Flight','#Im','tstart','tend');
fprintf('%s\n',repmat('-',1,80));

badprint='';
singleshots = '';
for d = 1:numel(DNAMES)
% DNAME = 'E:\20180319_USVI_UAS_BATHY\20180401_JacksBay\';
DNAME = DNAMES{d};
[~,dnameprint] = fileparts(DNAME);

[f,d]=dirname([DNAME '/02_UAS']);

for i=1:numel(d)
   try
       imdir = [d{i} '/01_RAW/02_MAPIMAGES/*.arw'];
       
       allims = dir(imdir);
      
       if isempty(allims)
          error('empty'); 
       end
       % sort allims by time
       t = datenum({allims.date}');
       if strcmp(imdir(end-3:end),'.arw')
          t = t + 4/24; 
       end
       [~,sortind]=sort(t);
       t = t(sortind);
       
       ts = t-t(1);
       ts = ts*24*60*60;
       
       
       ind = [1 find(diff(ts)>mean(diff(ts))*20)'];
       ind(end+1)=numel(t);
       for ii=2:numel(ind)
           ind_start = ind(ii-1);
           ind_end = ind(ii);
           [~,printname,~] = fileparts(d{i});
           if numel(ind)>2
               printname = ['* ' printname];
           end
           if (ind_end-ind_start+1)>3
           fprintf('%-20s\t %-35s\t %5.0f\t %9s\t %9s\n',dnameprint,printname,ind_end-ind_start+1,...
               datestr(t(ind_start),'HH:MM:SS'),datestr(t(ind_end),'HH:MM:SS'));
           else
               singleshots = [singleshots sprintf('%-20s\t , %-35s\t %5.0f\t %6s\t %6s\n',dnameprint,printname,ind_end-ind_start+1,...
               datestr(t(ind_start),'HH:MM:SS'),datestr(t(ind_end),'HH:MM'))];
           end
       end
   catch
       [~,printname,~] = fileparts(d{i});
       badprint = [badprint sprintf('%-20s\t %-35s\t %5.0f\t %6s\t %6s\n',dnameprint,printname,NaN,'','')];
   end
end
end
fprintf('\nSINGLE SHOTS\n%s\n%s\n',repmat('-',1,50),singleshots);
fprintf('\nBAD FOLDERS\n%s\n%s\n',repmat('-',1,50),badprint);
