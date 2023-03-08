
% import data and reshape
idata = importdata('27_8_22.txt');


% 3840:4523   g_with_insole_6
% 3187:3839   g_with_insole_5   waste
% 2523:3186   g_with_insole_4
% 1758:2322   g_with_insole_3
% 1640:1757   extra test rec
% 878:1639    g_with_insole_2  waste
% 1:878       g_with_insole_1  waste

% insole data var for one rec
idata_var = idata.data(2523:3186,:);
idata_dt = idata.textdata(2523:3186,:);

idata_var_p = idata_var(:, 1:128);

%% spatial map
idata_walk = idata_var(570:640, 1:128);
pressvar = permute(reshape(idata_walk, 71, 8, 16), [3 2 1]); % row*col*timepoint
pressvar2 = mean(pressvar,3);
figure(2)
hold on
contourf(pressvar2)
% grid(gca,'minor')
% grid on
% set(gca, 'YMinorTick','on', 'YMinorGrid','on')
% 
set(gcf,'units','points','position',[0,0, 8, 16])
title('Average Spatial Map')
colorbar
hold off

%% plot total press at each time point as a function of time

total_press = sum(idata_var_p, 2);
total_press_w = total_press(570:end);
figure(3)
plot(total_press_w)



%% regions of foot 

% on Y axis
% hindfoot = 1 to 6
% midfoot = 6 to 8
% forefoot = 8 to 13

hindfoot_press = pressvar(1:6, :, :);
midfoot_press = pressvar(6:8, :, :);
forefoot_press = pressvar(8:13, :, :);

mean_hindfoot = squeeze(mean(hindfoot_press, 1));
mean_midfoot = squeeze(mean(midfoot_press, 1));
mean_forefoot = squeeze(mean(forefoot_press, 1));


figure(4)
plot(sum(mean_hindfoot, 1))
hold on
plot(sum(mean_midfoot, 1))
plot(sum(mean_forefoot, 1))
legend ("Hindfoot", "Midfoot", "Forefoot", 'Location', 'best')
hold off

%% 


