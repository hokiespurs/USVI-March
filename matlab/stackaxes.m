%% STACKED AXES DEMO
% This could probaby be automated in a nice function

figure(1);clf

mushiness = @(x) 10-x;
color = @(x) log(x);
fruitflies = @(x) x.^2;

YTICKVALS = 1:10;
XTICKVALS = 1:15;
LABELTHINGS = {'fontsize',12,'interpreter','latex'};

% Main plot
ax1 = axes('position',[0.3,0.2,0.6,0.7]);
plot(10./(XTICKVALS)+1,'b.-')

ylabel('Goodness [tastiness]',LABELTHINGS{:});
xlabel('Time [days]',LABELTHINGS{:});
title('Banana Metrics',LABELTHINGS{:},'fontsize',18);
set(ax1,'ticklabelinterpreter','latex');
ax1.YTick = YTICKVALS;
ax1.XTick = XTICKVALS;

xlim(ax1,[min(XTICKVALS) max(XTICKVALS)]);
ylim(ax1,[min(YTICKVALS) max(YTICKVALS)]);
grid on

% extra y label
ax2 = axes('position',[0.2,0.2,0,0.7]);
ylabel('Mushiness [mushhh]',LABELTHINGS{:});
set(ax2,'ticklabelinterpreter','latex');
ax2.YTick = YTICKVALS;
xlim(ax1,[min(XTICKVALS) max(XTICKVALS)]);
ylim(ax1,[min(YTICKVALS) max(YTICKVALS)]);

mushvals = mushiness(YTICKVALS);
mushvalstr = num2str(mushvals');
ax2.YTickLabel = mushvalstr;

% extra y label
ax3 = axes('position',[0.1,0.2,0,0.7]);
ylabel('Color [yellowness]',LABELTHINGS{:});
set(ax3,'ticklabelinterpreter','latex');
ax3.YTick = YTICKVALS;
xlim(ax1,[min(XTICKVALS) max(XTICKVALS)]);
ylim(ax1,[min(YTICKVALS) max(YTICKVALS)]);

colorvals = color(YTICKVALS);
colorvalstr = sprintf('%+0.2f',colorvals)';
colorvalstrGood = reshape(colorvalstr,5,numel(YTICKVALS))';
ax3.YTickLabel = colorvalstrGood;

% extra x label
ax4 = axes('position',[0.3,0.1,0.6,0]);
xlabel('Time [FruitFlies]',LABELTHINGS{:});
set(ax4,'ticklabelinterpreter','latex');
ax4.XTick = XTICKVALS;

flyvals = fruitflies(XTICKVALS);
flyvalstr = num2str(flyvals');
ax4.XTickLabel = flyvalstr;

% link everyone
linkaxes([ax1,ax2,ax3,ax4],'xy');
xlim(ax1,[min(XTICKVALS) max(XTICKVALS)]);
ylim(ax1,[min(YTICKVALS) max(YTICKVALS)]);

