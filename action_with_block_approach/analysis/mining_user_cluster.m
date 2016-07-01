clc; close all;
% clear all;
%% pre processing
% |row| = 221330
% *** raw_data format *** 
% id,lecture,run,+normal,+repeat,+if // esclude -normal,-repeat,-if
% 0,1,2,3,4,5,6,7,8
% 1,402,1,8,0,0,0,0,0
% 2,206,4,13,0,0,3,0,0

data = csvread('../data/good_block_action.csv',1,0,[1,0, 50000 5]);
% data = csvread('../../intergrated_approach_2016_summer/data/data.csv',2,0);

% filter only user course 4
data = data(data(:,2)>400,:);

% % *** user_behavior format *** 
% % user_id,+normal,+repeat,+if 
[user_id_list, ~, user_index] = unique(data(:,1));
user_behavior = zeros(length(user_id_list), 4);
user_behavior(:,1) = user_id_list;
user_behavior(:,2) = accumarray(user_index,data(:,4), [], @mean);
user_behavior(:,3) = accumarray(user_index,data(:,5), [], @mean);
user_behavior(:,4) = accumarray(user_index,data(:,6), [], @mean);

normalized_data(:,2:4) = bsxfun(@rdivide,user_behavior(:,2:4),sum(user_behavior(:,2:4),2));
% k=5;
% idx = kmeans(user_behavior, k);



%% cluster_3d_viewer
% generate 3D dataset here.
% You may put your cluster data into P.
rng(1);
k = 5;
% cluster_data=bsxfun(@rdivide,user_behavior(:,2:4),sum(user_behavior(:,2:4),2))';
cluster_data = user_behavior(:,2:4)';
[cluster_idx,C,sumd] = kmedoids(cluster_data', k);
figure;
hold on;

Center = zeros(3, k);
clrMap = hsv(k);

for kk = 1:k
    plot3(cluster_data(1, cluster_idx==kk), cluster_data(2, cluster_idx==kk), cluster_data(3, cluster_idx==kk), 'LineStyle', 'none','Marker', 'o', 'color', clrMap(kk,:));
    xmean = mean(cluster_data(1, cluster_idx==kk));
    ymean = mean(cluster_data(2, cluster_idx==kk));
    zmean = mean(cluster_data(3, cluster_idx==kk));
    
    text(xmean, ymean, zmean, num2str(kk), 'color', 'k','FontWeight', 'Bold');
end

title('User cluster');
xlabel('Normal');
ylabel('Repeat');
zlabel('If');
grid on;
view(-45, 25);

view(0,0); % (normal, if)
view(0,90); % (normal,repeat)
view(90,0); % (repeat, if)

view(-45,25); %3D




%% deciding K
% max_k=10;
% sumd_list=1:max_k;
% for kkk=1:max_k
%     [~,~,sumd] = kmedoids(cluster_data', kkk);
%     sumd_list(kkk)=sum(sumd);
% end
% plot(1:max_k, sumd_list');
% ylabel('Sum of distances within cluster');
% xlabel('K');
