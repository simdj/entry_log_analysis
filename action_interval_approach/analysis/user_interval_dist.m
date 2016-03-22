clc; close all;
% clear all;
% interval_dist(user, lecture)
% interval_dist(user, all_lecture)
% interval_dist(all user, lecture)

%% pre processing
% raw_data = csvread('../data/good_interval_freq.csv',1,0);
% raw_data = csvread('../data/good_interval_freq_right_after_if.csv',1,0);
% raw_data = csvread('../data/good_interval_freq_right_after_repeat.csv',1,0);

% raw_data = csvread('../data/good_interval_freq_10_49.csv',1,0);
% raw_data = csvread('../data/good_interval_freq_right_after_if.csv',1,0);
raw_data = csvread('../data/good_interval_freq_right_after_repeat_10_49.csv',1,0);
[user_list,~,~] = unique(raw_data(:,1));

figure
for i=1:12
    target_user_number=user_list(i*14);
    subplot(4,3,i)
    render_user_all_lecture_interval_dist(raw_data, target_user_number);
end

good_example_user_list=[55 96 139];
for i=1:3
%     target_user_number=user_list(i*109)
    target_user_number = good_example_user_list(i);
    % In function, it call figure and subplot
    render_user_lecture_interval_dist(raw_data, target_user_number);
end

% render_user_lecture_interval_dist(raw_data, 1);
% render_user_lecture_interval_dist(raw_data, 2);

% raw_data format
% id,lecture,5#,10#,30#,60#,300#,600#,long#
% query_user_number=0;
% 
% query_user_data=raw_data(raw_data(:,1)==query_user_number,:);
% query_user_lecture_count = size(query_user_data,1);
% 
% 
% 
% 
% 
% figure
% for i=1:query_user_lecture_count
%     subplot(4,2,i)
%     render_interval_dist(query_user_data(i,3:end), query_user_data(i,2));
% end
% 
