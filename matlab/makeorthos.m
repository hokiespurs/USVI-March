%% Make Ortho for each pointcloud
[~,DNAMES] = dirname('*',0,'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\06_PROCIMAGES\');
FULLNAMES = cellfun(@(x) [x '\06_QUICKPROC\quickproc5\'],DNAMES,'UniformOutput',false);
DX = 1;
count = zeros(7,1);
% Control data
CONTROLDNAME = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\03_DELIVERABLES\01_GEOSPATIAL\';

KAYAK_BUCK  = [CONTROLDNAME '01_CONTROL/20180323_BUCK_SONAR_APPLIEDDEPTH.csv'];
KAYAK_WHALE  = [CONTROLDNAME '01_CONTROL/20180328_WHALEPOINT_SONAR_APPLIEDDEPTH.csv'];
KAYAK_ROD  = [CONTROLDNAME '01_CONTROL/20180330_RODBAY_SONAR_APPLIEDDEPTH.csv'];

kayak1 = readControlData(KAYAK_BUCK);
kayak2 = readControlData(KAYAK_WHALE);
kayak3 = readControlData(KAYAK_ROD);

kayake = [kayak1.e kayak2.e kayak3.e];
kayakn = [kayak1.n kayak2.n kayak3.n];

TS_BUCK     = [CONTROLDNAME '01_CONTROL/20180325_BUCK_TS.csv'];
TS_WHALE     = [CONTROLDNAME '01_CONTROL/20180328_WHALEPOINT_TS.csv'];
TS_ISAAC     = [CONTROLDNAME '01_CONTROL/20180329_ISAAC_TS.csv'];
TS_ROD     = [CONTROLDNAME '01_CONTROL/20180331_RODBAY_TS.csv'];
TS_JACKS     = [CONTROLDNAME '01_CONTROL/20180401_JACKS_TS.csv'];

ts1 = readControlData(TS_BUCK,1:4);
ts2 = readControlData(TS_WHALE,1:4);
ts3 = readControlData(TS_ISAAC,1:4);
ts4 = readControlData(TS_ROD,1:4);
ts5 = readControlData(TS_JACKS,1:4);

gcpe = [ts1.e(1:15) ts2.e(1:11) ts3.e(1:10) ts4.e(1:12) ts5.e(1:11)];
gcpn = [ts1.n(1:15) ts2.n(1:11) ts3.n(1:10) ts4.n(1:12) ts5.n(1:11)];

tse = [ts1.e(16:end) ts3.e(11:end) ts4.e(13:end) ts5.e(12:end)];
tsn = [ts1.n(16:end) ts3.n(11:end) ts4.n(13:end) ts5.n(12:end)];

%%

for i=1:numel(FULLNAMES)
    %%
    DNAME = FULLNAMES{i};
    lasname = [DNAME 'dense.las'];
    trajname = [DNAME '/../../02_TRAJECTORY/imageposUTM.csv'];
    
    if ~exist(lasname,'file')
        d = fileparts(fileparts(FULLNAMES{i}));
        fprintf('resorting to quickproc\n');
        lasname = [d '/quickproc/dense.las'];
    end
    
    if exist(lasname,'file')
        %%
        waterlevel = -41;
        [~,justname]=fileparts(fileparts(fileparts(fileparts(FULLNAMES{i}))));
        [pt,AsAz]=getUSVIXsAsCoords(justname);
        
        lasdat = LASread(lasname);
        
        x = lasdat.record.x;
        y = lasdat.record.y;
        z = lasdat.record.z;
        r = lasdat.record.red/255;
        g = lasdat.record.green/255;
        b = lasdat.record.blue/255;
        
        [xs,as]=calcXsAs(x,y,pt,AsAz);
        
        xsi = min(xs):DX:max(xs);
        asi = min(as):DX:max(as);
        
        [asg,xsg]=meshgrid(asi,xsi);
        
        zg = roundgridfun(as,xs,z,asg,xsg,@mean);
        
        rg = uint8(roundgridfun(as,xs,r,asg,xsg,@mean));
        gg = uint8(roundgridfun(as,xs,g,asg,xsg,@mean));
        bg = uint8(roundgridfun(as,xs,b,asg,xsg,@mean));
        
        rgb = cat(3,rg,gg,bg);
        
        str=justname;
        
        if contains(str,{'0320','0321','0322','0323','0324','0325'}) %NW Buck
            fignum=1;
        elseif contains(str,{'0326'}) %SE Buck
            fignum=2;
        elseif contains(str,{'0328'}) % Whale Point
            fignum=3;
        elseif contains(str,{'0329'}) % Isaac
            fignum=4;
        elseif contains(str,{'0330','0331'}) % Rod Bay
            fignum=5;
        elseif contains(str,{'0401'}) % JacksBay
            fignum=6;
        else
            fignum=7;
        end
        count(fignum)=count(fignum)+1;
   
        if count(fignum)>16
            f = figure(fignum*10);
            subplot(4,4,count(fignum)-16);
        else    
            f = figure(fignum);
            subplot(4,4,count(fignum));

        end
        
        set(f,'units','normalized','position',[0.05 0.1 0.8 0.8]);
% 
%         subplot(2,1,1);
%         pcolor(asi,xsi,zg);shading flat
%         axis equal
%         grid on
%         
%         subplot(2,1,2);
        imagesc(asi,xsi,histeq(rgb));
        set(gca,'ydir','normal');
        axis equal
        grid on
        hold on
        ax = axis;
        plot([0 0 500],[500 0 0],'k-');
        
        % plot kayak
        [kayakxs,kayakas] = calcXsAs(kayake,kayakn,pt,AsAz);
        plot(kayakas,kayakxs,'b.','markersize',0.5);
        
        % plot gcps
        [gcpxs,gcpas] = calcXsAs(gcpe,gcpn,pt,AsAz);
        plot(gcpas,gcpxs,'m^','MarkerFaceColor','r');
        
        % plots ts
        [tsxs,tsas] = calcXsAs(tse,tsn,pt,AsAz);
        plot(tsas,tsxs,'r.');
        
        % plot camera positions
        trajdata = importdata(trajname);
        came = trajdata.data(:,3);
        camn = trajdata.data(:,4);
        [camxs,camas]=calcXsAs(came,camn,pt,AsAz);
        plot(camas,camxs,'k.-','markersize',10);
        
        axis(ax);
        title(justname,'fontsize',16,'interpreter','latex');
        xlabel('Alongshore(m)','interpreter','latex','fontsize',14);
        ylabel('Cross-shore(m)','interpreter','latex','fontsize',14);
        
        drawnow
    end
end