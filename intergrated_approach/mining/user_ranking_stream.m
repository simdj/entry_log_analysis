% clc; close all;
% clear all;
rng(1)
%% pre processing
% |row| = 221330
% *** raw_data format *** 
% 'id','lecture','run', '+normal', '+repeat','+if', '5#', '10#', '30#', '60#','300#','long#'
% 0,1,2,3,4,5,6,7,8
% 1,402,1,8,0,0,0,0,0
% 2,206,4,13,0,0,3,0,0
% raw_data = csvread('../data/intergrated_data.csv',1,0);
% raw_data = csvread('../data/intergrated_data_2015.csv',1,0);
raw_data = csvread('../../intergrated_approach_2016_summer/data/data_train.csv',3,0);
% filter only user course 4
% data = data(data(:,2)>400,:); # already filtered in generating.py
[user_id_list, ~, ~] = unique(raw_data(:,1));
[lecture_number_list, ~, ~] = unique(raw_data(:,2));


%% get center list of each lecture
k=9;
feature_number = 3;
center_data=get_lecture_cluster_center(raw_data, k,feature_number,1);
% d=squeeze(center_data(3,:,:));

%% get block count of each center
center_block_count = zeros(size(center_data,1),k);
for i=1:size(center_data,1)
    center_block_count(i,:)=sum(squeeze(center_data(i,:,:)),2);
end
% render bar graph showing complexity of each lecture
figure;
bar(center_block_count);
% legend('User', 'Guide');
title('#Action of each cluster center in lecture')
ylabel('#Action','FontSize',20);
xlabel('Lecture','FontSize',20);
ylim([0 50]);
x_label_str=arrayfun(@num2str, lecture_number_list, 'UniformOutput', false);
set(gca,'XTickLabel', x_label_str','XTick',1:numel(x_label_str), 'fontsize',16);
for i=1:k
    center_action_legendInfo{i} = ['Rank ' num2str(i)];
end
legend(center_action_legendInfo,'FontSize',16, 'Location','northwest')
colormap(jet)
%% get stream of user ranking 
% % % 6 users
% target_list = [42 8]
% % close all
% 
% figure
% 
% for i=1:2
%     hold on
%     query_user_number = target_list(i);
% %     query_user_number = user_id_list(170+i);
%     
%     user_data = raw_data(raw_data(:,1)==query_user_number,:);
%     % render_user_ranking
%     render_user_ranking_stream(center_data, user_data, lecture_number_list,k)
%     hold off
%     legendInfo{i} = ['user ' num2str(query_user_number)];
% end
% legend(legendInfo,'FontSize',16, 'Location','best')
% title('Rank plot of user ','FontSize',20);
% 
% % target_list = [1 173 279 170  312   320 583 342 242 364 571 789 ];
% % close all
% figure
% target_list = [42 402 40 8 6 14 72];
% for i=1:6
%     subplot(2,3,i)
%     query_user_number = target_list(i);
% %     query_user_number = user_id_list(310+i);
%     
%     user_data = raw_data(raw_data(:,1)==query_user_number,:);
%     % render_user_ranking
%     render_user_ranking_stream(center_data, user_data, lecture_number_list,k)
%     title(strcat('Rank plot of user  ',num2str(query_user_number)),'FontSize',20);
% end
