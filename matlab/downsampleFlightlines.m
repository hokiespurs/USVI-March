function downsampleFlightlines
DOPLOT = true;
DONAMES = false;
DOOUTPUT = true;
[~,dnames] = dirname('P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\06_PROCIMAGES\*MAVIC*',0);
HFOV = 65.77;
VFOV = 51.74;
fprintf('%30s | %8s | %8s | %8s | %9s | %9s | %8s \n','Name','OL','SL','ROUND','DXOL','DXSL','ROUND');
for i=1:numel(dnames)
    %% Get data
    dname = dnames{i};
    [~,justname,~]=fileparts(dname);
    
    traj = importdata([dnames{i} '/02_TRAJECTORY/imageposUTM.csv']);
    
    trajNames = traj.textdata(2:end,1);
    trajLon = traj.data(:,1);
    trajLat = traj.data(:,2);
    
    [trajX,trajY]=deg2utm(trajLat,trajLon);
    
    trajZ = ((traj.data(:,5))+40.26);
    
    %% Rotate Data
    
    Az = atan2d(diff(trajY),diff(trajX));
    Az(Az<0)=Az(Az<0)+180;
    Az(Az>180)=Az(Az>180)-180;
    
    medianAz = -median(Az);
    R = [cosd(medianAz) -sind(medianAz);sind(medianAz) cosd(medianAz)];
    XsAs=R * [trajX';trajY'];
    Xs = XsAs(1,:);
    As = XsAs(2,:);
    
    %%  Group into flightlines
    dAs = abs(diff(As));
    thresh = median(trajZ)/15;
    gap = [0 find(dAs>thresh) numel(trajLon)];
    %    figure(2);clf
    %    plot(dAs,'.-');
    %    hold on
    %    plot([0 numel(dAs)],[thresh thresh],'r-');
    %    ylim([0 30]);
    nlines = numel(gap);
    flightlines = [];
    flightlineind = [];
    flightlinenum = zeros(1,numel(trajLon));
    doverlap = [];
    AsPos=[];
    for j=1:nlines-1
        ind = gap(j)+1:gap(j+1);
        flightlines{j} = trajNames(ind);
        flightlineind{j} = ind;
        flightlinenum(ind)=j;
        doverlap(j) = abs(mean(diff(Xs(ind))));
        AsPos(j) = mean(As(ind));
    end
    
    %% Subsample Half
    flightlinesHalf = flightlines(1:2:end);
    flightlineindHalf = flightlineind(1:2:end);
    
    for j=1:numel(flightlinesHalf)
        flightlinesHalf{j}=flightlinesHalf{j}(1:2:end);
        XsHalf{j}= Xs(flightlineindHalf{j}(1:2:end));
        AsHalf{j}= As(flightlineindHalf{j}(1:2:end));
    end
    
    %% Subsample Half Half
    flightlinesHalfHalf = flightlinesHalf(1:2:end);
    flightlineindHalfHalf = flightlineindHalf(1:2:end);
    
    for j=1:numel(flightlinesHalfHalf)
        flightlinesHalfHalf{j}=flightlinesHalfHalf{j}(1:2:end);
        XsHalfHalf{j}= Xs(flightlineindHalfHalf{j}(1:4:end));
        AsHalfHalf{j}= As(flightlineindHalfHalf{j}(1:4:end));
    end
    
    %% Visualize
    if DOPLOT
        cmap = lines(nlines);
        f=figure(i);clf
        set(f,'units','normalized','position',[0.05 0.1 0.8 0.8]);
        hold on
        tot = numel(Xs);
        tothalfhalf = 0;
        for j=1:numel(flightlinesHalfHalf)
            plot(XsHalfHalf{j},AsHalfHalf{j},'mo','markersize',28,'MarkerFaceColor','m');
            tothalfhalf = tothalfhalf + numel(XsHalfHalf{j});
        end
        
        tothalf = 0;
        for j=1:numel(flightlinesHalf)
            plot(XsHalf{j},AsHalf{j},'ko','markersize',20,'markerFaceColor','c');
            plot(XsHalf{j},AsHalf{j},'kx','markersize',20);
            tothalf = tothalf + numel(XsHalf{j});
        end
        
        plot(Xs,As,'k-');hold on
        scatter(Xs,As,50,flightlinenum,'filled')
        colormap(cmap);
        colorbar
        title(fixfigstring(justname));
        grid on
        if DONAMES
            text(Xs,As+1,fixfigstring(trajNames),'Rotation',45);
        end
        
        drawnow
%         pause(2);
    end
    %% Compute Overlap/Sidelap
    Alt = median(trajZ);
    DXOL = nanmedian(doverlap);
    DXSL = nanmedian(abs(diff(AsPos)));
    OL = calcOverlapPercent(VFOV,Alt,DXOL);
    SL = calcOverlapPercent(HFOV,Alt,DXSL);
    %% Round OL/SL
    Percents = [50 66 75 80 83.5 87.5];
    NPercents = [2 3 4 5 6 8];
    [~,ind] = min(abs(Percents-SL));
    Nsidelap = NPercents(ind);
    %%
    fprintf('%30s | %8.1f | %8.1f | %8.1f | %8.1fm | %8.1fm | %8.0f ',justname,OL,SL,Percents(ind),DXOL,DXSL,NPercents(ind));

    %% Downsample Each
    if DOOUTPUT
        if ~exist([dnames{i} '/05_DOWNSAMPLE'],'dir')
            mkdir([dnames{i} '/05_DOWNSAMPLE']);
        end
        switch Nsidelap
            case 2
                writeNames([dnames{i} '/05_DOWNSAMPLE/2.csv'], flightlines);
                fprintf('-%5i\n',tot);
            case 3
                writeNames([dnames{i} '/05_DOWNSAMPLE/3.csv'], flightlines);
                fprintf('-%5i\n',tot);
            case 4
                writeNames([dnames{i} '/05_DOWNSAMPLE/4.csv'], flightlines);
                writeNames([dnames{i} '/05_DOWNSAMPLE/2.csv'], flightlinesHalf);
                fprintf('-%5i',tot);
                fprintf('  2-%5i\n',tothalf);
            case 5
                writeNames([dnames{i} '/05_DOWNSAMPLE/5.csv'], flightlines);
                fprintf('-%5i\n',tot);
            case 6
                writeNames([dnames{i} '/05_DOWNSAMPLE/6.csv'], flightlines);
                writeNames([dnames{i} '/05_DOWNSAMPLE/3.csv'], flightlinesHalf);
                fprintf('-%5i',tot);
                fprintf('  3-%5i\n',tothalf);
            case 8
                writeNames([dnames{i} '/05_DOWNSAMPLE/8.csv'], flightlines);
                writeNames([dnames{i} '/05_DOWNSAMPLE/4.csv'], flightlinesHalf);
                writeNames([dnames{i} '/05_DOWNSAMPLE/2.csv'], flightlinesHalfHalf);
                fprintf('-%5i',tot);
                fprintf('  4-%5i',tothalf);
                fprintf('  2-%5i\n',tothalfhalf);
        end
    end
end
end

function writeNames(fname, flightlines)
    fid = fopen(fname,'w+t');
    for i=1:numel(flightlines)
        fprintf(fid,'%s\n',flightlines{i}{:});
    end
    fclose(fid);
end