function dietrichstr = makeHistPcolorPcolorPlot(matname,ax1,ax2,ax3,CAX)
    XTIX = linspace(CAX(1),CAX(2),5);
    cmap = [252,141, 98;
            102,194,165]/255;
    %%
    idat = load(matname);
    
    truedepth = idat.sfmcompare.lidar.Zg;
    sfmdepth = idat.sfmcompare.dense.Zg;
    dietrichdepth = idat.dietrich.dense.corDepth;
    
    truewaterdepth = truedepth-idat.tideval;
    maskpts = truewaterdepth>2;
    
    truedepth(maskpts)=nan;
    sfmdepth(maskpts)=nan;
    dietrichdepth(maskpts)=nan;
    
    Asg = idat.sfmcompare.AsGrid;
    Xsg = idat.sfmcompare.XsGrid;
    %%
    axes(ax1);
    hold on
    h1=histogram(dietrichdepth-truedepth,CAX(1):0.01:CAX(2),'Normalization','probability','FaceColor',cmap(2,:),'edgeColor','none');
    grid on
    set(gca,'fontsize',16)
    set(gca,'TickLabelInterpreter','latex');
    xticks(XTIX)
    
    [mu,sig] = stdnooutlier(dietrichdepth-truedepth,3);
    dietrichstr = sprintf('$%+7.3f\\pm%.3fm$',mu,sig);
%     text(0.05,0.9,rawstr,...
%     'interpreter','latex','fontsize',14,'units','normalize','Color',cmap(2,:),'backgroundcolor','w','HorizontalAlignment','left');
    
    mypdf = normpdf(CAX(1):0.01:CAX(2),mu,sig)/100;
    hold on
    
    h2=histogram(sfmdepth-truedepth,CAX(1):0.01:CAX(2),'Normalization','probability','FaceColor',cmap(1,:),'edgeColor','none');
    plot(CAX(1):0.01:CAX(2),mypdf,'--','linewidth',2,'color',cmap(2,:))
    grid on
    set(gca,'fontsize',16)
    set(gca,'TickLabelInterpreter','latex');
    xticks(XTIX)
    
    [mu,sig] = stdnooutlier(sfmdepth-truedepth,3);
    rawstr = sprintf('$%+7.3f\\pm%.3fm$',mu,sig);
%     text(0.95,0.9,dietrichstr,...
%     'interpreter','latex','fontsize',14,'units','normalize','Color',cmap(1,:),'backgroundcolor','w','HorizontalAlignment','right');
    
    mypdf = normpdf(CAX(1):0.01:CAX(2),mu,sig)/100;
    hold on
    plot(CAX(1):0.01:CAX(2),mypdf,'k--','linewidth',2,'color',cmap(1,:))  

    yax = ylim;
    ylim([0 yax(2)*1.4]);
    
    hl = legend([h1 h2],{['Dietrich : ' dietrichstr],['Raw SfM:' rawstr]},'fontsize',14,'interpreter','latex');
    hlpos = hl.Position;
    hlpos(2)=hlpos(2)-0.005;
    hl.Position = hlpos;
    %%
    axes(ax2);
    pcolor(Asg,Xsg,sfmdepth-truedepth);shading flat
    caxis(CAX);
    colormap(ax2,cmapdiverge);
    axis equal
    set(gca,'fontsize',16)
    set(gca,'TickLabelInterpreter','latex');
    grid on
    hold on
    plot(idat.trajectoryAll.As,idat.trajectoryAll.Xs,'mx','markersize',4)
    plot(idat.camposerror.As,idat.camposerror.Xs,'m.','markersize',10);
    
    %%
    axes(ax3);
    pcolor(Asg,Xsg,dietrichdepth-truedepth);shading flat
    hold on
    if ~isnan(idat.markers.enabled)
        plot(idat.markers.As(logical(idat.markers.enabled)),idat.markers.Xs(logical(idat.markers.enabled)),'m^','MarkerFaceColor','m','markersize',7)
%         plot(idat.markers.As(logical(~idat.markers.enabled)),idat.markers.Xs(logical(~idat.markers.enabled)),'m.','MarkerFaceColor','m','markersize',10)
    end
    caxis(CAX);
    colormap(ax3,cmapdiverge);
    axis equal
    set(gca,'fontsize',16)
    set(gca,'TickLabelInterpreter','latex');
    grid on
    
end