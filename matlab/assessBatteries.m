%% Load Data
% BIGBAT = load('P:\Simpson_share\Projects\USVI_UAS_BATHY\S900_Logs\LOGS\117.BIN-129081.mat');
% LILBAT = load('P:\Simpson_share\Projects\USVI_UAS_BATHY\S900_Logs\LOGS\116.BIN-139284.mat');
LILBAT = load('P:\Simpson_share\Projects\USVI_UAS_BATHY\S900_Logs\LOGS\118.BIN-130055.mat');
BIGBAT = load('P:\Simpson_share\Projects\USVI_UAS_BATHY\S900_Logs\LOGS\120.BIN-71501.mat');

%% Plot Current
tb = BIGBAT.CURR(:,2)/1000-BIGBAT.CURR(1,2)/1000;
tl = LILBAT.CURR(:,2)/1000-LILBAT.CURR(1,2)/1000;

figure(1);clf
subplot(2,2,1)
plot(tb,BIGBAT.CURR(:,6)/100,'r-','linewidth',3);
hold on
plot(tl,LILBAT.CURR(:,6)/100,'b-','linewidth',3);
grid on

set(gca,'fontsize',16,'TickLabelInterpreter','latex');
legend({'Big Battery','Little Battery'},'fontsize',20,'interpreter','latex');
xlabel('Time(s)','fontsize',20,'interpreter','latex');
ylabel('Current(Amps)','fontsize',20,'interpreter','latex');
title('Current','fontsize',24,'interpreter','latex');
%% Plot Current Draw
subplot(2,2,3);
ahb = BIGBAT.CURR(:,8)/1000;
ahl = LILBAT.CURR(:,8)/1000;
indA = 100;
indB = 200;

pb = polyfit(tb(1:end),ahb(1:end),1);
pl = polyfit(tl(1:end),ahl(1:end),1);

plot(tb,ahb,'r.-','linewidth',3,'markersize',20);
hold on
plot(tl,ahl,'b.-','linewidth',3,'markersize',20);

ti = [0 500];
ahb_line = polyval(pb,ti);
ahl_line = polyval(pl,ti);

plot(ti,ahb_line,'k--','linewidth',2);
plot(ti,ahl_line,'k--','linewidth',2);

grid on

set(gca,'fontsize',16,'TickLabelInterpreter','latex');
bigbatstr = sprintf('Big Battery (%.2f Amp/min = %.1f min Flight Duration (80\\%%)',...
    pb(1)*60,16/(pb(1)*60)*0.8);
lilbatstr = sprintf('Little Battery (%.2f Amp/min = %.1f min Flight Duration (80\\%%)',...
    pl(1)*60,10.9/(pl(1)*60)*0.8);

legend({bigbatstr,lilbatstr},'fontsize',20,'interpreter','latex');
xlabel('Time(s)','fontsize',20,'interpreter','latex');
ylabel('Capacity Used (Amps)','fontsize',20,'interpreter','latex');
title('Used Capacity','fontsize',24,'interpreter','latex');
%% Plot Voltage
subplot(2,2,2);
tb = BIGBAT.CURR(:,2)/1000-BIGBAT.CURR(1,2)/1000;
tl = LILBAT.CURR(:,2)/1000-LILBAT.CURR(1,2)/1000;
vb = BIGBAT.CURR(:,5)/100;
vl = LILBAT.CURR(:,5)/100;

plot(tb,vb,'r.-','linewidth',3,'markersize',20);
hold on
plot(tl,vl,'b.-','linewidth',3,'markersize',20);

grid on

set(gca,'fontsize',16,'TickLabelInterpreter','latex');
legend({'Big Battery','Little Battery'},'fontsize',20,'interpreter','latex');
xlabel('Time(s)','fontsize',20,'interpreter','latex');
ylabel('Voltage(V)','fontsize',20,'interpreter','latex');
title('Voltage','fontsize',24,'interpreter','latex');
%% Plot Relative Voltage
subplot(2,2,4);
plot(tb,vb-vb(1),'r.-','linewidth',3,'markersize',20);
hold on
plot(tl,vl-vl(1),'b.-','linewidth',3,'markersize',20);

set(gca,'fontsize',16,'TickLabelInterpreter','latex');
legend({'Big Battery','Little Battery'},'fontsize',20,'interpreter','latex');
xlabel('Time(s)','fontsize',20,'interpreter','latex');
ylabel('Relative Voltage(V)','fontsize',20,'interpreter','latex');
title('Voltage Sag','fontsize',24,'interpreter','latex');

%% Plot Throttle 
tb_rci = BIGBAT.RCIN(:,2)/1000 - BIGBAT.RCIN(1,2)/1000;
tl_rci = LILBAT.RCIN(:,2)/1000 - LILBAT.RCIN(1,2)/1000;
rcib = BIGBAT.RCIN(:,5);
rcil = LILBAT.RCIN(:,5);

tb_rco = BIGBAT.RCOU(:,2)/1000 - BIGBAT.RCOU(1,2)/1000;
tl_rco = LILBAT.RCOU(:,2)/1000 - LILBAT.RCOU(1,2)/1000;
rcob = BIGBAT.RCOU(:,5);
rcol = LILBAT.RCOU(:,5);

figure(2);clf
plot(tb_rci, rcib,'m.--','linewidth',3,'markersize',20);
hold on
plot(tb_rco, rcob,'r.-','linewidth',3,'markersize',20);
plot(tl_rci, rcil,'c.--','linewidth',3,'markersize',20);
plot(tl_rco, rcol,'b.--','linewidth',3,'markersize',20);

set(gca,'fontsize',16,'TickLabelInterpreter','latex');
legend({'Big Battery RCIN','Big Battery RCOUT',...
    'Little Battery RCIN','Little Battery RCOUT'},...
    'fontsize',20,'interpreter','latex');
xlabel('Time(s)','fontsize',20,'interpreter','latex');
ylabel('PWM','fontsize',20,'interpreter','latex');
title('Channel 3 PWM','fontsize',24,'interpreter','latex');

%% Lowpass Filter Throttle

FILTLENGTH = 60;
rcob_filt = conv(rcob,ones(FILTLENGTH,1)./FILTLENGTH,'same');
rcol_filt = conv(rcol,ones(FILTLENGTH,1)./FILTLENGTH,'same');

figure(3);clf
plot(tb_rci, rcib,'m.--','linewidth',3,'markersize',20);
hold on
plot(tb_rco, rcob_filt,'r.-','linewidth',3,'markersize',20);
plot(tl_rci, rcil,'c.--','linewidth',3,'markersize',20);
plot(tl_rco, rcol_filt,'b.--','linewidth',3,'markersize',20);

set(gca,'fontsize',16,'TickLabelInterpreter','latex');
legend({'Big Battery RCIN','Big Battery RCOUT',...
    'Little Battery RCIN','Little Battery RCOUT'},...
    'fontsize',20,'interpreter','latex');
xlabel('Time(s)','fontsize',20,'interpreter','latex');
ylabel('PWM','fontsize',20,'interpreter','latex');
title('Channel 3 PWM','fontsize',24,'interpreter','latex');

