[~,DNAMES] = dirname('*',0,'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\06_PROCIMAGES\');
FULLNAMES = cellfun(@(x) [x '\06_QUICKPROC\quickproc5\'],DNAMES,'UniformOutput',false);

f = figure(1);clf

cmap = lines(7);

axg = axgrid(8,9,0.04,0.02,0.02,0.98,0.02,0.98);
for i=1:numel(FULLNAMES)
    DNAME = FULLNAMES{i};
    lasname = [DNAME 'dense.las'];
    waterlevel = -41;
    trajname = [DNAME 'trajectory.txt'];
    if exist(trajname,'file')
        rawdata = importdata(trajname);
        camera = [];
        OPK = rawdata.data(:,4:6);
        RPY = [];
        for j=1:size(rawdata.data,1)
            R = diag([1, -1, -1]) * reshape(rawdata.data(j,7:end),3,3)';
            [RPY(j,1),RPY(j,2),RPY(j,3)] = dcm2angle(R);
        end
        
        RPY = RPY*180/pi + [180 0 180];
        RPY(RPY>90)=RPY(RPY>90)-360;
        
        
        axg(i);
        plot(RPY(:,2),'color',cmap(1,:));
        hold on
        plot(RPY(:,3),'color',cmap(2,:));
        grid on
        axis tight
        set(gca,'YTick',[-40:10:40]);
        set(gca,'Xtick',[]);
        
        [~,JUSTNAME]=fileparts(fileparts(fileparts(fileparts(FULLNAMES{i}))));
        if contains(JUSTNAME,'S900')
            c = cmap(4,:);
        elseif contains(JUSTNAME,'SOLO')
            c = cmap(5,:);
        else
            c = cmap(6,:);
        end
        title(fixfigstring(JUSTNAME),'fontsize',9,'color',c);
        ylim([-45 45]);
        drawnow
        
        fprintf('%-36s \t%7.2f ± %-7.2f\t%7.2f ± %-7.2f\n',JUSTNAME,...
            nanmean(RPY(:,2)),nanstd(RPY(:,2)),nanmean(RPY(:,3)),nanstd(RPY(:,3)));
    else
        fprintf('%-36s ERROR\n',JUSTNAME);
    end
end
axg(i+1);
xlim([-1 1]);
ylim([-1 1]);
text(-0.5,0.5,'Roll','color',cmap(1,:),'fontsize',36);
text(-0.5,-0.5,'Pitch','color',cmap(2,:),'fontsize',36);
axis off;

saveas(f,'../images/rpy/rpyall.png');