function findhorizon(f,cx,cy,totpixx,totpixy,roll, pitch, yaw, Xc, Yc, Zc)
%%
totpixx = 4000;
totpixy = 3000;
f = 4000;

yaw = 200;
pitch = 90;
roll = 0;

%


ifov = atan2d(1,f);
vfov = ifov*totpixy;
hfov = ifov*totpixx;

az_center = yaw;
el_center = pitch;
cornerazel = [ hfov/2  vfov/2;
               hfov/2 -vfov/2;
              -hfov/2 -vfov/2;
              -hfov/2  vfov/2];

R = [cosd(roll) -sind(roll); sind(roll) cosd(roll)];

rotazel = cornerazel * R;

finalazel = [az_center el_center] + rotazel;
%% Computer Intersects
% x = x1+(x2-x1)*T;
% 90 = y1+(y2-y1)*T;
finalazel = [finalazel;finalazel];
for i=1:4
    x1 = finalazel(i,1);
    y1 = finalazel(i,2);
    x2 = finalazel(i+1,1);
    y2 = finalazel(i+1,2);
   
    T(i) = (90-y1)/(y2-y1);
end

%% Plot
figure(10);clf
plot([finalazel(:,1); finalazel(1,1)],[finalazel(:,2); finalazel(1,2)],'r-');
hold on
plot([-180 540],[0 0],'k-');
plot([-180 540],[90 90],'k--');
plot([-180 540],[-90 -90],'k--');
plot([0 0],[-180 180],'b');
plot([360 360],[-180 180],'b');
plot(az_center,el_center,'r*');

axis([-90 360+90 -180 180]);
grid on
xlabel('Azimuth');
ylabel('Elevation');

end
