OUTFIGDIR = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\11_FIGURES\01_ANALYZEALL2\';
SEARCHDIR = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\06_PROCIMAGES\*\06_QUICKPROC\';
DOREPROC = false;
DOFIRSTPLOTS = false;
CAX = [-1 1];
XTIX = -1:.2:1;
%%
if ~exist('fnames','var') || DOREPROC
    [fnames,~] = dirname('*.psx',5,SEARCHDIR);
    [dnames, justname, ext] = filepartsstruct(fnames);
    [D,F2,~]=filepartsstruct(dnames);
    [D,~,~]=filepartsstruct(D);
    [~,F1,~]=filepartsstruct(D);
end
%%
if DOFIRSTPLOTS
    iplot = 81;
    for iplot=1:numel(dnames)
        dname = dnames{iplot};
        matname = dirname([dname '/analysis/*mat']);
        idat = load(matname{1});
        
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
        
        f = figure(1);clf
        set(f,'units','normalize','position',[0.05 0.05 0.8 0.8])
        axg = axgrid(2,2,.1,0.075,0.1,0.9,0.1,0.8);
        
        % ax1 = axg(1);
        % pcolor(Asg,Xsg,truedepth-idat.tideval);shading flat
        % caxis([-4 1]);
        % colormap(ax1,parula(256));
        % axis equal
        %
        % ax2 = axg(2);
        % imagesc(idat.ortho.As,idat.ortho.Xs,idat.ortho.rgb);
        % set(gca,'ydir','normal');
        % axis equal
        %
        ax2 = axg(2);
        pcolor(Asg,Xsg,sfmdepth-truedepth);shading flat
        caxis(CAX);
        colormap(ax2,cmapdiverge);
        axis equal
        set(gca,'fontsize',16)
        set(gca,'TickLabelInterpreter','latex');
        grid on
        
        ylabel('Cross-shore Position(m)','interpreter','latex','fontsize',20);
        title('Raw SfM','interpreter','latex','fontsize',24);
        %
        ax1 = axg(1);
        histogram(sfmdepth-truedepth,CAX(1):0.01:CAX(2),'Normalization','probability');
        grid on
        set(gca,'fontsize',16)
        set(gca,'TickLabelInterpreter','latex');
        xticks(XTIX)
        
        [mu,sig] = stdnooutlier(sfmdepth-truedepth,3);
        text(0.1,0.9,sprintf('$%7.3f\\pm%.3fm$',mu,sig),...
            'interpreter','latex','fontsize',16,'units','normalize','Color','k','backgroundcolor','w');
        
        mypdf = normpdf(CAX(1):0.01:CAX(2),mu,sig)/100;
        hold on
        plot(CAX(1):0.01:CAX(2),mypdf,'k--','linewidth',2)
        
        ylabel('Probability','interpreter','latex','fontsize',20);
        title('Raw SfM','interpreter','latex','fontsize',24);
        
        grid on
        
        %
        ax4 = axg(4);
        pcolor(Asg,Xsg,dietrichdepth-truedepth);shading flat
        caxis(CAX);
        colormap(ax4,cmapdiverge);
        axis equal
        set(gca,'fontsize',16)
        set(gca,'TickLabelInterpreter','latex');
        grid on
        
        ylabel('Cross-shore Position(m)','interpreter','latex','fontsize',20);
        xlabel('Along-shore Position(m)','interpreter','latex','fontsize',20);
        title('Dietrich Corrected SfM','interpreter','latex','fontsize',24);
        
        %
        ax3 = axg(3);
        histogram(dietrichdepth-truedepth,CAX(1):0.01:CAX(2),'Normalization','probability');
        grid on
        set(gca,'fontsize',16)
        set(gca,'TickLabelInterpreter','latex');
        xticks(XTIX)
        
        [mu,sig] = stdnooutlier(dietrichdepth-truedepth,3);
        text(0.1,0.9,sprintf('$%7.3f\\pm%.3fm$',mu,sig),...
            'interpreter','latex','fontsize',16,'units','normalize','Color','k','backgroundcolor','w');
        
        mypdf = normpdf(CAX(1):0.01:CAX(2),mu,sig)/100;
        hold on
        plot(CAX(1):0.01:CAX(2),mypdf,'k--','linewidth',2)
        
        xlabel('Signed Vertical Error(m)','interpreter','latex','fontsize',20);
        ylabel('Probability','interpreter','latex','fontsize',20);
        title('Dietrich Corrected SfM','interpreter','latex','fontsize',24);
        
        %
        c = bigcolorbarax([ax2 ax4],0.025,0.05,'Elevation Error(m)','interpreter','latex','fontsize',24);
        set(gca,'fontsize',24);
        caxis(CAX);
        cticks = c.Ticks;
        c.TickLabelInterpreter = 'latex';
        c.TickLabels = num2labelstr(cticks,'$%+02.1f$ ');
        colormap(gca,cmapdiverge);
        
        bigtitleax(fixfigstring(idat.justname),[ax1 ax2],0.05,'interpreter','latex','fontsize',36);
        
        drawnow
        
        saveas(f,[dname '/analysis/comparedietrich.png']);
        copyfile([dname '/analysis/comparedietrich.png'],[OUTFIGDIR idat.justname '_H.png']);
    end
end
%%
[d,justnames] = filepartsstruct(dnames);
[~,justfolder]=filepartsstruct(filepartsstruct(d));
%%
inds = {[93 96 99]
        [94 97 100]
        [95 98 101]
        [73 76 80]
        [74 78 81]
        [75 79 82]
        [218:3:239]
        [219:3:240]
        [220:3:241]
        [149 151]
        [150 152]
        [102:3:117]
        [103:3:118]
        [104:3:119]
        [89 91]
        [90 92]
        [83 86]
        [84 87]
        [85 88]
        [43 46]
        [49 54]
        [44 47]
        [50 55]
        [45 48 51 53 56 58]
        [52 57]
        [21 24]
        [22 25]
        [23 26]
        [154 160 166 172]
        [155 161 167 173]
        [156 162 168 174]
        [158 164 170 176]
        [153 159 165 171]
        [243 249 255 261]
        [244 250 256 262]
        [245 251 257 263]
        [247 253 259 265]
        [242 248 254 260]
        [178 187 196 205]
        [180 189 198 207]
        [182 191 200 209]
        [185 194 203 211]
        [177 186 195 204]
        [179 188 197 206]
        [181 190 199 208]
        [267 276 285 294] 
        [269 278 287 296]
        [271 280 289 298]
        [274 283 292 301]
        [266 275 284 293]
        [268 277 286 295]
        [270 279 288 297]
        [178 180 182]
        [187 189 191]
        [196 198 200]        
        [205 207 209]
        [267 269 271]
        [276 278 280]
        [285 287 289]
        [294 296 298]
        [130 124 132 121 126 134]
        [135 127 137 122 128 137]
        [130 124 132 121 126 134]-1
        [4 8 14 20 42 64]
        [2 6 13 19 41 63]
        [60 67 62 70]
        [59 65 61 68]
        [83 84 86 87]
        };

bigtitlestr = {'S900 w/ GCPs and Low Camera Accuracy Setting (Whale Point)'
               'S900 w/ GCPS and Good Camera Accuracy Setting (Whale Point)'
               'S900 w/ no GCPs and Good Camera Accuracy Setting (Whale Point)'
               'S900 w/ GCPs and Low Camera Accuracy Setting (Whale Point)'
               'S900 w/ GCPS and Good Camera Accuracy Setting (Whale Point)'
               'S900 w/ no GCPs and Good Camera Accuracy Setting (Whale Point)'
               'Solo w/ GCPs and Low Camera Accuracy Setting (Rod Bay)'
               'Solo w/ GCPS and Good Camera Accuracy Setting (Rod Bay)'
               'Solo w/ no GCPs and Good Camera Accuracy Setting (Rod Bay)'
               'Solo w/ no GCPs and Low Camera Accuracy Setting (Rod Bay)'
               'Solo w/ no GCPs and Good Camera Accuracy Setting (Rod Bay)'
               'Solo w/ GCPs and Low Camera Accuracy Setting (Whale Point)'
               'Solo w/ GCPS and Good Camera Accuracy Setting (Whale Point)'
               'Solo w/ no GCPs and Good Camera Accuracy Setting (Whale Point)'
               'Solo w/ no GCPs and Low Camera Accuracy Setting (SE Buck)'
               'Solo w/ no GCPs and Good Camera Accuracy Setting (SE Buck)'
               'Solo w/ GCPs and Low Camera Accuracy Setting (NW Buck)'
               'Solo w/ GCPs and Low Camera Accuracy Setting (NW Buck)'
               'Solo w/ no GCPs and Good Camera Accuracy Setting (NW Buck)'
               'Solo w/ GCPs and Low Camera Accuracy Setting (NW Buck)'
               'Solo w/ GCPs and Good Camera Accuracy Setting (NW Buck)'
               'Solo w/ GCPs and Good Camera Accuracy Setting (NW Buck)'
               'Solo w/ GCPs and Good Camera Accuracy Setting (NW Buck)'
               'Solo w/ no GCPs and Good Camera Accuracy Setting (NW Buck)'
               'Solo w/ no GCPs and Low Camera Accuracy Setting (NW Buck)'
               'Solo w/ GCPs and Low Camera Accuracy Setting (NW Buck)'
               'Solo w/ GCPS and Good Camera Accuracy Setting (NW Buck)'
               'Solo w/ no GCPs and Good Camera Accuracy Setting (NW Buck)'
               'Oblique Mavic w/ GCPs and Low Camera Accuracy [66\% Overlap](Rod Bay)'
               'Oblique Mavic w/ GCPs and Low Camera Accuracy [85\% Overlap](Rod Bay)'
               'Oblique Mavic w/ GCPs and Good Camera Accuracy [85\% Overlap](Rod Bay)'
               'Oblique Mavic w/ no GCPs and Good Camera Accuracy [85\% Overlap](Rod Bay)'
               'Oblique Mavic w/ no GCPs and Good Camera Accuracy [66\% Overlap](Rod Bay)'
               'Oblique Mavic w/ GCPs and Low Camera Accuracy [66\% Overlap](Jacks Bay)'
               'Oblique Mavic w/ GCPs and Low Camera Accuracy [85\% Overlap](Jacks Bay)'
               'Oblique Mavic w/ GCPs and Good Camera Accuracy [85\% Overlap](Jacks Bay)'
               'Oblique Mavic w/ no GCPs and Good Camera Accuracy [85\% Overlap](Jacks Bay)'
               'Oblique Mavic w/ no GCPs and Good Camera Accuracy [66\% Overlap](Rod Bay)'
               'Mavic w/ GCPs and Good Camera Accuracy [50\%] (Rod Bay)'
               'Mavic w/ GCPs and Good Camera Accuracy [75\%] (Rod Bay)'
               'Mavic w/ GCPs and Good Camera Accuracy [88\%] (Rod Bay)'
               'Mavic w/ no GCPs and Good Camera Accuracy [88\%] (Rod Bay)'
               'Mavic w/ GCPs and Low Camera Accuracy [50\%] (Rod Bay)'
               'Mavic w/ GCPs and Low Camera Accuracy [75\%] (Rod Bay)'
               'Mavic w/ GCPs and Low Camera Accuracy [88\%] (Rod Bay)'
               'Mavic w/ GCPs and Good Camera Accuracy [50\%] (Jacks Bay)'
               'Mavic w/ GCPs and Good Camera Accuracy [75\%] (Jacks Bay)'
               'Mavic w/ GCPs and Good Camera Accuracy [88\%] (Jacks Bay)'
               'Mavic w/ no GCPs and Good Camera Accuracy [88\%] (Jacks Bay)'
               'Mavic w/ GCPs and Low Camera Accuracy [50\%] (Jacks Bay)'
               'Mavic w/ GCPs and Low Camera Accuracy [75\%] (Jacks Bay)'
               'Mavic w/ GCPs and Low Camera Accuracy [88\%] (Jacks Bay)'
               'Mavic w/ GCPs and Good Camera Accuracy [16mm] (Rod Bay)'
               'Mavic w/ GCPs and Good Camera Accuracy [21mm] (Rod Bay)'
               'Mavic w/ GCPs and Good Camera Accuracy [28mm] (Rod Bay)'
               'Mavic w/ GCPs and Good Camera Accuracy [38mm] (Rod Bay)'
               'Mavic w/ GCPs and Good Camera Accuracy [16mm] (Jacks Bay)'
               'Mavic w/ GCPs and Good Camera Accuracy [21mm] (Jacks Bay)'
               'Mavic w/ GCPs and Good Camera Accuracy [28mm] (Jacks Bay)'
               'Mavic w/ GCPs and Good Camera Accuracy [38mm] (Jacks Bay)'
               'Mavic w/ GCPs and Good Camera Accuracy (Isaac Bay)'
               'Mavic w/ no GCPs and Good Camera Accuracy (Isaac Bay)'
               'Mavic w/ GCPs and Low Camera Accuracy (Isaac Bay)'
               'Mavic w/ no GCPs and Good Camera Accuracy [75\%] (NW Buck) '
               'Mavic w/ no GCPs and Good Camera Accuracy [50\%] (NW Buck)'
               'Mavic w/ GCPs and Good Camera Accuracy [200ft] (NW Buck)'
               'Mavic w/ GCPs and Low Camera Accuracy [200ft] (NW Buck)'
               'Solo w/ GCPs (NW Buck)'};
           
smalltitlestr = {{'20mm','30mm','50mm'}
                 {'20mm','30mm','50mm'}
                 {'20mm','30mm','50mm'}
                 {'09mm GSD','10mm GSD','13mm GSD'}
                 {'09mm GSD','10mm GSD','13mm GSD'}
                 {'09mm GSD','10mm GSD','13mm GSD'}
                 {'A','B','C','D','E','F','G','H'}
                 {'A','B','C','D','E','F','G','H'}
                 {'A','B','C','D','E','F','G','H'}
                 {'A','B'}
                 {'A','B'}
                 {'400ft','400ft','400ft','450ft','450ft','400ft'}
                 {'400ft','400ft','400ft','450ft','450ft','400ft'}
                 {'400ft','400ft','400ft','450ft','450ft','400ft'}
                 {'A','B'}
                 {'A','B'}
                 {'A','B'}
                 {'A','B'}
                 {'A','B'}
                 {'200ft Oblique','200ft Oblique'}
                 {'200ft','100ft'}
                 {'200ft Oblique','200ft Oblique'}
                 {'200ft','100ft'}
                 {'200ft','200ft','200ft','200ft','100ft','400ft'}
                 {'200ft','400ft'}
                 {'A','B'}
                 {'A','B'}
                 {'A','B'}
                 {'0 degree','5 degree','10 degree','15 degree'}
                 {'0 degree','5 degree','10 degree','15 degree'}
                 {'0 degree','5 degree','10 degree','15 degree'}
                 {'0 degree','5 degree','10 degree','15 degree'}
                 {'0 degree','5 degree','10 degree','15 degree'}
                 {'0 degree','5 degree','10 degree','15 degree'}
                 {'0 degree','5 degree','10 degree','15 degree'}
                 {'0 degree','5 degree','10 degree','15 degree'}
                 {'0 degree','5 degree','10 degree','15 degree'}
                 {'0 degree','5 degree','10 degree','15 degree'}
                 {'16mm','21mm','28mm','38mm'}
                 {'16mm','21mm','28mm','38mm'}
                 {'16mm','21mm','28mm','38mm'}
                 {'16mm','21mm','28mm','38mm'}
                 {'16mm','21mm','28mm','38mm'}
                 {'16mm','21mm','28mm','38mm'}
                 {'16mm','21mm','28mm','38mm'}
                 {'16mm','21mm','28mm','38mm'}
                 {'16mm','21mm','28mm','38mm'}
                 {'16mm','21mm','28mm','38mm'}
                 {'16mm','21mm','28mm','38mm'}
                 {'16mm','21mm','28mm','38mm'}
                 {'16mm','21mm','28mm','38mm'}
                 {'16mm','21mm','28mm','38mm'}
                 {'50\%','75\%','88\%'}
                 {'50\%','75\%','88\%'}
                 {'50\%','75\%','88\%'}
                 {'50\%','75\%','88\%'}
                 {'50\%','75\%','88\%'}
                 {'50\%','75\%','88\%'}
                 {'50\%','75\%','88\%'}
                 {'50\%','75\%','88\%'}
                 {'A 50\%','B 66\%','A 75\%','C 80\%','B 83\%','A 88\%'}
                 {'A 50\%','B 66\%','A 75\%','C 80\%','B 83\%','A 88\%'}
                 {'A 50\%','B 66\%','A 75\%','C 80\%','B 83\%','A 88\%'}
                 {'200ft','400ft','250ft','300ft','100ft','200ft'}
                 {'200ft','400ft','250ft','300ft','100ft','200ft'}
                 {'50\%','66\%','75\%','84\%'}
                 {'50\%','66\%','75\%','84\%'}
                 {'Low Accuracy Camera Position','High Accuracy Camera Position','Low Accuracy Camera Position','High Accuracy Camera Position'}};
             
cax = {[-1 1]
       [-1 1]
       [-5 5]
       [-1 1]
       [-1 1]
       [-5 5]
       [-1 1]
       [-1 1]
       [-1 1]
       [-1 1]
       [-1 1]
       [-1 1]
       [-1 1]
       [-1 1]
       [-1 1]
       [-1 1]
       [-1 1]
       [-1 1]
       [-1 1]
       [-1 1]
       [-1 1]
       [-1 1]
       [-1 1]
       [-1 1]
       [-1 1]
       [-1 1]
       [-1 1]
       [-1 1]
       [-5 5]
       [-5 5]
       [-5 5]
       [-5 5]
       [-5 5]
       [-5 5]
       [-5 5]
       [-5 5]
       [-5 5]
       [-5 5]
       [-5 5]
       [-5 5]
       [-5 5]
       [-5 5]
       [-5 5]
       [-5 5]
       [-5 5]
       [-5 5]
       [-5 5]
       [-5 5]
       [-5 5]
       [-5 5]
       [-5 5]
       [-5 5]
       [-5 5]
       [-5 5]
       [-5 5]
       [-5 5]
       [-5 5]
       [-5 5]
       [-5 5]
       [-5 5]
       [-5 5]
       [-5 5]
       [-5 5]
       [-5 5]
       [-5 5]
       [-5 5]
       [-5 5]
       [-1 1]};
   
%% Make Unique Plots
DEBUGNAMES = true;

nPlots = numel(inds);
for i=68:nPlots
    ncompare = numel(inds{i});
    f = figure(1);clf
    set(f,'units','normalize','position',[0.05 0.05 0.8 0.8])
    axg = axgrid(3,ncompare,0.05,0.01,0.05,0.9,0.05,0.85);
    axh = [];
    for a = 1:3
        for b = 1:ncompare
           axh(a,b) = axg(a,b); 
        end 
    end
    for j=1:ncompare
        dname = dnames{inds{i}(j)};
        matname = dirname([dname '/analysis/*mat']);
        dietrichstr = makeHistPcolorPcolorPlot(matname{1},axh(1,j),axh(2,j),axh(3,j),cax{i});
        
        axes(axh(1,j))
        title(smalltitlestr{i}{j},'fontsize',18,'interpreter','latex')
        fnamestr = fixfigstring([ justfolder{inds{i}(j)} '/' justnames{inds{i}(j)}]);
        if DEBUGNAMES
            text(0.5,0.96,fnamestr,'fontsize',10,'units','normalize','interpreter','latex','HorizontalAlignment','center')
        end
        
        axes(axh(3,j))
        xlabel('','interpreter','latex','fontsize',20);
        if j>1
            yticklabels('');
        end
        axes(axh(2,j))
        if j>1
            yticklabels('');
        end
        xticklabels('')
        axes(axh(1,j));
        yticklabels([]);
        
        axes(axh(1,ncompare));
        tablestr = sprintf('%-10s : %s',smalltitlestr{i}{j},dietrichstr);
        hold on
        text(1.05,1-j*0.1,tablestr,'units','normalize','fontsize',16,'interpreter','latex')
        
    end
    axes(axh(1,1))
    ylabel('Probability','interpreter','latex','fontsize',20);
    
    axes(axh(2,1))
    ylabel('Raw SfM','interpreter','latex','fontsize',20);
    
    axes(axh(3,1))
    ylabel('Dietrich SfM','interpreter','latex','fontsize',20);
    xlabel('','interpreter','latex','fontsize',20);
    
    bigtitle(bigtitlestr{i},0.5,0.95,'interpreter','latex','fontsize',28);
    
    c = bigcolorbarax([axh(2,ncompare) axh(3,ncompare)],0.01,0.03,'Depth Error(m)','interpreter','latex','fontsize',20);
    set(gca,'fontsize',24);
    caxis(cax{i});
    drawnow;
    cticks = c.Ticks;
    c.TickLabelInterpreter = 'latex';
    c.TickLabels = num2labelstr(cticks,'$%+02.1f$ ');
    colormap(gca,cmapdiverge);
    
    ax = nan(ncompare,4);
    for j=1:ncompare
       axes(axg(2,j));
       ax(j,:) = axis;
    end
    axuse = [min(ax(:,1)) max(ax(:,2)) min(ax(:,3)) max(ax(:,4))];
    for j=1:ncompare
        axes(axg(2,j));
        axis(axuse);
        axes(axg(3,j));
        axis(axuse);
    end
    drawnow
    saveas(f,sprintf('compare_%2i.png',i));
end