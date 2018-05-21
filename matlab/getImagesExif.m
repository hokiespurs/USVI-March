function exif = getImagesExif(imNames)
% get exif info from cell array of image names

nImages = numel(imNames);
imDateTime = nan(nImages,1);
imFocalLength = nan(nImages,1);
imIso = nan(nImages,1);
imExposureTime = nan(nImages,1);
imFNumber = nan(nImages,1);
for i=1:nImages
   meta = imfinfo(imNames{i});
   dc = meta.DigitalCamera;
   imDateTime(i) = datenum(dc.DateTimeDigitized,'yyyy:mm:dd HH:MM:ss');
   imFocalLength(i) = dc.FocalLength;
   imIso(i) = dc.ISOSpeedRatings;
   imExposureTime(i) = dc.ExposureTime;
   imFNumber(i) = dc.FNumber;
   [~,exif.fname{i},~] = fileparts(imNames{i});
end
imtow = secondsofweek(imDateTime);

%
exif.nImages = nImages;
exif.imDateTime = imDateTime;
exif.imtow = imtow;
exif.imFocalLength = imFocalLength;
exif.imISO = imIso;
exif.imExposureTime = imExposureTime;
exif.imFNumber = imFNumber;
end