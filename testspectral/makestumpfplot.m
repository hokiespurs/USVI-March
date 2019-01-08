%plot stumpf
OUTFIGDIR = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\11_FIGURES\03_STUMPF\';
SEARCHDIR = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\06_PROCIMAGES\*\06_QUICKPROC\';
DOREPROC = false;
DOFIRSTPLOTS = false;
CAX = [-1 1];
XTIX = -1:.2:1;
cmap = flipud(cbrewer('div','RdYlGn',11));
%%
if ~exist('fnames','var') || DOREPROC
    [fnames,~] = dirname('*.psx',5,SEARCHDIR);
    [dnames, justname, ext] = filepartsstruct(fnames);
    [D,F2,~]=filepartsstruct(dnames);
    [D,~,~]=filepartsstruct(D);
    [~,F1,~]=filepartsstruct(D);
end

%%
iplot = 81;
for iplot=1:numel(dnames)
    dname = dnames{iplot};
    matname = dirname([dname '/analysis/*mat']);
    idat = load(matname{1});

    Asg = idat.sfmcompare.AsGrid;
    Xsg = idat.sfmcompare.XsGrid;
    
    truedepth = idat.sfmcompare.lidar.Zg;
    
    [Asgortho,Xsgortho]=meshgrid(idat.ortho.As,idat.ortho.Xs);
    orthotruedepth   = roundgridfun(Asg,Xsg, truedepth-idat.tideval                     ,Asgortho,Xsgortho,@mean);
    orthodensedepth  = roundgridfun(Asg,Xsg, idat.dietrich.dense.corDepth-idat.tideval  ,Asgortho,Xsgortho,@mean);
    orthosparsedepth = roundgridfun(Asg,Xsg, idat.dietrich.sparse.corDepth-idat.tideval ,Asgortho,Xsgortho,@mean);

    maskpts = orthotruedepth>2;
    
    R = idat.ortho.rgb(:,:,1);
    G = idat.ortho.rgb(:,:,2);
    B = idat.ortho.rgb(:,:,3);
    
    Stumpf = log(double(B))./log(double(G));
    Stumpf(B==255 & G==255) = nan;
    Stumpf(Stumpf==inf | Stumpf==-inf)=nan;
%     Stumpf(orthotruedepth>0.5)=nan;
    
    R(isnan(Stumpf))=0;
    G(isnan(Stumpf))=0;
    B(isnan(Stumpf))=0;
    rgb = [R(:) G(:) B(:)];
    
    depth = idat.ortho.Zg(:)-idat.tideval;
    [udense,stddense]=stdnooutlier(orthodensedepth(:),3);
    [usparse,stdsparse]=stdnooutlier(orthosparsedepth(:),3);
    
    f=figure(1);clf
    set(f,'units','normalize','position',[0.05 0.05 0.8 0.8])
    
    axg = axgrid(3,3,0.1,0.1,0.05,0.9,0.05,0.9);
    %
    h1=axg(1);
    imagesc(idat.ortho.As,idat.ortho.Xs,idat.ortho.rgb);shading flat
    set(h1,'ydir','normal')
    axis equal
    title('RGB','fontsize',18,'interpreter','latex');
    xlabel('Along-shore(m)','fontsize',16,'interpreter','latex');
    ylabel('Cross-shore(m)','fontsize',16,'interpreter','latex');
    grid on
    ax = axis;
    hold on
    plot(idat.camposerror.As,idat.camposerror.Xs,'m.');
    contour(idat.ortho.As,idat.ortho.Xs,orthotruedepth,[-6:.5:2],'w')
    axis(ax);
    %
    h2=axg(2);
    pcolor(idat.ortho.As,idat.ortho.Xs,orthotruedepth);shading flat
    hold on
    contour(idat.ortho.As,idat.ortho.Xs,orthotruedepth,[-6:.5:2],'k')
    axis(ax);
    demcmap([-6 2]);
    
    title('True Depth','fontsize',18,'interpreter','latex');
    xlabel('Along-shore(m)','fontsize',16,'interpreter','latex');
    ylabel('Cross-shore(m)','fontsize',16,'interpreter','latex');
    yticklabels('');
    grid on
    axis equal
    
    c = bigcolorbarax(h2,0.01,0.025,'True Depth(m)','fontsize',14,'interpreter','latex');
    demcmap([-6 2]);
    set(gca,'fontsize',14,'TickLabelInterpreter','latex')
    c.TickLabelInterpreter = 'latex';

    %
    h3=axg(3);
    pcolor(idat.ortho.As,idat.ortho.Xs,Stumpf);shading flat
    hold on
    contour(idat.ortho.As,idat.ortho.Xs,orthotruedepth,[-6:.5:2],'k')
    axis(ax);
    colormap(h3,flipud(parula))
    caxis([0.925 1.05])
    axis equal
    title('$\frac{ln(Red)}{ln(Green)}$ (Stumpf)','fontsize',18,'interpreter','latex');
    xlabel('Along-shore(m)','fontsize',16,'interpreter','latex');
    ylabel('Cross-shore(m)','fontsize',16,'interpreter','latex');
    yticklabels('')
    grid on
    
    c=bigcolorbarax(h3,0.01,0.025,'Stumpf Ratio','fontsize',14,'interpreter','latex');
    set(gca,'fontsize',14,'TickLabelInterpreter','latex')
    caxis([0.925 1.05])
    colormap(gca,flipud(parula))
    c.TickLabelInterpreter = 'latex';
    
    % 
    axg(6)
    scatter(orthotruedepth(:),Stumpf(:),10,double(rgb)/255,'filled')
    grid on
    ylim([0.925 1.05]);
    xlim([-6 2]);
    
    title('True Depth vs Stumpf Ratio','fontsize',18,'interpreter','latex');
    xlabel('True Depth(m)','fontsize',16,'interpreter','latex');
    ylabel('Stumpf Ratio','fontsize',16,'interpreter','latex');
    axis6 = axis;
    
    x = orthotruedepth(:);
    y = Stumpf(:);
    ind = ~isnan(x) & ~isnan(y) & x<-0.5;
    p = polyfit(x(ind),y(ind),1);
    
    hold on
    xi = xlim;
    yi = polyval(p,xi);
%     for i=-50:1:50
%         plot(xi-i,yi,'-','color',[0.2 0.2 0.2]);
%     end
    plot(xi,yi,'b-');
    
    %
    axg(4)
    scatter(orthosparsedepth(:),Stumpf(:),10,double(rgb)/255,'filled')
%     hold on
%     for i=-50:1:50
%         plot(xi-i,yi,'-','color',[0.2 0.2 0.2]);
%     end
    
    grid on
    ylim([0.925 1.05]);
    dxlim = (8-range([usparse-stdsparse*3 usparse+stdsparse*3]))/2;
    xlim([usparse-stdsparse*3-dxlim usparse+stdsparse*3+dxlim]);
    
    title('Sparse Dietrich SfM Depth vs Stumpf Ratio','fontsize',18,'interpreter','latex');
    xlabel('Sparse Dietrich SfM Depth(m)','fontsize',16,'interpreter','latex');
    ylabel('Stumpf Ratio','fontsize',16,'interpreter','latex');

    % 
    axg(5)
    scatter(orthodensedepth(:),Stumpf(:),10,double(rgb)/255,'filled')
%     hold on
%     for i=-50:1:50
%         plot(xi-i,yi,'-','color',[0.2 0.2 0.2]);
%     end
%     
    grid on
    ylim([0.925 1.05]);
    dxlim = (8-range([udense-stddense*3 udense+stddense*3]))/2;
    xlim([udense-stddense*3-dxlim udense+stddense*3+dxlim]);
    
    title('Dense Dietrich SfM Depth vs Stumpf Ratio','fontsize',18,'interpreter','latex');
    xlabel('Dense Dietrich SfM Depth(m)','fontsize',16,'interpreter','latex');
    ylabel('Stumpf Ratio','fontsize',16,'interpreter','latex');
    
    %
    h7 = axg(7);
%     pcolor(idat.sfmcompare.AsGrid,idat.sfmcompare.XsGrid,idat.sfmcompare.sparse.dLidar);shading flat
%     hold on
%     contour(idat.ortho.As,idat.ortho.Xs,orthotruedepth,[-6:.5:2],'k')
%     colormap(h7,cmapdiverge);
%     caxis([-5 5]);
%     title('Sparse Dietrich SfM Error','fontsize',18,'interpreter','latex');
%     xlabel('Along-shore(m)','fontsize',16,'interpreter','latex');
%     ylabel('Cross-shore(m)','fontsize',16,'interpreter','latex');
%     axis(ax);
%     grid on
    badind = sum(rgb,2)~=0;
    title('RGB Distribution w/ Depth','fontsize',18,'interpreter','latex');
    xlabel('True Depth(m)','fontsize',14,'interpreter','latex');
    ylabel('Count','fontsize',14,'interpreter','latex');
    grid on
    colorhist(orthotruedepth(badind),rgb(badind,:),-6:0.1:2)
    
%     c=bigcolorbarax(h7,0.01,0.025,'Z Error(m)','fontsize',14,'interpreter','latex');
%     set(gca,'fontsize',14,'TickLabelInterpreter','latex')
%     caxis([-5 5]);
%     colormap(gca,cmapdiverge)
%     c.TickLabelInterpreter = 'latex';
    %
    h8 = axg(8);
    pcolor(idat.sfmcompare.AsGrid,idat.sfmcompare.XsGrid,idat.sfmcompare.dense.dLidar);shading flat
    colormap(h8,cmapdiverge);
    hold on
    contour(idat.ortho.As,idat.ortho.Xs,orthotruedepth,[-6:.5:2],'k')
    caxis([-5 5]);
    title('Dense Dietrich SfM Error','fontsize',18,'interpreter','latex');
    xlabel('Along-shore(m)','fontsize',16,'interpreter','latex');
    ylabel('Cross-shore(m)','fontsize',16,'interpreter','latex');
    axis(ax);
    grid on
    
    c=bigcolorbarax(h8,0.01,0.025,'Z Error(m)','fontsize',14,'interpreter','latex');
    set(gca,'fontsize',14,'TickLabelInterpreter','latex')
    caxis([-5 5]);
    colormap(gca,cmapdiverge)
    c.TickLabelInterpreter = 'latex';
    %
    h9 = axg(9);
    y = orthotruedepth(:);
    x = Stumpf(:);
    ind = ~isnan(x) & ~isnan(y) & y<-0.5;
    p = polyfit(x(ind),y(ind),1);
    hold on
    xi = xticks;
    EstDepth = polyval(p,Stumpf);
    estDepthDiff = EstDepth-orthotruedepth;
    estDepthDiff(orthotruedepth>0.5)=nan;
    pcolor(idat.ortho.As,idat.ortho.Xs,estDepthDiff);shading flat
    caxis([-2 2]);
    colormap(h9,cmap);
    
    title('True Depth Stumpf Fit Z Residuals','fontsize',18,'interpreter','latex');
    xlabel('Along-shore(m)','fontsize',16,'interpreter','latex');
    ylabel('Cross-shore(m)','fontsize',16,'interpreter','latex');
    hold on
    contour(idat.ortho.As,idat.ortho.Xs,orthotruedepth,[-6:.5:2],'k')
    axis(ax);
    
    c=bigcolorbarax(h9,0.01,0.025,'Residual Z Error(m)','fontsize',14,'interpreter','latex');
    set(gca,'fontsize',14,'TickLabelInterpreter','latex')
    caxis([-2 2]);
    colormap(gca,cmap)
    c.TickLabelInterpreter = 'latex';
    
    bigtitleax(fixfigstring(justname{iplot}),[h1 h2 h3],0.03,'fontsize',24,'interpreter','latex')
    drawnow
    saveas(f,[dname '/analysis/stumpf.png']);
    copyfile([dname '/analysis/stumpf.png'],[OUTFIGDIR idat.justname '_Stumpf.png']);
end