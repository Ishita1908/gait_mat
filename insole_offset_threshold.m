close, clc, clear

idata = importdata('DATALOG_3_8_22.txt');

% 1 to 9    % waste
% 10 to 741       g_with_insole_7.txt
% 742 to 1779     g_with_insole_8.txt
% 1780 to 2571    g_with_insole_9.txt
% 2572 to 3287    g_with_insole_10.txt
% 3288 to 4030    g_with_insole_11.txt

% 4031 to 5424    p_with_insole_6.txt
% 5425 to 6833    p_with_insole_7.txt
% 6834 to 8212    p_with_insole_8.txt
% 8213 to 9598    p_with_insole_10.txt
% 9599 to 10999   p_with_insole_11.txt

idata_var = idata.data(2572:3287,:); % data start and end timepoints
idata_dt = idata.textdata(2572:3287,:);

idata_var_p = idata_var(:, 1:128);

%% finding coordinates for offset

plot(sum(idata_var_p, 2))
% set(gca, 'XLim, [250 to 430])

% offset 1 to 275 and 401 to 716
% walk 325 to 400 

%% cal and subtracting offset for each press sensor

offset1 = mean(idata_var_p(1:275, :), 1);
offset2 = mean(idata_var_p(401:701, :), 1);

final_offset = (offset1 + offset2)/2;

req_meas = idata_var_p(325:400, :)- final_offset;

%% spatial map

pressvar = permute(reshape(req_meas, 76, 8, 16), [3 2 1]); % row*col*timepoint
pressvar2 = mean(pressvar,3);
figure(2)
hold on
contourf(pressvar2)
xlabel('Col along width')
ylabel('Rows along length')
title('Spatial Map')
% grid(gca,'minor')
% grid on
% set(gca, 'YMinorTick','on', 'YMinorGrid','on')
% 
set(gcf,'units','points','position',[0,0, 8, 16])
% title('Average Spatial Map')
colorbar
hold off


%%  plot total press for each time point
figure(3)
plot(sum(req_meas,2))

%% regions of foot 

% on Y axis
% hindfoot = 3 to 6
% midfoot = 6 to 8
% forefoot = 8 to 14

hindfoot_press = pressvar(3:6, :, :);
midfoot_press = pressvar(6:8, :, :);
forefoot_press = pressvar(8:14, :, :);

mean_hindfoot = squeeze(mean(hindfoot_press, 1));
mean_midfoot = squeeze(mean(midfoot_press, 1));
mean_forefoot = squeeze(mean(forefoot_press, 1));


figure(4)
plot(sum(mean_hindfoot, 1))
hold on
plot(sum(mean_midfoot, 1))
plot(sum(mean_forefoot, 1))
legend ("Heel", "Arch", "Toes", 'Location', 'best')
xlabel('Timepoints')
ylabel('Average Pressure')
title('Average press of each region of foot')
hold off

%% calculate gait temporal variables

% cadence = no. of peaks in total presss*2 / total time in min
[pks,locs, width, prom] = findpeaks(sum(req_meas, 2), 'MinPeakDistance',10, 'MinPeakHeight',1000);


x = 1:numel(sum(req_meas, 2));
x_peaks = x(locs)/12.5; % 12.5 is sampling _freq

figure(3)
plot(x/12.5, sum(req_meas, 2),  x_peaks,pks,'pr')
xlabel('Time (sec)')
ylabel('Total Pressure')
title('Peaks of Total Pressure')
% single stance time = duration of peak (single stance time is time spent on one foot)
single_stance_time = 1.7*width/12.5;


% not sure about this....should be less than stance time as it has double
%support time as well

% Stance time is defined as the duration of the time between heel strike and toe off of the same foot. 
% It comprises single support and double support.



%% Cadence from acceleration data


idata_acc = idata_var(:, 129:131); % total data of acc
idata_acc_walk = idata_acc(325:400, :); % acc during walking

walk_time = 325:1:400;
acc_x = idata_acc_walk(:, 1);
acc_y = idata_acc_walk(:, 2);
acc_z = idata_acc_walk(:, 3);

mag = sqrt(sum(acc_x.^2 + acc_y.^2 + acc_z.^2, 2));

figure(5)
plot(acc_x)
hold on
plot(acc_y)
plot(acc_z)
hold off
figure(6)
magNoG = mag - mean(mag);
plot(magNoG)


minPeakHeight = std(magNoG);
figure(7)
[pks,locs] = findpeaks(magNoG,'MINPEAKHEIGHT',minPeakHeight);

% The number of steps taken is the number of peaks found.
numSteps = numel(pks)

% The peak locations can be visualized with the acceleration magnitude data.
hold on;
plot(walk_time(locs), pks, 'r', 'Marker', 'v', 'LineStyle', 'none');
title('Counting Steps');
xlabel('Time (s)');
ylabel('Acceleration Magnitude, No Gravity (m/s^2)');
hold off

%%  gait mat - subtract offset 

gdata = importdata('g_with_insole_10.txt');
gdatap17 = gdata.data(:,1:2832); 
 
% gdatap17(isnan(gdatap17)) =0; % uncomment if nan value is present
 
% uncomment gpressvar line if not using offset
% gpressvar = reshape(gdatap17, 359, 24, 118);

% gpressvar1 = permute(gpressvar, [2 3 1]);


% uncomment gpressvar2 lines if not using offset
% gpressvar2 = mean(gpressvar, 1);  
% gpressvar2 = permute(gpressvar2, [2 3 1]);

%% offset of gait mat for each press sensor-
% 
offset_g1 = mean(gdatap17(1:300, :), 1);
% offset_g2 = mean(gdatap17(336:359, :), 1);
% offset_g = (offset_g1 + offset_g2)/2;
subtracted_g = gdatap17-offset_g1;

walk_g = subtracted_g(301:335, :);
walk_g = reshape(walk_g, 35, 24, 118);
walk_g2 = permute(mean(walk_g,1), [2 3 1]);



%%

figure(8)
contourf(walk_g2)
title('2D Average Spatial Map')
grid(gca,'minor')
grid on
set(gca, 'YMinorTick','on', 'YMinorGrid','on')
xlabel('Rows along Length')
ylabel('Width')

set(gcf,'units','points','position',[0,0, 118, 24])
set(gca, 'CLim', [0 40])
colorbar
colormap turbo

figure(9)
surf(walk_g2)
title('3D Average Spatial Map')
grid(gca,'minor')
grid on
set(gca, 'YMinorTick','on', 'YMinorGrid','on')
xlabel('Rows along Length')
ylabel('Width')
zlabel('Pressure')
set(gcf,'units','points','position',[0,0, 118, 24])
set(gca, 'CLim', [0 40])
colorbar
colormap turbo



%%
figure(9)
set(gcf,'units','points','position',[0,0, 118, 24])
% 
for i= 1:35
    walk_g3 = walk_g(i, :,:);
    walk_g3 = permute(walk_g3, [2 3 1]);

    contourf(walk_g3)
%    
    colorbar
    set(gca, 'CLim', [30 100])
    title( gdata.textdata{i+300, 1});
    hold on
    pause( 0.5 );

end

%% threshold 
threshold = 20;

linearIndexes = find(walk_g3>threshold);  % Find elements with value more than 30
[rows, columns] = ind2sub(size(walk_g3), linearIndexes);
 
A = [rows, columns];
z = diff(columns);

y = vertcat(true,z~=1 & z~=0 & z~=2 & z~= 3);
B = [rows(y), columns(y)];

x = abs(diff(B(:,1)));
w = vertcat(true,x~=1 & x~=0);
d = B(:,2);
C = [B(w) d(w)]



figure(10)
contourf(walk_g2)
title('Average Spatial Map of Gait mat')
grid(gca,'minor')
grid on
set(gca, 'YMinorTick','on', 'YMinorGrid','on')

set(gcf,'units','points','position',[0,0, 118, 24])

set(gca, 'CLim', [0 40])
colorbar
colormap turbo
hold on

plot(C(:,2),C(:,1),'yx')
names = {'c1';'c2';'c3';'c4';'c5';'c6'};  
text(C(:,2),C(:,1),names)

%% Distance variables
step_x  = abs(3*(C(1, 1)-C(2,1)))
step_y = abs(3*(C(1, 2)-C(2,2)))
step_l = sqrt((step_x)^2+(step_y)^2)
step_angle  = rad2deg(atan(step_y/step_x)) 

stride_x = abs(3*(C(1, 1)-C(3,1)))
stride_y = abs(3*(C(1, 2)-C(3,2)))
stride_l = sqrt((stride_x)^2+(stride_y)^2)

%degree_of_toe_out
%step_angle

%% 

% a = [1,2,3,7,10,11,12];
% x = [diff(a)~=1,true];  % to grab the last index
% a(x) 
% ans =
%      3     7    12

% threshold = 20;
% 
% linearIndexes = find(walk_g3>threshold);  % Find elements with value more than 30
% [rows, columns] = ind2sub(size(walk_g3), linearIndexes);
%  
% A = [rows, columns];
% z = diff(columns);
% 
% y = [z~=1 & z~=0 & z~=2 & z~= 3, true];
% B = [rows(y), columns(y)];
% 
% x = abs(diff(B(:,1)));
% w = [x~=1 & x~=0, true];
% d = B(:,2);
% C = [B(w) d(w)]
% 
% % a = [1,2,3,7,10,11,12];
% % x = [diff(a)~=1,true];  % to grab the last index
% % a(x)
% 
% % a = [10 11 12 19 21 25 29 30 31 32 33 39 50];
% % >> D = diff([0,diff(a)==1,0]);
% % >> first = a(D>0)