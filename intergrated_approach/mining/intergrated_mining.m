clc; close all;
% clear all;
%% pre processing
% |row| = 221330
% *** raw_data format *** 
% 'id','lecture','run', '+normal', '+repeat','+if', '5#', '10#', '30#', '60#','300#','long#'
% 0,1,2,3,4,5,6,7,8
% 1,402,1,8,0,0,0,0,0
% 2,206,4,13,0,0,3,0,0
raw_data = csvread('../data/intergrated_data.csv',1,0);

% *** lecture_raw_data format *** 
% lecture,run,+normal,+repeat,+if // esclude -normal,-repeat,-if
lecture_raw_data=raw_data(:,2:6);
[lecture_number_list,~,lecture_index] = unique(lecture_raw_data(:,1));
action_count_data=sum(lecture_raw_data(:,2:end),2);

[user_id_list, ~, ~] = unique(raw_data(:,1));


%% Compute guide line(=distribution of actions) of each lecture 
%  *** lecture_guide format *** 
% lecture_number,  run, +normal, +repeat, +if, action_count_top10,
lecture_guide = zeros(length(lecture_number_list), 6);
lecture_guide(:,1)=lecture_number_list;
lecture_guide(:,end) = accumarray(lecture_index,action_count_data, [], @percentile10);

row_count = size(lecture_raw_data,1);
for i=1:row_count
    current_lecture=lecture_index(i);
    current_row_action_count = sum(lecture_raw_data(i,2:end),2);
    if lecture_guide(current_lecture,end) == current_row_action_count
        lecture_guide(current_lecture,2:end-1) = lecture_raw_data(i,2:end);
    end
end
% Now we get lecture_guide

%% Let's compare user's behavior with lecture guide
% 6 users
% target_list = [221 560 242 269 583 354 ];
% figure;
% for i=1:6
%     subplot(3,2,i);
% %     query_user_number = user_id_list(66*i+255);
%     query_user_number = target_list(i);
%     test_user_achievement(query_user_number, raw_data, lecture_guide)
% end

%% time interval 
% 
% % *** time_interval_data format *** 
% % id,lecture,5#,10#,30#,60#,300#,long#
% time_interval_data=raw_data(:,[1 2 7:12]);
% [lecture_number_list,~,lecture_index] = unique(time_interval_data(:,1));
% % figure
% % for i=1:12
% %     target_user_number=user_list(i*14);
% %     subplot(4,3,i)
% %     render_user_all_lecture_interval_dist(raw_data, target_user_number);
% % end
% 
% good_example_user_list=[55 96 139];
% for i=1:1
%     query_user_number=user_id_list(i);
% %     target_user_number = good_example_user_list(i);
%     % In function, it call figure and subplot
%     render_user_lecture_interval_dist(time_interval_data, query_user_number);
% end


%% one user
query_user_number = 1;
test_user_achievement(query_user_number, raw_data, lecture_guide);
render_user_lecture_interval_dist(time_interval_data, query_user_number);