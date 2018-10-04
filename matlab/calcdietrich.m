function dietrich = calcdietrich(tideval, pstrajectory, sensor, sfmcompare)
% calc dietrich error for both sparse and dense
IOR = 1.33;
DODEBUG = false;
%% DENSE
xyz = [sfmcompare.Eg(:) sfmcompare.Ng(:) sfmcompare.dense.Zg(:)];

waterlevel = tideval;

ncameras = numel(pstrajectory.name);
npoints = size(xyz,1);

% convert each point into depth
h_a = waterlevel-xyz(:,3);

%
zNew = nan(size(sfmcompare.Eg));
ncams = nan(npoints,1);

% For each point
starttime = now;
for ipoint = 1:npoints
    if h_a(ipoint)>0 % point is below water
        Zcorr = nan(ncameras,1);
        elevationangle = nan(ncameras,1);
        for jcamera = 1:ncameras
            iK = sensor.K;
            iR = pstrajectory.R{jcamera};
            iT = [pstrajectory.E(jcamera); pstrajectory.N(jcamera); pstrajectory.Z(jcamera);];
            pixx = sensor.pixx;
            pixy = sensor.pixy;
            
            [~,~,~,isinframe]=isXYZinFrame(iK,iR,iT,xyz(ipoint,1),xyz(ipoint,2),xyz(ipoint,3),pixx,pixy);
            if isinframe %if camera sees the point
                % Compute angle relative to flat water (az-el)
                D = sqrt((iT(1)-xyz(ipoint,1))^2+(iT(2)-xyz(ipoint,2))^2);
                dH = iT(3)-xyz(ipoint,3);
                
                r = atan2(D,dH);
                
                elevationangle(jcamera)=r*180/pi; % just for debugging
                
                i = asin(1/IOR*sin(r));
                
                x = h_a(ipoint) * tan(r);
                
                h = x/tan(i);
                
                % Calculate Z_corr
                Zcorr(jcamera) = waterlevel - h;
                
            end
        end
        % average Z_corr
        zNew(ipoint) = nanmean(Zcorr);
        ncams(ipoint) = sum(~isnan(Zcorr));
    else
        zNew(ipoint)=waterlevel - h_a(ipoint);
        ncams(ipoint)=0;
    end
    if DODEBUG
        if mod(ipoint,50)==1
            figure(200);clf
            pcolor(zNew);shading flat
            drawnow
        end
    end
    loopStatus(starttime,ipoint,npoints,round(npoints/10));
end
dietrich.dense.corDepth = zNew;
dietrich.dense.ratio = (waterlevel-zNew)./(waterlevel-sfmcompare.dense.Zg);

%% SPARSE
xyz = [sfmcompare.Eg(:) sfmcompare.Ng(:) sfmcompare.sparse.Zg(:)];

waterlevel = tideval;

ncameras = numel(pstrajectory.name);
npoints = size(xyz,1);

% convert each point into depth
h_a = waterlevel-xyz(:,3);

%
zNew = nan(size(sfmcompare.Eg));
ncams = nan(npoints,1);

% For each point
starttime = now;
for ipoint = 1:npoints
    if h_a(ipoint)>0 % point is below water
        Zcorr = nan(ncameras,1);
        elevationangle = nan(ncameras,1);
        for jcamera = 1:ncameras
            iK = sensor.K;
            iR = pstrajectory.R{jcamera};
            iT = [pstrajectory.E(jcamera); pstrajectory.N(jcamera); pstrajectory.Z(jcamera);];
            pixx = sensor.pixx;
            pixy = sensor.pixy;
            
            [~,~,~,isinframe]=isXYZinFrame(iK,iR,iT,xyz(ipoint,1),xyz(ipoint,2),xyz(ipoint,3),pixx,pixy);
            if isinframe %if camera sees the point
                % Compute angle relative to flat water (az-el)
                D = sqrt((iT(1)-xyz(ipoint,1))^2+(iT(2)-xyz(ipoint,2))^2);
                dH = iT(3)-xyz(ipoint,3);
                
                r = atan2(D,dH);
                
                elevationangle(jcamera)=r*180/pi; % just for debugging
                
                i = asin(1/IOR*sin(r));
                
                x = h_a(ipoint) * tan(r);
                
                h = x/tan(i);
                
                % Calculate Z_corr
                Zcorr(jcamera) = waterlevel - h;
            end
        end
    % average Z_corr
    zNew(ipoint) = nanmean(Zcorr);
    ncams(ipoint) = sum(~isnan(Zcorr));
    else
        zNew(ipoint)=waterlevel - h_a(ipoint);
        ncams(ipoint)=0;
    end
    loopStatus(starttime,ipoint,npoints,round(npoints/10));
end
dietrich.sparse.corDepth = zNew;
dietrich.sparse.ratio = (waterlevel-zNew)./(waterlevel-sfmcompare.sparse.Zg);

end