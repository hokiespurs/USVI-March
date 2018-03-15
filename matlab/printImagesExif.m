function printImagesExif(exif,fid)
%% Print a table of exif data
if nargin==1
   fid = 1; %default print to screen; 
end

header = {'N','Image Name','Camera Time','t-t(1) (s)', 'Av(1/s)','FNum','ISO','Focal'};
headersize = [4 10 20 10 10 10 10 10];
fprintf(fid,'\n');
for i=1:numel(header)
fprintf(fid,' %-*s |',headersize(i),header{i});
end
fprintf(fid,'\n');

for i=1:exif.nImages
   fprintf(fid,' %*g |',headersize(1),i);
   fprintf(fid,' %*s |',headersize(2),exif.fname{i});
   fprintf(fid,' %*s |',headersize(3),datestr(exif.imDateTime(i)));
   fprintf(fid,' %*.1f |',headersize(4),exif.imtow(i)-exif.imtow(1));
   fprintf(fid,' %*g |',headersize(5),1./exif.imExposureTime(i));
   fprintf(fid,' %*g |',headersize(6),exif.imFNumber(i));
   fprintf(fid,' %*g |',headersize(7),exif.imISO(i));
   fprintf(fid,' %*g |',headersize(8),exif.imFocalLength(i));
   fprintf(fid,'\n');
end





end