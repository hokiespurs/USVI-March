%% Constants
DNAME = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\06_PROCIMAGES\0325_BUCK_MAVIC_200FT_85OL\06_QUICKPROC\gcps6_trajacc';
DX = 2;

RELOADDATA = false;

PICKXYZ = true;
PICKX=151;
PICKY=82;
PICKZ=0;

RGBAVGPAD = [0 1 5 12 25 50 100 200 400];

RGBAVGPAD = [0 1 5 12 25 50 100 200 400];
SHOWBADPYRAMID = false;
SHOWGOODPYRAMID = false;
SHOWIMAGEZOOMS = false;

%% Load Data
% make base variable and load camera positions
% base.xg, base.yg, base.zg, base.rgb
if exist('lastdname','var') && ~strcmp(lastdname,DNAME)
    RELOADDATA = true;
    fprintf('Reloading data because new directory\n');
end

if ~exist('base','var') || RELOADDATA
    lastdname = DNAME;
    [D,F2,~]=fileparts(DNAME);
    [D,~,~]=fileparts(D);
    [~,F1,~]=fileparts(D);
    justname = [F1 F2];
    
    %% Get Control Names
    [pt,az,orthoname, controlnames, lidarbiasz]=getUSVIXsAsCoords(DNAME);
    
    %% Make base
    lidarname = controlnames.lidarname;
    densepcname = [DNAME '/dense.las'];
    base = getBase(lidarname,lidarbiasz,densepcname,DX);
    
    %% Load Camera positions and camera names
    pstrajectoryname = [DNAME '/trajectory.txt'];
    cameracalibname  = [DNAME '/sensorcalib.xml'];
    tidevalname      = [DNAME '/../../07_TIDE/tideval.txt'];

    pstrajectory = readCameras(pstrajectoryname);
    sensor = readSensor(cameracalibname);
    
    %% Load all cameras
    ncameras = numel(pstrajectory.name);
    for i=1:ncameras
        imname = [DNAME '/../../01_IMAGES/' pstrajectory.name{i}{1}];
        Iall{i}=imread(imname);
    end
    
    %% shift x,y, and z(tide)
    xmin = min(base.xi);
    ymin = min(base.yi);
    tideval = importdata(tidevalname);

    base.x=base.x-xmin;
    base.y=base.y-ymin;
    base.xi=base.xi-xmin;
    base.yi=base.yi-ymin;

    base.z = base.z-tideval;
    
    pstrajectory.E = pstrajectory.E-xmin;
    pstrajectory.N = pstrajectory.N-ymin;
    pstrajectory.Z = pstrajectory.Z-tideval;
    
end
%%
if PICKXYZ
    [PICKX,PICKY,PICKZ]=pickxyz(base);
elseif isnan(PICKZ)
    F = griddedInterpolant(base.x',base.y',base.z');
    PICKZ = F(x,y);
end
%%
for rgbpad = RGBAVGPAD
    for pickptnum = 1:numel(PICKX)
        
        ptx = PICKX(pickptnum);
        pty = PICKY(pickptnum);
        ptz = PICKZ(pickptnum);

        %% Plot showing the point
        % - (1,1) Ortho
        % - (2,1) DEM
        % - (1:2,2:3) 3D Textured Ortho and Cameras which see the point + Rays
        % - (3,1:3) demeaned R,G,B,ln(g)/ln(B) vs incident angle/dist_in_water
        f2=figure(10);clf
        f3=figure(11);clf
        f1=figure(1);clf;
        axg=axgrid(3,4,0.05,0.05);

        % Ortho with Point Marked
        axg([1 1],[1 2]);
        imagesc(base.xi,base.yi,base.rgb);
        set(gca,'ydir','normal');
        hold on
        plot(ptx,pty,'m.','markersize',10);
        axis equal;

        % DSM with Point Marked
        axg([2 2],[1 2]);
        pcolor(base.xi,base.yi,base.z);shading flat
        hold on
        plot(ptx,pty,'m.','markersize',10);
        caxis([-10 0]);
        axis equal;

        % Textured DSM w/ camera pyramids
        axg([1 2],[3 4]);
        surface(base.x,base.y,base.z,base.rgb,...
            'FaceColor','texturemap',...
            'EdgeColor','none',...
            'CDataMapping','direct')
        shading flat

        hold on
        K = sensor.K;
        pix = [sensor.pixx,sensor.pixy];
        rgbval = nan(numel(pstrajectory.name),3);
        imnum=0;
        for i=1:numel(pstrajectory.name)
            iR = pstrajectory.R{i};
            iC = [pstrajectory.E(i),pstrajectory.N(i),pstrajectory.Z(i)];

            [u(i),v(i),s(i),isinframe(i)] = isXYZinFrame(K,iR,iC,ptx,pty,ptz,pix(1),pix(2));
            dR=sqrt((iC(1)-ptx)^2+(iC(2)-pty)^2);
            dZ=(iC(3)-ptz);
            grazingAngle(i) = 90-atan2d(dZ,dR);

            if isinframe(i)
                if SHOWGOODPYRAMID
                plotCameraPyramid(K,iR,iC,pix,'s',10,'optLine',{'linewidth',1,'color','k'},...
                    'optPatch',{'facecolor','g','faceAlpha',0.5});
                end
            else
                if SHOWBADPYRAMID
                plotCameraPyramid(K,iR,iC,pix,'s',10,'optLine',{'linewidth',1,'color','k'},...
                    'optPatch',{'facecolor','r','faceAlpha',0.5});
                end
            end

            if isinframe(i)
                colorind = num2ind(grazingAngle(i),[0 40],10);
                cmap = jet(10);
                linevars = {'-','color',cmap(colorind,:),'linewidth',2};
%                 imname = [DNAME '/../../01_IMAGES/' pstrajectory.name{i}{1}];
%                 [ir,ig,ib,iI,shutter,iso,fstop]=getrgb(imname,u(i),v(i),rgbpad);
                [ir,ig,ib,iI,shutter,iso,fstop]=getrgbI(imname,Iall{i},u(i),v(i),rgbpad);

                
                rgbval(i,:) = [ir,ig,ib];
                
                imnum=imnum+1;
                if (imnum<=40) && SHOWIMAGEZOOMS
                    figure(10);
                    subplot(5,8,imnum);
                    image(iI);
                    axis equal
                    xlim([u(i)-150 u(i)+150]);
                    ylim([v(i)-150 v(i)+150]);
                    hold on
                    plotRect([u(i) v(i)],[rgbpad*2+1 rgbpad*2+1],'m-')
                    plot(u(i),v(i),'m+','markersize',1);
                    titlestr = sprintf('%s(%.1fdeg)',pstrajectory.name{i}{1},grazingAngle(i));
                    title(titlestr,'interpreter','latex')
                    drawnow
                end

                figure(11);
                subplot(3,1,1)
                hold on
                plot(grazingAngle(i),shutter,'.','markersize',50);
                title('shutter speed');
                ylabel('shutter speed');
                xlabel('incident angle');
                grid on

                subplot(3,1,2)
                hold on
                plot(grazingAngle(i),iso,'.','markersize',50);
                title('iso');
                ylabel('iso');
                xlabel('incident angle');
                grid on

                subplot(3,1,3)
                hold on
                plot(grazingAngle(i),fstop,'.','markersize',50);
                title('fstop');
                ylabel('fstop');
                xlabel('incident angle');    
                grid on        

                figure(1);
            else
                linevars = {'.','color','r','linewidth',.1};
            end
            plot3([ptx iC(1)],[pty iC(2)],[ptz iC(3)],linevars{:})
        end
        axis equal

        xlim([min(pstrajectory.E(isinframe))-10 max(pstrajectory.E(isinframe))+10]);
        ylim([min(pstrajectory.N(isinframe))-10 max(pstrajectory.N(isinframe))+10]);
        view(70,20)
        %
        Rall = rgbval(:,1);
        Gall = rgbval(:,2);
        Ball = rgbval(:,3);
        StumpfAll = log(Gall)./log(Ball);
        RelativeStumpf = Ball-Gall;
        RelativeBR = Ball-Rall;
        plotvars = [grazingAngle' Rall Gall Ball StumpfAll RelativeStumpf RelativeBR];
        badvals = isnan(Rall);

        plotvars = sortrows(plotvars(~badvals,:));

        figure(1)
        axg(3,1);
        plot(plotvars(:,1),plotvars(:,2),'r.-','markersize',20);
        hold on
        plot(plotvars(:,1),plotvars(:,3),'g.-','markersize',20);
        plot(plotvars(:,1),plotvars(:,4),'b.-','markersize',20);
        grid on
        
        axg(3,2);
        plot(plotvars(:,1),plotvars(:,5),'k.-','markersize',20);

        grid on
        title('Stumpf');
        xlabel('incident angle');
        ylabel('Log(Green)/Log(Blue)');
        grid on

        axg(3,3);
        plot(plotvars(:,1),plotvars(:,6),'m.-','markersize',20);
        grid on
        title('B-G');
        xlabel('incident angle');
        ylabel('B-G');

        axg(3,4);
        plot(plotvars(:,1),plotvars(:,7),'c.-','markersize',20);
        grid on
        title('B-R');
        xlabel('incident angle');
        ylabel('B-R');

%         saveas(f1,sprintf('figs/%s_x%.0f_y%.0f_z%.1f_avg%.0f.png',justname,ptx,pty,ptz,rgbpad));
%         saveas(f2,sprintf('figs/%s_x%.0f_y%.0f_z%.1f_avg%.0f_images.png',justname,ptx,pty,ptz,rgbpad));
%         saveas(f3,sprintf('figs/%s_x%.0f_y%.0f_z%.1f_avg%.0f_camerasettings.png',justname,ptx,pty,ptz,rgbpad));
    end
end