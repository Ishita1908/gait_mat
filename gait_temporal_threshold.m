%% 
clc, clear, close

gdata = importdata('gtrial7_i_abnormal.txt');
gdatap17 = gdata.data(:,1:2832); 

% uncomment gpressvar line if not using offset
% gpressvar = reshape(gdatap17, numel(gdatap17(:, 1)), 24, 118);
% 
% gpressvar1 = permute(gpressvar, [2 3 1]);


% uncomment gpressvar2 lines if not using offset
% gpressvar2 = mean(gpressvar, 1);  
% gpressvar2 = permute(gpressvar2, [2 3 1]);


%% offset of gait mat for each press sensor-

% 1:225 baseline 1
% 227:512 main rec
% 513: 683 baseline 2

offset_g1 = mean(gdatap17(1:225, :), 1);
offset_g2 = mean(gdatap17(513:683, :), 1);
offset_g = (offset_g1 + offset_g2)/2;
subtracted_g = gdatap17-offset_g;

walk_g = subtracted_g(227:512, :);
walk_g = reshape(walk_g, numel(walk_g(:, 1)), 24, 118);
walk_g2 = permute(mean(walk_g,1), [2 3 1]);


%%

figure(2)
contourf(walk_g2) %contourf(gpressvar2)
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

figure(3)
surf(walk_g2) %surf(gpressvar2)
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

% figure(3)
% set(gcf,'units','points','position',[0,0, 118, 24])
% % 
% for i= 512:683
%     gpressvar2 = gpressvar(i, :,:);
%     gpressvar2 = permute(gpressvar2, [2 3 1]);
% %     
%     contourf(gpressvar2)
% %    
% %    title( gdata.textdata{i, 1})     % for knowing date and time
%     title(i)     % for knowing time point
%     hold all
%     pause( 0.1);
% end


%%
figure(6)
set(gcf,'units','points','position',[0,0, 118, 24])
% 
% for i= 1:numel(walk_g(:,1,1))
for i= 1:100
    walk_g3 = walk_g(i, :,:);
    walk_g3 = permute(walk_g3, [2 3 1]);

    contourf(walk_g3)
%     set(gcf,'units','points','position',[0,0, 118, 24])

    
%    
    colormap turbo
    colorbar
    set(gca, 'CLim', [30 100])
%    title( gdata.textdata{i+226, 1})     % for knowing date and time
    title(i+226)     % for knowing time point
    
    hold on
    pause( 0.0002 );

end
