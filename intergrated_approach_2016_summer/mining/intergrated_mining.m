clc; close all;
clear all;
%% pre processing
% |row| = 221330
% *** raw_data format *** 
% 'id','lecture','run', '+normal', '+repeat','+if', '5#', '10#', '30#', '60#','300#','long#'
% 0,1,2,3,4,5,6,7,8
% 1,402,1,8,0,0,0,0,0
% 2,206,4,13,0,0,3,0,0
% raw_data = csvread('../data/intergrated_data.csv',1,0);
raw_data = csvread('../data/data.csv',2,0);

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


% time interval data
% *** time_interval_data format *** 
% id,lecture,5#,10#,30#,60#,300#,long#
time_interval_data=raw_data(:,[1 2 7:12]);
[lecture_number_list,~,lecture_index] = unique(time_interval_data(:,1));

%% one user
query_user_number = 89;
test_user_achievement(query_user_number, raw_data, lecture_guide);
render_user_lecture_interval_dist(time_interval_data, query_user_number);

%% one user and one lecture (deprecated)
% query_user_number = user_id_list(1);
% query_lecture_number = lecture_number_list(1);
% 
% figure;
% 
% set(hb(1), 'FaceColor','r');
% set(hb(2), 'FaceColor','b');
% title('User achievement');
% title( strcat('User-',int2str(query_user_number),' achievement') );
% legend('User', 'Guide');
% axis([0 22 0 25]);
% ylabel('Action#');
% xlabel('Lecture')
% x_label_str=arrayfun(@num2str, lecture_guide(:,1), 'UniformOutput', false);
% set(gca,'XTickLabel', x_label_str','XTick',1:numel(x_label_str));