clc, clear, close

%%

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
figure(10)
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

%% temporal threshold
threshold = 40;

linearIndexes = find(walk_g>threshold);  % Find elements with value more than 30
[tp, rows, columns] = ind2sub(size(walk_g), linearIndexes);
% A = [tp, columns, rows];
% A = sortrows(A,[1 2 3]) 
A = [tp, columns];
plot(A)

B = [columns, rows];
plot(columns)


x = abs(diff(A(:,1)));
y = abs(diff(A(:,2)));
z = abs(diff(A(:,3)));

l = vertcat(true,z~=1 & z~=0 & z~=2 & z~= 3);
B = [tp(l), columns(l), rows(l)];

%%
for i= 1:35
    walk_g4 = walk_g(i, :,:);
    walk_g4 = permute(walk_g3, [1 3 2]); % tp, col, row
end   


%% threshold 
% threshold = 20;
% 
% linearIndexes = find(walk_g3>threshold);  % Find elements with value more than 30
% [rows, columns] = ind2sub(size(walk_g3), linearIndexes);
%  
% A = [rows, columns];
% z = diff(columns);
% 
% y = vertcat(true,z~=1 & z~=0 & z~=2 & z~= 3);
% B = [rows(y), columns(y)];
% 
% x = abs(diff(B(:,1)));
% w = vertcat(true,x~=1 & x~=0);
% d = B(:,2);
% C = [B(w) d(w)]



figure(11)
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
plot(D(:,2),D(:,1),'yx')
% names = {'c1';'c2';'c3';'c4';'c5';'c6'};  
% text(C(:,2),C(:,1),names)

%%
C = ischange(columns);

c = columns(C);
d = rows(C);
D = [c d]