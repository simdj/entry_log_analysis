clc; close all;
% clear all;
%% pre processing
% |row| = 221330
% *** raw_data format *** 
% id,lecture,run,+normal,+repeat,+if // esclude -normal,-repeat,-if
% 0,1,2,3,4,5,6,7,8
% 1,402,1,8,0,0,0,0,0
% 2,206,4,13,0,0,3,0,0
raw_data = csvread('../data/good_block_action.csv',1,0,[1,0, 100000 5]);

% *** lecture_raw_data format *** 
% lecture,run,+normal,+repeat,+if // esclude -normal,-repeat,-if
lecture_raw_data=raw_data(:,2:end);
[lecture_number_list,~,lecture_index] = unique(lecture_raw_data(:,1));
action_count_data=sum(lecture_raw_data(:,2:end),2);

[user_id_list, ~, ~] = unique(raw_data(:,1));


%% Compute guide line(=distribution of actions) of each lecture 
%  *** lecture_guide format *** 
% lecture_number,  run, +normal, +repeat, +if, action_count_top10,
% (deprecated) selected_action_count,selected_index,
lecture_guide = zeros(length(lecture_number_list), 6);
lecture_guide(:,1)=lecture_number_list;
lecture_guide(:,end) = accumarray(lecture_index,action_count_data, [], @percentile);

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
target_list = [221 560 242 269 583 354 ];
figure;
for i=1:6
    subplot(3,2,i);
%     query_user_number = user_id_list(66*i+255);
    query_user_number = target_list(i);
    test_user_achievement(query_user_number, raw_data, lecture_guide)
end