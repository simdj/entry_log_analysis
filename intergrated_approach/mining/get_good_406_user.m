clc; close all;
% clear all;
rng(1)
%% pre processing
% |row| = 221330
% *** raw_data format *** 
% 'id','lecture','run', '+normal', '+repeat','+if', '5#', '10#', '30#', '60#','300#','long#'
% 0,1,2,3,4,5,6,7,8
% 1,402,1,8,0,0,0,0,0
% 2,206,4,13,0,0,3,0,0
raw_data = csvread('../data/intergrated_data.csv',1,0);
% filter only user course 4
% data = data(data(:,2)>400,:); # already filtered in generating.py
[user_id_list, ~, ~] = unique(raw_data(:,1));
[lecture_number_list, ~, ~] = unique(raw_data(:,2));

sibal = raw_data(raw_data(:,1)==724,:)

%% get center list of each lecture
k=9;
feature_number = 3;
% center_data=get_lecture_cluster_center(raw_data, k,feature_number,1);



[lecture_number_list,~,~] = unique(raw_data(:,2));
cluster_center_3d_list = zeros(length(lecture_number_list),k,feature_number);



target_data = raw_data(raw_data(:,2)==410, 4:6);
target_data = remove_outlier(target_data);
[idx,center,~] = kmedoids(target_data, k);
idx;



fid=fopen('../data/user_list.csv');
user_key_list = textscan(fid,'%f %s', 'Delimiter',',');
fclose(fid);
fid=fopen('good_user_key_410.csv','wt');
key_col=user_key_list{1,2};
for i = 1:length(idx)
    if idx(i)<=3
%         disp(i)
%         disp(key_col{i});
        fprintf(fid,'%s\n', key_col{i});
    end
end
fclose(fid);