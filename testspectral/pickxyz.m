function [x,y,z]=pickxyz(base)
% allow user to pick an xy point to test spectral stuff
figure(10);clf
imagesc(base.xi,base.yi,base.rgb);
set(gca,'ydir','normal');
btn=1;
ptnum=1;
while btn==1
    [x(ptnum),y(ptnum),btn]=ginput(1);
    hold on
    plot(x(ptnum),y(ptnum),'m.','markersize',10);
    ptnum=ptnum+1;
end

F = griddedInterpolant(base.x',base.y',base.z');
z = F(x,y);

end