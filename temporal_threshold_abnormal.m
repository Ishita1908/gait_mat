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

% this is temporal map, 

figure(6)
set(gcf,'units','points','position',[0,0, 118, 24])
% 
for i= 1:numel(walk_g(:,1,1))  % takes too long to run
% for i= 39:100   % run this line and not above line if short of time to
% visulize the data
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
    pause( 0.002 );

end

%%

threshold = 50;

linearIndexes = find(walk_g>threshold);  % Find elements with value more than threshold
[tp, rows, columns] = ind2sub(size(walk_g), linearIndexes);
A = [tp, columns, rows]; %store timepoints, columns and rows in matrix A
A = sortrows(A,[1 2 3]); % sort first on basis of tp and then on basis of columns

% take points from 39th time point
A = A(747:end, :, :);  % from 39th timepoint because data before that was not very clean


A = sortrows(A,[3 1 2]); % sort on  basis of rows to divide the right and left feet data easily
A1 = A(1:1624, :, :);  % A1 contains left foot data
A2 = A(1625:end, :, :); % A2 has right foot data

A1 = sortrows(A1,[1 2 3]);  % sort again on the basis of tp and then on basis of columns
A2 = sortrows(A2,[1 2 3]);

mi = min(A1, [], 1);  % mi contains first tp, y and coresponding x in A1
y1 = mi(2);
x1 = mi(3);

TFP = A1(:,1)  <= mi(1);   % looks for tp in A1 smaller than tp in mi
A1(TFP,:) = [];   % remove tp, y and x corresponging to that tp

TY = A1(:,2)  <= mi(2);    % looks for y in A smaller than y in mi
A1(TY,:) = [];   % remove those rows containing y smaller

TFP = A2(:,1)  <= mi(1);    % now remove those from A2 because person will step second foot in front of the first foot while walking
A2(TFP,:) = [];    

TY = A2(:,2)  <= mi(2);   
A2(TY,:) = []; 

% same process for A2 (second foot)
mj = min(A2, [], 1);  
y2 = mj(2); 
x2 = mj(3);

TFP2 = A2(:,1)  <= mj(1);  
A2(TFP2,:) = [];   

TY2 = A2(:,2)  <= mj(2);   
A2(TY2,:) = [];   


TFP2 = A1(:,1)  <= mj(1);   % removing from A1 also
A1(TFP2,:) = [];   

TY2 = A1(:,2)  <= mj(2);   
A1(TY2,:) = [];   






% id = A1(:,1)==mi(1);    % finding index of all tp equal to that tp
% tp = A1(:,1);
% columns = A1(:,2);
% rows = A1(:,3);
% B1 = [tp(id), columns(id), rows(id)]; % getting all y and x corresponding to that tp


%search for min y in B1 and store y and correspoding x as y1 and x1 


% a1 = abs(diff(A1(:,2)));
% 
% a2 = abs(diff(A2(:,2)));

%
% m1 = vertcat(true, a1~=0 & a1~= 1);
% B1 = [tp(m1), columns(m1), rows(m1)];
% 
% m2 = vertcat(true, a2~=0 & a2~= 1);
% B2 = [tp(m2), columns(m2), rows(m2)];




