% function testBasicSfM
%% CONSTANTS
RANDSEED = 14;
% fake data
FAKEDATASOURCE = 1;
FAKEDATANPTS   = 50;
FAKEDATADODEBUG = true;
NTIEPOINTS = 2000;
% camera placement
CAMK   = [3000 0 2000;0 3000 1500;0 0 1];
CAMPIX = [4000 3000];
CAMXI  = 20:20:80;
CAMYI  = 20:20:80;
CAMZ   = 50;
CAMRPYNOISE = 1;
CAMXYNOISE  = 1;
CAMZNOISE   = 0;
CAMPLOTSIZE = 5;
% plot rays
PLOTGCPRAYIND  = [5];
PLOTCAMCONNIND = 1;

%% Generate Fake Data and Plot it
clc
figure(100);clf
[x,y,z,gcpx,gcpy,gcpz] = fakeSfMData(FAKEDATASOURCE, FAKEDATANPTS, FAKEDATADODEBUG);
ind = randperm(numel(x),NTIEPOINTS);
xtie = x(ind);
ytie = y(ind);
ztie = z(ind);
hold on
plot3(xtie,ytie,ztie,'m.','markersize',20);
scatter3(x,y,z,10,z,'filled');axis equal
plot3(gcpx,gcpy,gcpz,'r.','markersize',30)

%% Generate Camera Iterations and Camera Structure

[camxg, camyg] = meshgrid(CAMXI,CAMYI);
ncams = numel(camxg);
camzg = ones(size(camxg))*CAMZ;
%add noise to cams
camxg = camxg + randn(size(camxg))*CAMXYNOISE;
camyg = camyg + randn(size(camxg))*CAMXYNOISE;
camzg = camzg + randn(size(camxg))*CAMZNOISE;

cmap = lines(ncams);
CAM = {};
for i=1:ncams
   % generate camera structure
   CAM{i}.C = [camxg(i) camyg(i) camzg(i)];
   inoise = randn(3,1)*CAMRPYNOISE*pi/180;
   iR = makehgtform('xrotate',pi + inoise(1),'yrotate',inoise(2),'zrotate',inoise(3));
   CAM{i}.R = iR(1:3,1:3);
   
    % Plot Camera Data
    optPatch = {'facecolor',cmap(i,:),'faceAlpha',0.5};
    optLine = {'linewidth',1,'color','k'};
    optSides = {'faceColor','k','faceAlpha',0.1};

    plotCameraPyramid(CAMK,CAM{i}.R,CAM{i}.C,CAMPIX,'s',CAMPLOTSIZE,...
        'optLine',optLine,'optPatch',optPatch,'optSides',optSides);
    axis equal;
    grid on
end

%% Plot Rays to Each Camera from a GCP
if ~isempty(PLOTGCPRAYIND)
    PLOTPT = [gcpx(PLOTGCPRAYIND) gcpy(PLOTGCPRAYIND) gcpz(PLOTGCPRAYIND)];
    for i=1:ncams
        [~,~,~,isinframe] = isXYZinFrame(CAMK,CAM{i}.R,CAM{i}.C,...
            PLOTPT(1),PLOTPT(2),PLOTPT(3),CAMPIX(1),CAMPIX(2));
        if isinframe
            linecolor = 'g';
        else
            linecolor = 'r';
        end
        plot3([PLOTPT(1) CAM{i}.C(1)],...
            [PLOTPT(2) CAM{i}.C(2)],...
            [PLOTPT(3) CAM{i}.C(3)] ,'.-','color',linecolor,'linewidth',2)
    end
end
%% Compute Tiepoint in each camera
for itp=1:NTIEPOINTS
    for jcam = 1:ncams
        [u,v,~,isinframe] = isXYZinFrame(CAMK,CAM{jcam}.R,CAM{jcam}.C,...
               xtie',ytie',ztie',CAMPIX(1),CAMPIX(2));
        u(~isinframe) = NaN;
        v(~isinframe) = NaN;
        
        CAM{jcam}.tp.u = u;
        CAM{jcam}.tp.v = v;
        
        [u,v,~,isinframe] = isXYZinFrame(CAMK,CAM{jcam}.R,CAM{jcam}.C,...
               gcpx',gcpy',gcpz',CAMPIX(1),CAMPIX(2));
        u(~isinframe) = NaN;
        v(~isinframe) = NaN;
        
        CAM{jcam}.gcp.u = u;
        CAM{jcam}.gcp.v = v;
    end
end

%% Plot Each Image
axg = axgrid(sqrt(ncams),sqrt(ncams),0.05,0.05);
figure(2);clf;
for i=1:ncams
    axg(i);
    plot(CAM{i}.tp.u,CAM{i}.tp.v,'m.');
    hold on
    plot(CAM{i}.gcp.u,CAM{i}.gcp.v,'r.','markersize',20);
    set(gca,'ydir','reverse');
    grid on
    axis equal;
    axis([1 CAMPIX(1) 1 CAMPIX(2)]);
end

%% Make Matrix for Least Squares Bundle Adjust

tlseqn = @(b,x) xyz2uv(CAMK,rpy2dcm




%%

% %% Use Essential Matrix to Compute Relative Orientations
% X = cell(ncams,ncams);
% for i=1:ncams
%     for j=1:ncams
%         if i<j
%             % Compute # Matches
%             indmatches = ~isnan(CAM{i}.tp.u) & ~isnan(CAM{j}.tp.u);
%             totmatches = sum(indmatches);
%             
%             totbeta = 2*6 + totmatches*3; % 2 cams, 6 cam EO, xyz(3) for each tiepoint
%             totEqn = totmatches * 2 * 2; %each tiepoint creates (2)uv obs eqn in 2 cams
%             dof = totEqn-totbeta;
%             
% %             fprintf('Observation Equations: %g\n',totEqn)
% %             fprintf('Unknowns             : %g\n',totbeta)
%             if totEqn>totbeta
%                 % Compute Fundamental Matrix Between Image 1 and Image 2
%                 xy1 = [CAM{i}.tp.u(indmatches)' CAM{i}.tp.v(indmatches)'];
%                 xy2 = [CAM{j}.tp.u(indmatches)' CAM{j}.tp.v(indmatches)'];
%                 X{i,j}.dof = dof;
%                 
%                 [X{i,j}.R,X{i,j}.T] = calcNormRelativeRotation(xy1,xy2,CAMK);
%                 figure(100);
%                 if i==PLOTCAMCONNIND || j==PLOTCAMCONNIND
%                     conncolor = 'c';
%                     lw = 3;
%                 else
%                     conncolor = 'k';
%                     lw = 2;
%                 end
%                 plot3([CAM{i}.C(1) CAM{j}.C(1)],...
%                       [CAM{i}.C(2) CAM{j}.C(2)],...
%                       [CAM{i}.C(3) CAM{j}.C(3)],'--','color',conncolor,...
%                       'linewidth',lw)
%                   
%             end
%         end
%     end
% end
% %% Least Squares Combine Relative Orientations
% % AdjustedCams = combineRelativePoses(X);
% 
% % lazy way
% Acam = cell(ncams,1);
% Acam{1}.T = CAM{1}.C';
% Acam{1}.R = CAM{1}.R;
% for a=1:10
%     for i=1:ncams
%         goodcams = cellfun(@(x) ~isempty(x),Acam);
%         if ~goodcams(i)
%             matches = cellfun(@(x) ~isempty(x),X(i,:)) | cellfun(@(x) ~isempty(x),X(:,i)');
%             i1 = cellfun(@(x) ~isempty(x),X(i,:));
%             i2 = cellfun(@(x) ~isempty(x),X(:,i)');
%             
%             npts1 = cellfun(@(x) x.dof,X(i,i1));
%             npts2 = cellfun(@(x) x.dof,X(i2,i));
%             
%             pairind = find(goodcams' & matches);
%             
%             if numel(pairind)>1
%                 dof = [];
%                for ii=1:numel(pairind)
%                    iX = X{min([i,pairind]),max([i,pairind])};
%                    dof(ii) = iX.dof;
%                end
%                [~,pairindind] = max(dof);
%                pairind = pairind(pairindind);
%             end
%             if ~isempty(pairind)
%                 iX = X{min([i,pairind]),max([i,pairind])};
%                 M12 = [iX.R iX.T;0 0 0 1];
%                 M1 = [Acam{pairind}.R Acam{pairind}.T;0 0 0 1];
%                 M2 = M1 * M12;
%                 
%                 Acam{i}.R = M2(1:3,1:3);
%                 Acam{i}.T = M2(1:3,4);
%             end
%         end
%     end
% end
% %%
% figure(101);clf
% CAMPLOTSIZE = 0.1;
% for i=1:ncams
%     optPatch = {'facecolor',cmap(i,:),'faceAlpha',0.5};
%     optLine = {'linewidth',1,'color','k'};
%     optSides = {'faceColor','k','faceAlpha',0.1};
% 
%     plotCameraPyramid(CAMK,Acam{i}.R,Acam{i}.T,CAMPIX,'s',CAMPLOTSIZE,...
%         'optLine',optLine,'optPatch',optPatch,'optSides',optSides);
%     axis equal
%     grid on
%     pause(02)
% end
% % Make Observation Equations
% 
% 
% % Initialize Estimates? 
% 
% 
% 
% 
% % end
