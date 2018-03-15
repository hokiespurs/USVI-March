function tagImages(piksisbp, imFolder, trajName, savedir)
%% 
clc
if nargin==0
    fprintf('Select SBP file\n');
    [piksisbp,dname] = uigetfile('*.sbp','Select SBP File');
    piksisbp = [dname piksisbp];
    defaultdir = fileparts(fileparts(dname));
    
    fprintf('Select Folder with Images\n');
    imFolder = uigetdir(defaultdir,'Select Folder with Images');
    
    fprintf('Select POS file\n');
    [trajName, dname] = uigetfile('*.pos','Select POS file',defaultdir);
    trajName = [dname trajName];
    
    fprintf('Select Save Directory\n');
    savedir  = uigetdir(defaultdir,'Select Save Directory');
end
%% Test Dataset
% piksisbp = 'exampleFiles/exampleSBP/FlightA.sbp';
% imFolder = 'exampleFiles/exampleImages/';
% trajName = 'exampleFiles/examplePOS/FlightA.pos';
% savedir  = 'C:\Users\slocumr\github\USVI-March\matlab';

%% Make sure there are some images first
imNames = dirname([imFolder '/*.jpg']);
if numel(imNames)==0
   fprintf('Image Folder: %s\n',[imFolder '/*.jpg']);
   error('No Images in that Folder'); 
end
%% Read MSGCSV_EXTEVENT
fprintf('Reading SBP (This can take a minute)...%s\n',datestr(now));
sbp = readSbpMessages(piksisbp);
nTriggers = numel(sbp.EXT_EVENT.data);
% Number of triggers should be even (every falling followed by a rising)
if mod(nTriggers,2)==1 
   warning(['The number of triggers should be even...',...
       'Attempting to clip the bad trigger']);
   if sbp.EXT_EVENT.isfalling(1) == 0 %assume the first trigger is bad
      sbp.EXT_EVENT.data = sbp.EXT_EVENT.data(2:end);
      sbp.EXT_EVENT.tow = sbp.EXT_EVENT.tow(2:end);
      sbp.EXT_EVENT.isgood = sbp.EXT_EVENT.isgood(2:end);
      sbp.EXT_EVENT.isfalling = sbp.EXT_EVENT.isfallin(2:end);
   end
end
% The time should be "good" for all data
if any(~sbp.EXT_EVENT.isgood)
    nbad = sum(~sbp.EXT_EVENT.isgood);
    indbad = find(~sbp.EXT_EVENT.isgood);
    
    warning('%g bad time triggers',nbad);
    fprintf('Bad Triggers (odd = falling edge)\n');
    fprintf(' - Trigger%03g\n',indbad);
end

triggerStartTow = sbp.EXT_EVENT.tow(1:2:end);

%% Get Image Names and Metadata
fprintf('Getting Image Metadata...%s\n',datestr(now));
imNames = dirname([imFolder '/*.jpg']);
exif = getImagesExif(imNames);
printImagesExif(exif);

if exif.nImages ~= numel(triggerStartTow)
   error('nTriggers (%g) \neq nImages(%g)',numel(triggerStartTow),exif.nImages);
end

%% Read POS Trajectory
fprintf('Reading POS Trajectory...%s\n',datestr(now));
posdata = readPOS(trajName);

%% Interpolate Trigger Times
camdata = interpPosdata(posdata,triggerStartTow);

%% Convert LL to UTM
[camdata.utme, camdata.utmn] = deg2utm(camdata.lat,camdata.lon);

%% Save Data
fprintf('Exporting Data...%s\n',datestr(now));
fid = fopen([savedir '/taggedImages.csv'],'w+t');
printTagTriggers(exif,camdata,fid)
fclose(fid);

%% Make Plots
fprintf('Generating Figures...%s\n',datestr(now));
% top down colored by elevation, magenta camera positions, text for camera
% name on every 5th image
f = figure(1);clf;
set(f,'Units','Normalize','Position',[0.1 0.1 0.8 0.8]);
scatter(posdata.data.lon,posdata.data.lat,20,posdata.data.height,'filled');
hold on
plot(camdata.lon,camdata.lat,'m*','markersize',20);
text(camdata.lon(1:2:end),camdata.lat(1:2:end),exif.fname(1:2:end))
xlabel('Longitude');
ylabel('Latitude');
c = colorbar;
ylabel(c,'Elevation');
grid on
saveas(f,[savedir '/plot_topdown.png']);

% elevation, camera name on x axis
f2 = figure(2);
set(f2,'Units','Normalize','Position',[0.1 0.1 0.8 0.8]);
clf
plot(camdata.height,'.-','markersize',10);
ylabel('Elevation');
xlabel('Image Name');
xticks(1:exif.nImages)
xticklabels(exif.fname)
xtickangle(90)
grid on
saveas(f2,[savedir '/plot_elevation.png']);

end

function printTagTriggers(exif,camdata,fid)
% print a csv with all camera data from pos file
if nargin==2
    fid = 1;
end

fprintf(fid,' N , Image Name, Lat, Lon, UTMe, UTMN, Height, sdn,sde,sdu,sdne,sdeu,sdun\n');
for i=1:exif.nImages
   fprintf(fid,'%3g, %s.jpg, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f\n',i,...
       exif.fname{i},camdata.lat(i), camdata.lon(i), camdata.utme(i), ...
       camdata.utmn(i), camdata.height(i), camdata.sdn(i), camdata.sde(i), ...
       camdata.sdu(i), camdata.sdne(i), camdata.sdeu(i), camdata.sdun(i));
       
end

end

function camdata = interpPosdata(posdata,t)
%%
F = fieldnames(posdata.data);
camdata = [];
for i=1:numel(F)
    x = posdata.data.tgpsSecondsOfWeek;
    y = eval(['posdata.data.' F{i}]);
    indgood = ~isnan(x) & ~isnan(y) & isnumeric(x) & isnumeric(y);
    xi = t;
    yi = interp1(x(indgood),y(indgood),xi);
    eval(['camdata.' F{i} '=yi;']);
end

end
