function dietrich = calcdietrich(ortho, tideval, pstrajectory, sensor)
% dietrich.ratio;
% dietrich.corDepth;
IOR = 1.33;

xyz = [ortho.Eg(:) ortho.Ng(:) ortho.Zg(:)];

waterlevel = tideval;

ncameras = numel(pstrajectory.name);
npoints = size(xyz,1);

%% convert each point into depth
h_a = waterlevel-xyz(:,3);

%%
zNew = nan(npoints,1);
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
dietrich.corDepth = reshape(zNew,size(ortho.Eg));
dietrich.ratio = reshape((waterlevel-zNew)./(waterlevel-ortho.Zg(:)),size(ortho.Eg));



end