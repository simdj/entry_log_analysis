function render_with_kmeans(X, title_name, x_name, y_name)

[Auniq,~,IC] = unique(X(:,1:2),'rows');
cnt = accumarray(IC,1);

size_array =(sqrt(cnt*10)); 
color_array=log(log(log(cnt+1)+1)+1);


%% draw

% scatter3(Auniq(:,1), Auniq(:,2), Auniq(:,3),size_array,color_array, 'filled');
scatter(Auniq(:,1), Auniq(:,2), size_array,color_array, 'filled');
colormap(jet);
axis([0 1 0 1]);
title(title_name);
xlabel(x_name);
ylabel(y_name);

fig1=figure(1);
set(fig1, 'OuterPosition', [0, 0, 900, 900])

%% k-means clustering
rng(1);
[idx, C] = kmeans(X,2);

%% 'Cluster Assignments and Centroids'
figure;
plot(X(idx==1,1),X(idx==1,2),'r.','MarkerSize',12)
hold on
plot(X(idx==2,1),X(idx==2,2),'b.','MarkerSize',12)
plot(C(:,1),C(:,2),'kx',...
     'MarkerSize',15,'LineWidth',3)
legend('Cluster 1','Cluster 2','Centroids',...
       'Location','NE')
title 'Cluster Assignments and Centroids'
xlabel(x_name);
ylabel(y_name);
axis([0 1 0 1]);
hold off

%% divide space

x1 = min(X(:,1)):0.01:max([X(:,1); 1]);
x2 = min(X(:,2)):0.01:max([X(:,2); 1]);
[x1G,x2G] = meshgrid(x1,x2);
XGrid = [x1G(:),x2G(:)]; % Defines a fine grid on the plot

idx2Region = kmeans(XGrid,2,'MaxIter',1,'Start',C);... % Assigns each node in the grid to the closest centroid

figure;
gscatter(XGrid(:,1),XGrid(:,2),idx2Region,...
    [1,0,0; 0,0,1],'..');
hold on;
% plot(X(:,1),X(:,2),'k*','MarkerSize',5);
scatter(Auniq(:,1), Auniq(:,2), size_array,color_array, 'filled');
colormap(jet);
axis([0 1 0 1]);
title(title_name);
xlabel(x_name);
ylabel(y_name);
legend('Region 1','Region 2','Data','Location','NE');



hold off;