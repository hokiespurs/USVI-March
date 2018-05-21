function dat = getimageinfo(fname)
warning off
imageinfo = imfinfo(fname);
warning on

dat.lat = NaN;
dat.lon = NaN;
dat.alt = NaN;
dat.make = 'fail';
dat.t = NaN;

try
dat.lat = dms2degrees(imageinfo.GPSInfo.GPSLatitude);
catch
end

try
dat.lon = dms2degrees(imageinfo.GPSInfo.GPSLongitude);
catch
end

try
dat.alt = imageinfo.GPSInfo.GPSAltitude;
catch
end

try
dat.make = imageinfo.Make;
catch 
end

try
dat.t = datenum(imageinfo.DateTime,'yyyy:mm:dd HH:MM:ss');
catch 
end

end