% find overlapping images for white balancing
DOLOADFROMMAT = true;
if ~DOLOADFROMMAT
    DNAME = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\02_RECOLORIMAGES\ALLBUCK';
    DEBUGSKIP = 1;
    allimages = dirname('*.jpg',inf,DNAME);
    ismapimages = cellfun(@(x) contains(x,'MAPIMAGES'),allimages);
    
    mapimages = allimages(ismapimages);
    mapimages = mapimages(1:DEBUGSKIP:end);
    
    nmapimages = numel(mapimages);
    % nmapimages = 10;
    
    starttime = now;
    I = struct('lat', NaN, 'lon', NaN, 't', NaN, 'alt', NaN, 'make', 'fail');
    I(nmapimages).lat = NaN;
    for i=1:nmapimages
        I(i) = getimageinfo(mapimages{i});
        loopStatus(starttime,i,nmapimages,10);
    end
    save('imagelatlonMatchesBuckAll.mat','I','mapimages');
else
    load('imagelatlonMatchesBuckAll.mat');
end
%%
mapfoldernames = cellfun(@(x) fileparts(fileparts(x)),mapimages,'UniformOutput',false);
[uniqueFolders,~,folderid]=unique(mapfoldernames);

lat = [I.lat];
lon = [I.lon];
H = [I.t];
alt = [I.alt];

[x,y]=deg2utm(lat,-lon);

f = figure(1);clf;hold on
% scatter(-lon,lat,20,folderid,'filled');
cmap = jet(max(folderid));
for i=1:max(folderid)
    ind = folderid==i;
   plot(x(ind),y(ind),'.-','color',cmap(i,:));
   [~,printname,~]=fileparts(uniqueFolders{i});
   text(mean(x(ind)),mean(y(ind)),fixfigstring(printname),...
       'HorizontalAlignment','center','backgroundcolor',cmap(i,:));
   fprintf('%s = %.0f\n',printname,i );
end

%%
H = [1.0 1.05 1.05; % 0804_MAVIC_WESTNORTHWEST
     1 1.3 1.4; % 0814_MAVIC_NE
     1.0 1.05 1.15; % 0821_MAVIC_WEST
     1.1 1.2 1.5; % 0841_MAVIC_N
     1 1.15 1.15; % 0856_MAVIC_WESTSOUTHWEST
     0.8 1.2 1.3; % 0909_MAVIC_SEAGRASS1
     1 1.1 1.1; % 0917_MAVIC_SOUTHWEST
     1.6 1.5 1.6; % 0926_MAVIC_NW
     1 1.15 1.2; % 0937_MAVIC_SOUTH
     1 1.25 1.25; % 0956_MAVIC_SOUTHEAST_A
     1 1.25 1.25; % 1615_MAVIC_SOUTHEAST_B
     1.3 1.3 1.2; % 1650_MAVIC_WSUPDEPLOY_A
     1.5 1.4 1.3];% 1708_MAVIC_WSUPDEPLOY_B
 
 H = H./mean(H);
TESTNUMA = 4;
TESTNUMB = 8;

%%
MAXDIST = 100;
figure(2);clf
plot(x,y,'b.');hold on
for i=1:max(folderid)
    for j=1:max(folderid)
        if i<j  & any([i,j]==TESTNUMA) & any([i,j]==TESTNUMB)
            ind1 = find(folderid==i);
            ind2 = find(folderid==j);
            xy1 = [x(ind1) y(ind1)];
            xy2 = [x(ind2) y(ind2)];
            
            [IDX,D] = knnsearch(xy2,xy1);
            
            %         figure(2);clf;hold on
            %         plot(xy1(:,1),xy1(:,2),'b.');
            %         plot(xy2(:,1),xy2(:,2),'b.');
            
            IND = ind1(D<MAXDIST);
            IDX = IDX(D<MAXDIST);
            D = D(D<MAXDIST);
            
            D_IND_IDX = sortrows([D IND IDX]);
            
            TOTNMATCH = 15;
            if numel(D)>15
               D = D_IND_IDX(1:15,1);
               IND = D_IND_IDX(1:15,2);
               IDX = D_IND_IDX(1:15,3);
            else
               D = D_IND_IDX(:,1);
               IND = D_IND_IDX(:,2);
               IDX = D_IND_IDX(:,3); 
            end
                
            for k=1:numel(IND)
                figure(2);
                plot([x(IND(k)) x(ind2(IDX(k)))],[y(IND(k)) y(ind2(IDX(k)))],'m*-');
                drawnow
                pause(0.1);
                [~,printname1,~]=fileparts(mapfoldernames{IND(k)});
                [~,imgname1] = fileparts(mapimages{IND(k)});
                [~,printname2,~]=fileparts(mapfoldernames{ind2(IDX(k))});
                [~,imgname2] = fileparts(mapimages{ind2(IDX(k))});
                
                fprintf('%30s / %10s\n',printname1,imgname1);
                fprintf('%30s / %10s\n',printname2,imgname2);
                fprintf('\n');
                
                figure(10);clf
                I1 = imread(mapimages{IND(k)});
                I2 = imread(mapimages{ind2(IDX(k))});
                % convert RGB
                h1 = ones(size(I1));
                h1(:,:,1)=H(folderid(IND(k)),1);
                h1(:,:,2)=H(folderid(IND(k)),2);
                h1(:,:,3)=H(folderid(IND(k)),3);
                I1b = uint8(double(I1).*h1);
                
                h2 = ones(size(I2));
                h2(:,:,1)=H(folderid(ind2(IDX(k))),1);
                h2(:,:,2)=H(folderid(ind2(IDX(k))),2);
                h2(:,:,3)=H(folderid(ind2(IDX(k))),3);
                I2b = uint8(double(I2).*h2);
                
                subplot 321
                image((I1));
                title(sprintf('%.0f',folderid(IND(k))));
                axis equal;
                subplot 322
                image((I2));
                title(sprintf('%.0f',folderid(ind2(IDX(k)))));
                
                axis equal
                subplot 323
                image((I1b));
                axis equal;
                subplot 324
                image((I2b));
                axis equal
                
                subplot 323
                [ix1a,iy1a]=ginput(1);ix1a = round(ix1a);iy1a=round(iy1a);
                [ix1b,iy1b]=ginput(1);ix1b = round(ix1b);iy1b=round(iy1b);
                hold on
                plot([ix1a ix1b],[iy1a iy1b],'m-');
                
                subplot 324
                [ix2a,iy2a]=ginput(1);ix2a = round(ix2a);iy2a=round(iy2a);
                [ix2b,iy2b]=ginput(1);ix2b = round(ix2b);iy2b=round(iy2b);
                hold on
                plot([ix2a ix2b],[iy2a iy2b],'m-');
                
                r1 = histcounts(I1b(iy1a:iy1b,ix1a:ix1b,1),0:1:255,'Normalization', 'probability');
                g1 = histcounts(I1b(iy1a:iy1b,ix1a:ix1b,2),0:1:255,'Normalization', 'probability');
                b1 = histcounts(I1b(iy1a:iy1b,ix1a:ix1b,3),0:1:255,'Normalization', 'probability');
                
                r2 = histcounts(I2b(iy2a:iy2b,ix2a:ix2b,1),0:1:255,'Normalization', 'probability');
                g2 = histcounts(I2b(iy2a:iy2b,ix2a:ix2b,2),0:1:255,'Normalization', 'probability');
                b2 = histcounts(I2b(iy2a:iy2b,ix2a:ix2b,3),0:1:255,'Normalization', 'probability');

                subplot(9,1,7)
                hold on
                plot(r1,'b-');
                plot(r2,'r-');

                subplot(9,1,8)
                hold on
                plot(g1,'b-');
                plot(g2,'r-');
                
                subplot(9,1,9)
                hold on
                plot(b1,'b-');
                plot(b2,'r-');

                pause(0.05)
            end
        end
    end
end

%%
DOOUT = false;
if DOOUT
%% Resave all images
% Need to save separate CSV with x,y,z
clc
OUTNAME = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\02_RECOLORIMAGES\ALLBUCK\ALLBALANCED';
fid = fopen([OUTNAME '/imagepos.csv'],'w+t');
fprintf(fid,'filename,lat,lon,alt,x(utm),y(utm)\n');
starttime = now;
for i=1:numel(mapimages)
    curfoldername = mapfoldernames{i};
    [~,justfilename] = fileparts(mapimages{i});
    [~,justname] = fileparts(curfoldername);
    newname = [justname '_' justfilename '.jpg'];
    fprintf('%s...%s\n',newname,datestr(now));
    fprintf(fid,'%s,%f,%f,%f,%f,%f\n',newname,lat(i),-lon(i),alt(i),x(i),y(i));
    % convert RGB
    Iraw = imread(mapimages{i});
    h1 = ones(size(I1));
    h1(:,:,1)=H(folderid(i),1);
    h1(:,:,2)=H(folderid(i),2);
    h1(:,:,3)=H(folderid(i),3);
    Ipost = uint8(double(Iraw).*h1);
    
    imwrite(Ipost,[OUTNAME '/' newname],'quality',100);
    loopStatus(starttime,i,numel(mapimages),1);
end
fclose(fid);
end