function render_user_lecture_interval_dist(raw_data, query_user_number)
% clc;clear all; close all;
% interval_dist(user, lecture)
% interval_dist(user, all_lecture)
% interval_dist(all user, lecture)

%% pre processing
% raw_data = csvread('../data/good_block_action.csv',1,0);
% raw_data = csvread('../data/good_interval_freq.csv',1,0);

% raw_data format
% id,lecture,5#,10#,30#,60#,300#,long#
% query_user_number=query_user_number_;

query_user_data=raw_data(raw_data(:,1)==query_user_number,:)
query_user_lecture_count = size(query_user_data,1);

figure
for i=1:query_user_lecture_count
    subplot(5,2,i)
    render_interval_dist(query_user_data(i,3:end), query_user_data(i,2));
end

