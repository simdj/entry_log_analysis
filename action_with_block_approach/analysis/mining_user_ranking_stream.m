clc; close all;
% clear all;
%% pre processing
% |row| = 221330
% *** raw_data format *** 
% id,lecture,run,+normal,+repeat,+if // exclude -normal,-repeat,-if
% 1,402,1,8,0,0, //0,0,0
% 2,206,4,13,0,0,//3,0,0
data = csvread('../data/good_block_action.csv',1,0,[1,0,10000, 5]);
% filter only user course 4
% data = data(data(:,2)>400,:); # already filtered in generating.py

%% get center list of each lecture
k=7;
feature_number = 3;
center_data=mining_get_lecture_cluster_center(data, k,feature_number);
%  squeeze(cluster_center_3d_list(3,:,:))


%% get stream of user ranking 
[user_id_list, ~, ~] = unique(data(:,1));
[lecture_number_list, ~, ~] = unique(data(:,2));

% 6 users
% target_list = [1 2 242 269 583 354 ];
figure
for i=1:7
    hold on
    query_user_number = user_id_list(i);
    user_data = data(data(:,1)==query_user_number,:);
    % render_user_ranking
    render_user_ranking_stream(center_data, user_data, lecture_number_list,k)
    hold off
    legendInfo{i} = ['user ' num2str(query_user_number)];
end
legend(legendInfo,'FontSize',20)
title('User rank vs lecture','FontSize',20);