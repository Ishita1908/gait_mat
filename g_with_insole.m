close, clc, clear
% import data and reshape
gdata = importdata('g_with_insole_4.txt');

% extracting pressure variables
gdatap17 = gdata.data(615:736,1:2832); 
 
% gdatap17(isnan(gdatap17)) =0; % uncomment if nan value is present
 
gpressvar = reshape(gdatap17, 122, 24, 118);


% gpressvar1 = permute(gpressvar, [2 3 1]);

gpressvar2 = mean(gpressvar, 1);
gpressvar2 = permute(gpressvar2, [2 3 1]);

%%

figure(1)
contourf(gpressvar2)
title('Average Spatial Map of Gait mat')
grid(gca,'minor')
grid on
set(gca, 'YMinorTick','on', 'YMinorGrid','on')

set(gcf,'units','points','position',[0,0, 118, 24])

set(gca, 'CLim', [1 40])
colorbar
colormap turbo

%%

figure(2)
surf(gpressvar2)
set(gcf,'units','points','position',[0,0, 118, 24])
rotate3d on
title('3D Average gait map')
xlabel('Rows')
ylabel('Columns')
zlabel('Pressure')
set(gca, 'CLim', [1 40])
colorbar
colormap turbo


%% Temporal map

figure(3)
set(gcf,'units','points','position',[0,0, 118, 24])
% 
for i= 1:122
    gpressvar2 = gpressvar(i, :,:);
    gpressvar2 = permute(gpressvar2, [2 3 1]);
%     
    contourf(gpressvar2)
%    
    title( gdata.textdata{i+614, 1});
    hold all
    pause( 0.01 );
end

