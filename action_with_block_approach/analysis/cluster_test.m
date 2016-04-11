clear all;close all;clc;
rng(10); % for reproducibility
N = 1500;
noise = 0.05;
t = 3*pi/2 * (1 + 2*rand(N,1));
h = 11 * rand(N,1);
% X = [t.*cos(t), h, t.*sin(t)] + noise*randn(N,3);
data = csvread('../data/good_block_action.csv',1,0,[1,0,10000, 5]);
X=data(data(:,2)==409,4:6);

row_sum = sum(X,2);
outlier_border = prctile(row_sum,99);
X=X(row_sum <= outlier_border,:);


% bad_outlier_border = prctile(data,90);
% X=X(X(:,1)<=bad_outlier_border(1) & X(:,2)<=bad_outlier_border(2) & X(:,3)<=bad_outlier_border(3), :);
% good_outlier_border = prctile(data,10);
% X=X(X(:,1)>=good_outlier_border(1) & X(:,2)>=good_outlier_border(2) & X(:,3)>=good_outlier_border(3), :);

figure('units','normalized','Position',[0.2 0.4 0.55, 0.35]),
subplot(1,2,1)





% c = clusterdata(X,'linkage','ward','maxclust',6);
% scatter3(X(:,1),X(:,2),X(:,3),[],c,'fill','MarkerEdgeColor','k');
% view(-20,5)
% title('Agglomerative Clustering')
% [~,aa,~]=unique(c)

subplot(1,2,2)
[idx,center,sum_dist] = kmeans(X,6);

% compute the row totals
row_totals = sum(center,2);

% sort the row totals 
[~, row_ids] = sort(row_totals, 'ascend');
cluster_rank=zeros(length(row_ids),1)
for j=1:length(row_ids)
    cluster_rank(row_ids(j))=j;
end

scatter3(X(:,1),X(:,2),X(:,3),[],cluster_rank(idx),'fill','MarkerEdgeColor','k');
title('KMEANS Clustering')
view(-20,5)
colormap(jet);