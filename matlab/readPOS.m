function posdata = readPOS(fname)
% READPOS reads the pos file generated from RTKlib
%   Reads all of the data assuming a fixed file format, if output with
%   different columns, this code will fail.  
% 
% Inputs:
%   - fname : filename *.pos
% 
% Outputs:
%   - posdata : structure containing the header and data 
% 
% Examples:
%   fname = 'exampleFiles/examplePOS/example.pos';
%   posdata = readPOS(fname);
% 
% Dependencies:
%   - n/a
% 
% Toolboxes Required:
%   - n/a
% 
% Author        : Richie Slocum
% Email         : richie@cormorantanalytics.com
% Date Created  : 12-Mar-2018
% Date Modified : 12-Mar-2018
% Github        : https://github.com/hokiespurs/USVI-March

%% Read data from a POS file generated from RTKLIB
fid = fopen(fname,'r');
alldata = fread(fid,'*char');
fclose(fid);

alllines = strsplit(alldata','\n');
nlines = numel(alllines);

%% Determine Header Start:Stop
isComment = cellfun(@(x) ~isempty(x) && x(1)=='%',alllines);
if any(isComment)
    indHeader = 1:find(isComment,1,'last');
    indData   = find(isComment,1,'last')+1:nlines;
else
    indHeader = [];
    indData = 1:nlines;
end
%% Read Header
% future versions could parse important things out here
posdata.header = alllines(indHeader)';

%% Read Data
% assumes standard format pos file
datalines = alllines(indData);
posdata.data.tgps              = cellfun(@(x) getTime(x),datalines)';
posdata.data.tgpsSecondsOfWeek = secondsofweek(posdata.data.tgps);
posdata.data.lat               = cellfun(@(x) getNums(x,3),datalines)';
posdata.data.lon               = cellfun(@(x) getNums(x,4),datalines)';
posdata.data.height            = cellfun(@(x) getNums(x,5),datalines)';
posdata.data.Q                 = cellfun(@(x) getNums(x,6),datalines)';
posdata.data.ns                = cellfun(@(x) getNums(x,7),datalines)';
posdata.data.sdn               = cellfun(@(x) getNums(x,8),datalines)';
posdata.data.sde               = cellfun(@(x) getNums(x,9),datalines)';
posdata.data.sdu               = cellfun(@(x) getNums(x,10),datalines)';
posdata.data.sdne              = cellfun(@(x) getNums(x,11),datalines)';
posdata.data.sdeu              = cellfun(@(x) getNums(x,12),datalines)';
posdata.data.sdun              = cellfun(@(x) getNums(x,13),datalines)';
posdata.data.age               = cellfun(@(x) getNums(x,14),datalines)';
posdata.data.ratio             = cellfun(@(x) getNums(x,15),datalines)';

end

function y = getNums(X,colnum)
%% Parse numbers from a specified column of a delimeted string
Xvals = strsplit(X);
if numel(Xvals)>= colnum
    y = str2double(Xvals{colnum});
else
    y = nan;
end

end

function t = getTime(X)
%% converts the gps time into matlab datenum
STRFORMAT = 'yyyy/mm/dd HH:MM:ss.fff';

if numel(X)>=23
    t = datenum(X(1:23),STRFORMAT);
else
    t = nan;
end

end

function tseconds = secondsofweek(tdatenum)
%% Compute the time in seconds from start of week
tsecondsOfDay = (tdatenum-floor(tdatenum))*24*60*60;
          
dayofweek = weekday(tdatenum) - 1; % 0 = sunday, 6 = saturday

tseconds = tsecondsOfDay + dayofweek * 60*60*24;

end