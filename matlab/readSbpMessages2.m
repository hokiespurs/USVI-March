function sbp = readSbpMessages2(fname,sbp2reportpath)
%%
SENDERID = 39016;

if nargin==1
   sbp2reportpath = ''; 
end
%% Convert SBP
syscmd = [sbp2reportpath 'sbp2report.exe "' fname '"'];
syscmd = strrep(syscmd,'/','\');
[status,cmdout] = system(syscmd);

%% Read SBP Messages
[dname,justname,~]=fileparts(fname);
csvname = [justname '-msg.csv'];
fid = fopen(csvname);
alllines= strsplit(fread(fid,'*char')','\n');
fclose(fid);

% only find external events
badind = cellfun(@(x) findbadinds(x),alllines);

alllines(badind)=[];

% remove bad lines
sendid = cellfun(@(x) getnum(x,1),alllines);
badind = isnan(sendid) | SENDERID~=SENDERID;
alllines(badind)=[];

msgidnum = cellfun(@(x) getnum(x,2),alllines);
[C,ind]=unique(msgidnum);
msgdata = cellfun(@getdata,alllines,'UniformOutput',false);
msgtow = cellfun(@(x) getnum(x,6),alllines);

% parse each unique message into a structure
for i=1:numel(C)
   msgname = getmsgname(alllines{ind(i)});
   msgname = strrep(msgname,'-','_');
   dataind = msgidnum==C(i);
   try
       eval(['sbp.' msgname '.data = msgdata(dataind)'';' ]);
       eval(['sbp.' msgname '.tow = msgtow(dataind)'';' ]);
   catch
       warning('couldnt save MSG = "%s" data to sbp structure\n',msgname);
   end
end

% parse EXT_EVENT
if exist('sbp','var')
    if isfield(sbp,'EXT_EVENT')
        [sbp.EXT_EVENT.isgood, sbp.EXT_EVENT.isfalling]=...
            cellfun(@(x) parseEXTEVENT(x),sbp.EXT_EVENT.data);
    end
end

%% Remove the converted SBP files
TEMPFILES = {'-alt.plt','-bsln.plt','-errors.bin','-ins.csv','-msg.csv',...
    '-spd.plt','-stats.txt','-svs.plt','-trj.plt','-trk.csv','.csv','.kml'};

for i=1:numel(TEMPFILES)
    delete([justname TEMPFILES{i}]);
end

end

function [isgood, isfalling] = parseEXTEVENT(x)

sx = strsplit(x,' ','CollapseDelimiters',false);
if numel(sx)>4
   isgood = strcmp(sx{2},'Good');
   isfalling = strcmp(sx{5}(1:4),'Fall');
else
   isgood = false;
   isfalling = false;
end

end

function val = getnum(x,n)
% get numerical data from a string and column n
sx = strsplit(x,',','CollapseDelimiters',false);

if numel(sx)>=n
   val = str2double(sx{n});
else
   val = nan; 
end

end

function msgname = getmsgname(x)
% get message name from a string
sx = strsplit(x,',','CollapseDelimiters',false);

if numel(sx)>2
   msgname = sx{4};
else
   msgname = 'na'; 
end

end

function data = getdata(x)
% get string data from column 7
sx = strsplit(x,',','CollapseDelimiters',false);

if numel(sx)>=7
    data = sx{7};
else
    data = '';
end


end