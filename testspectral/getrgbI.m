function [r,g,b,I,shutter,iso,fstop]=getrgbI(imname,I,u,v,RGBAVGPAD)
[~,~,ext]=fileparts(imname);
u = round(u-RGBAVGPAD:u+RGBAVGPAD);
v = round(v-RGBAVGPAD:v+RGBAVGPAD);

try
    r = I(v,u,1);
    g = I(v,u,2);
    b = I(v,u,3);
catch
    r = nan;
    g = nan;
    b=nan;
end
r=nanmean(r(:));
g=nanmean(g(:));
b=nanmean(b(:));

%%
shutter = nan;
iso=nan;
fstop=nan;
try
    X = imfinfo(imname);
    if strcmp(ext,'.dng')
        iso=X.ISO_speed;
        fstop=str2double(X.Aperture(3:end));
        shutter=str2double(X.Shutter(3:end-4));
    else
        shutter = 1/X.DigitalCamera.ExposureTime;
        fstop = X.DigitalCamera.FNumber;
        iso = X.DigitalCamera.ISOSpeedRatings;
    end
catch
    fprintf('couldnt read camera metadata (shutter,fstop,iso)\n');
end
end