% clc, clear, close

% import data and reshape
gdata = importdata('gdemo1.txt');

% extracting pressure variables
gdatap17 = gdata.data(1:54,1:2832); 
 
gdatap17(isnan(gdatap17)) =0;
 
gpressvar = reshape(gdatap17, 54, 24, 118);


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
for i= 1:54
    gpressvar2 = gpressvar(i, :,:);
    gpressvar2 = permute(gpressvar2, [2 3 1]);
%     
    contourf(gpressvar2)
%    
    title( gdata.textdata{i, 2});
    hold all
    pause( 0.5 );
end


% a = mean(pressvar(1:6, :, :),1);
% b = mean(pressvar(7:12, :, :),1);
% c = mean(pressvar(13:19, :, :),1);
% d = mean(pressvar(20:24, :, :),1);
% e = mean(pressvar(25:30, :, :),1);
% f = mean(pressvar(31:35, :, :),1);
% 
% figure(4)
% subplot(231)
% contourf(permute(a, [2 3 1]))
% title('Nothing')
% 
% hold on
% subplot(232)
% contourf(permute(b, [2 3 1]))
% title('Normal')
% 
% subplot(233)
% contourf(permute(c, [2 3 1]))
% title('Toes')
% 
% subplot(234)
% contourf(permute(d, [2 3 1]))
% title('Heels')
% 
% subplot(235)
% contourf(permute(e, [2 3 1]))
% title('Toes')
% 
% subplot(236)
% contourf(permute(f, [2 3 1]))
% title('Nothing')
% hold off
% colormap turbo