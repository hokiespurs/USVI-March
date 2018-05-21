% make plots of solar azimuth/elevation
xlsname = 'flightlogs.xlsx';
[a,b,c] = xlsread('flightlogs.xlsx');
NOSHOW = [35 47 59 62 71];
LOCATIONS = {'Buck Island',...
             'Buck Island',...
             'Buck Island',...
             'Buck Island',...
             'Buck Island',...
             'Buck Island',...
             'Buck Island',...
             'Buck Island',...
             'Buck Island',...
             'Whale Point',...
             'Isaac Bay',...
             'Rod Bay',...
             'Rod Bay',...
             'Jacks Bay',...
             'Cottongarden Point'};
         
TOFF = 4;
LAT = 17.7915399;
LON = -64.6317402;

fnames = b(2:end,16);
mmddyyyy = b(2:end,1);
hhmm = [c{2:end,3}];

t = datenum(mmddyyyy,'mm/dd/yyyy') + hhmm';
t(NOSHOW)=[];
fnames(NOSHOW)=[];
[az,el]=SolarAzEl(t + TOFF/24,LAT*ones(size(t)),LON*ones(size(t)),0*ones(size(t)));

ti = (datenum('19-Mar-2018 00:00:00'):10/60/24:datenum('3-Apr-2018 00:00:00'))';
[azi,eli]=SolarAzEl(ti + TOFF/24,LAT*ones(size(ti)),LON*ones(size(ti)),0*ones(size(ti)));

f = figure(1);clf;hold on
area(ti,eli,-90,'faceColor','y','faceAlpha',0.1)
for ii=1:numel(t)
    plot([t(ii) t(ii)],[-90 el(ii)],'b.-')
    texstr = fixfigstring(fnames{ii});
    h = text(t(ii),1,texstr,...
        'Rotation',90,...
        'Interpreter','latex',...
        'VerticalAlignment','bottom',...
        'fontsize',12);
end
plot([ti(1) ti(end)],[0 0],'k--')

ylim([-25 90])

t1 = datenum('19-Mar-2018 00:00:00');
ii=0;
for i=t1:1:t1+14
    grid on
    ii = ii+1;
    % FORMAT FIGURE
    % overall
    h = gca;
    h.TickLabelInterpreter = 'latex';
    h.FontSize = 14;
    % x axis
    xlim([i+6/24 i+19/24]);
    TICKS = 6:1:19;
    xticks([i+TICKS/24]);
    xticklabels(datestr(i+TICKS/24,'HH:MM'));
    xlabel('Local Time','fontsize',16,'interpreter','latex')
%     xtickangle(90)
    % title
    titlestr = ['Solar Elevation on ' LOCATIONS{ii} ', USVI on ' datestr(i,'mmm dd, yyyy')];
    title(titlestr,'interpreter','latex','fontsize',20)
    % y axis
    ylabel('Solar Elevation(degrees)','fontsize',16,'interpreter','latex')
    yticks([-20:10:90])
    drawnow
    saveas(f,sprintf('%s_SolarAzEl.png',datestr(i,'yyyymmdd')));
end

%% Print Az EL
t = datenum(mmddyyyy,'mm/dd/yyyy') + hhmm';
[az,el]=SolarAzEl(t + TOFF/24,LAT*ones(size(t)),LON*ones(size(t)),0*ones(size(t)));
clc
fprintf('%.1f,%.1f\n',[az,el]');
f2 = figure(2);
histogram(el,0:5:90,'facecolor','y','facealpha',0.2);

h = gca;
h.TickLabelInterpreter = 'latex';
h.FontSize = 14;
ylabel('Number of Flights','fontsize',16,'interpreter','latex')
title('Solar Elevation during all flights','interpreter','latex','fontsize',20)
xlabel('Solar Elevation(degrees)','fontsize',16,'interpreter','latex')
grid on
saveas(f2,'SolarAzEl_Hist.png')