function f = plotDietrich(ortho,dietrich,tideval,sfmcompare, justname)
CONTOURLIMS = -5:1;
%%
[Asg,Xsg]=meshgrid(ortho.As,ortho.Xs);

f = figure(103);clf
set(f,'units','normalize','position',[0.05 0.05 0.8 0.8])

axg = axgrid(3,3,0.05,0.05,0.05,0.85,0.05,0.9);

% raw depth
axg(1);
pcolor(ortho.As,ortho.Xs,ortho.Zg-tideval);shading flat
hold on
contour(Asg,Xsg,ortho.Zg-tideval,[0 0],'m-');
colorbar
title('Raw Depth');
axis equal

% ortho w/ contours
axg(2);
imagesc(ortho.As,ortho.Xs,ortho.gray);
hold on
contour(sfmcompare.AsGrid,sfmcompare.XsGrid,sfmcompare.lidar.Zg-tideval,CONTOURLIMS,'w-');
contour(sfmcompare.AsGrid,sfmcompare.XsGrid,sfmcompare.lidar.Zg-tideval,[0 0],'g-');
contour(Asg,Xsg,ortho.Zg-tideval,[0 0],'m-');
set(gca,'ydir','normal');
title('ortho w/ waterline contour');
axis equal

% zoom ortho w/ waterline contour shown
axg(3);
imagesc(ortho.As,ortho.Xs,ortho.gray);
hold on
contour(sfmcompare.AsGrid,sfmcompare.XsGrid,sfmcompare.lidar.Zg-tideval,CONTOURLIMS,'w-');
contour(sfmcompare.AsGrid,sfmcompare.XsGrid,sfmcompare.lidar.Zg-tideval,[0 0],'g-');
contour(Asg,Xsg,ortho.Zg-tideval,[0 0],'m-');
set(gca,'ydir','normal');
title('ortho w/ waterline contour');
axis equal
axis([100 200 0 100])

% ratio factor
axg(4);
onlywaterdietrichratio = dietrich.dense.ratio;
onlywaterdietrichratio(dietrich.dense.ratio==1)=nan;
pcolor(sfmcompare.AsGrid,sfmcompare.XsGrid,onlywaterdietrichratio);shading flat
colorbar
caxis([1.3 1.7]);
title('scale factor');
axis equal

% difference between depth correction w/ only dietrich and mean dietrich
axg(5);
rawdepth = (tideval - sfmcompare.dense.Zg);
ErrorUsingAvg = onlywaterdietrichratio .* (rawdepth) - nanmean(onlywaterdietrichratio(:)) .* (rawdepth);
pcolor(sfmcompare.AsGrid,sfmcompare.XsGrid,ErrorUsingAvg);shading flat
colorbar
caxis([-.1 .1]);
title('scale factor vs only mean dietrich');
axis equal

% scale factor vs depth
axg(6);
plot(tideval-sfmcompare.dense.Zg,dietrich.dense.ratio,'b.');
hold on
plot(tideval-sfmcompare.sparse.Zg,dietrich.sparse.ratio,'g.');

xlim([0 5]);
ylim([1 2]);
grid on
title('scale factor vs depth');

% depth correction (m)
axg(7);
pcolor(sfmcompare.AsGrid,sfmcompare.XsGrid,sfmcompare.dense.Zg-dietrich.dense.corDepth);shading flat
hold on
contour(sfmcompare.AsGrid,sfmcompare.XsGrid,sfmcompare.dense.Zg-tideval,[0 0],'m-');
colorbar
caxis([0 2]);
title('depth correction (m)');
axis equal

% depth correction gradient (sensitivity analysis to tide +/- 10cm)
axg(8);
rawdepth = (tideval - sfmcompare.dense.Zg);
ErrorPerCm = onlywaterdietrichratio .* (rawdepth+0.01) - onlywaterdietrichratio .* (rawdepth);
plot(rawdepth,ErrorPerCm*10,'b.')

title('Error Per 10cm');
xlim([0 5]);
ylim([0.1 0.2]);
grid on

% histogram
axg(9);
histogram(onlywaterdietrichratio,1:0.01:2,'normalization','probability')
grid on
title('histogram of dietrich ratio');

%
bigtitle('Applying Dietrich Algorithm',0.5,0.94,'fontsize',24,'interpreter','latex');
bigtitle(strrep(justname,'_','\_'),0.5,0.9,'fontsize',24,'interpreter','latex');

end