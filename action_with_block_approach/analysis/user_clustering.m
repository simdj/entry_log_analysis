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
