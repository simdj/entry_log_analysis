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

%% Let's measure lecture's complexity by comparing guide with avg(user), median(user)
% x_label_str=arrayfun(@num2str, lecture_number_list, 'UniformOutput', false);
figure;
render_lecture_ct('Lecture Complexity', lecture_guide(:,end), accumarray(lecture_index,action_count_data, [], @median), accumarray(lecture_index,action_count_data, [], @mean),lecture_number_list);
% Let's measure lecture's CT by comparing "REPEAT" guide with avg(user), median(user)
figure;
repeat_guide = lecture_guide(:,4);
repeat_action_count_data=lecture_raw_data(:,4);
repeat_median = accumarray(lecture_index,repeat_action_count_data, [], @median);
repeat_mean = accumarray(lecture_index,repeat_action_count_data, [], @mean);
subplot(1,2,1);
render_lecture_ct('Lecture REPEAT Complexity', repeat_guide, repeat_median, repeat_mean,lecture_number_list);

% Let's measure lecture's CT by comparing "IF" guide with avg(user), median(user)
if_guide = lecture_guide(:,5);
if_action_count_data=lecture_raw_data(:,5);
if_median = accumarray(lecture_index,if_action_count_data, [], @median);
if_mean = accumarray(lecture_index,if_action_count_data, [], @mean);
subplot(1,2,2);
render_lecture_ct('Lecture IF Complexity', if_guide, if_median, if_mean,lecture_number_list);
