function f = plotDietrich2control(ortho,dietrich, sfmcompare, justname)
%%
XLABELARGS = {'interpreter','latex','fontsize',16};
YLABELARGS = {'interpreter','latex','fontsize',16};
TITLEARGS = {'interpreter','latex','fontsize',20};
COLORBARARGS = {'interpreter','latex','fontsize',14};
LEGENDARGS = {'interpreter','latex','fontsize',14};
TEXTARGS = {'interpreter','latex','fontsize',14};
SCATTERPTSIZE = 10;
HISTRANGE = -2:0.05:2;

axg =axgrid(2,2,0.075,0.1,0.075,0.85,0.1,0.9);

%% Computations
Asg = sfmcompare.AsGrid;
Xsg = sfmcompare.XsGrid;

%dense
dZdenseAll = dietrich.dense.corDepth-sfmcompare.control.Zg;
isgooddense = ~isnan(dZdenseAll);

Asdense = Asg(isgooddense);
Xsdense = Xsg(isgooddense);
dZdense = dZdenseAll(isgooddense);

% udZdense = nanmean(dZdense(:));
% stddZdense = nanstd(dZdense(:));
[udZdense,stddZdense] = stdnooutlier(dZdense(:),3);

%sparse
dZsparseAll = dietrich.sparse.corDepth-sfmcompare.control.Zg;
isgoodsparse = ~isnan(dZsparseAll);

Assparse = Asg(isgoodsparse);
Xssparse = Xsg(isgoodsparse);
dZsparse = dZsparseAll(isgoodsparse);

% udZsparse = nanmean(dZsparse(:));
% stddZsparse = nanstd(dZsparse(:));
[udZsparse,stddZsparse] = stdnooutlier(dZsparse(:),3);

%% Dense Plots
f = figure(104);clf;
set(f,'units','normalize','position',[0.05 0.05 0.8 0.8])
% make scatter dense
h2 = axg(2);
makeScatter(ortho,Asdense,Xsdense,dZdense,udZdense,SCATTERPTSIZE);
title('Dense SfM Pointcloud','interpreter','latex','fontsize',16);
yticklabels(repmat(' ',numel(yticks),1));
caxis([-.55 .55]);

% make scatter sparse
h1 = axg(1);
makeScatter(ortho,Assparse,Xssparse,dZsparse,udZsparse,SCATTERPTSIZE);
title('Sparse SfM Pointcloud','interpreter','latex','fontsize',16);
ylabel('Cross-shore (m)','interpreter','latex','fontsize',16);
caxis([-.55 .55]);

hcolorbar = bigcolorbarax(h1,0.015,0.025,'Residual $\Delta$ Elevation (m)',COLORBARARGS{:});
caxis([-.55 .55]);
hcolorbar.FontSize = 14;
hcolorbar.Ticks = -.5:0.1:0.5;
hcolorbar.TickLabelInterpreter = 'latex';
hcolorbar.TickLabels = num2labelstr(-.5:0.1:0.5,'$%+3.1f$');
hcolorbar.Label.FontSize = 16;
% histogram dense
axg(3:4);

histogram(dZsparse,HISTRANGE,'normalization','probability')
hold on
histogram(dZdense,HISTRANGE,'normalization','probability')


mypdfsparse = normpdf(HISTRANGE,udZsparse,stddZsparse)*mean(diff(HISTRANGE));
plot(HISTRANGE,mypdfsparse,'b-','linewidth',3);

mypdfdense = normpdf(HISTRANGE,udZdense,stddZdense)*mean(diff(HISTRANGE));
plot(HISTRANGE,mypdfdense,'r-','linewidth',3);

% text(0.65,0.85,sprintf('$\\mu = %07.3fm$',udZ),...
%     'interpreter','latex','fontsize',16,'units','normalize');
% text(0.65,0.75,sprintf('$\\sigma = %07.3fm$',stddZ),...
%     'interpreter','latex','fontsize',16,'units','normalize');


xlim([HISTRANGE(1) HISTRANGE(end)])
grid on
% make manual legend
text(0.15,0.9,'Sparse SfM','interpreter','latex','fontsize',16,'units','normalize','Color','b');
text(0.15,0.8,sprintf('$\\mu$ = %7.3fm',udZsparse),...
    'interpreter','latex','fontsize',16,'units','normalize','Color','b');
text(0.15,0.7,sprintf('$\\sigma$ = %7.3fm',stddZsparse),...
    'interpreter','latex','fontsize',16,'units','normalize','Color','b');
text(0.15,0.6,sprintf('$N$ = %7.0f',numel(dZsparse)),...
    'interpreter','latex','fontsize',16,'units','normalize','Color','b');

text(0.75,0.9,'Dense SfM','interpreter','latex','fontsize',16,'units','normalize','Color','r');
text(0.75,0.8,sprintf('$\\mu$ = %7.3fm',udZdense),...
    'interpreter','latex','fontsize',16,'units','normalize','Color','r');
text(0.75,0.7,sprintf('$\\sigma$ = %7.3fm',stddZdense),...
    'interpreter','latex','fontsize',16,'units','normalize','Color','r');
text(0.75,0.6,sprintf('$ N $ = %7.0f',numel(dZdense)),...
    'interpreter','latex','fontsize',16,'units','normalize','Color','r');

set(gca,'fontsize',14);
set(gca,'TickLabelInterpreter','latex');
xlabel('Residual $\Delta$ Elevation (m)',XLABELARGS{:});
ylabel('Probability',XLABELARGS{:});
%%
bigtitle('Dietrich SfM vs Control Data',0.5,0.94,'fontsize',24,'interpreter','latex');
bigtitle(strrep(justname,'_','\_'),0.5,0.9,TITLEARGS{:});
end

function makeScatter(ortho,As,Xs,dZ,udZ,SCATTERPTSIZE)
% scatter dense
imagesc(ortho.As,ortho.Xs,ortho.gray);
hold on
scatter(As, Xs, SCATTERPTSIZE, dZ,'filled')
caxis([-2 2]);
colormap(cmapdiverge);
axis equal
grid on

set(gca,'ydir','normal');
set(gca,'TickLabelInterpreter','latex');
set(gca,'FontSize',14);

xlabel('Along-shore (m)','interpreter','latex','fontsize',16);


end