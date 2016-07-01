clc; 
% close all;
% clear all;
rng(1)
%% pre processing
% |row| = 221330
% *** raw_data format *** 
% 'id','lecture','run', '+normal', '+repeat','+if', '5#', '10#', '30#', '60#','300#','long#'
% 0,1,2,3,4,5,6,7,8
% 1,402,1,8,0,0,0,0,0
% 2,206,4,13,0,0,3,0,0
data = csvread('../data/intergrated_data.csv',1,0);
% filter only user course 4
% data = data(data(:,2)>400,:); # already filtered in generating.py
[user_id_list, ~, ~] = unique(data(:,1));
[lecture_number_list, ~, ~] = unique(data(:,2));


%% get center list of each lecture
k=5;
feature_number = 3;

% center_data=get_lecture_cluster_center(raw_data, k,feature_number,0);
% d=squeeze(center_data(3,:,:));

center_data = zeros(length(lecture_number_list),k,feature_number);
   
for i = 1:length(lecture_number_list)
    target_data = data(data(:,2)==lecture_number_list(i), 4:6);
    target_data = remove_outlier(target_data);
    [idx,center,e] = kmeans(target_data, k);
    sum(e)

    % compute the row totals
    row_totals = sum(center,2);

    % sort the row totals 
    [~, row_ids] = sort(row_totals, 'ascend');
    cluster_rank=zeros(length(row_ids),1);
    for j=1:length(row_ids)
        cluster_rank(row_ids(j))=j;
    end

    center_data(i,:,:)=center(row_ids,:); 
end

%% save cluster center
fid=fopen('cluster_center.csv','wt');
fprintf(fid,'Lecture,Rank,#Normal,#Repeat,#If,Sum(#action)\n');
center_block_count = zeros(size(center_data,1),k);
for i=1:size(center_data,1)
%     center_block_count(i,:)=sum(squeeze(center_data(i,:,:)),2);
    ith_center_list = squeeze(center_data(i,:,:));
    lecture_number_list(i);
    for j=1:size(ith_center_list,1)
        fprintf(fid,'%d,%d,%f,%f,%f,%f\n', lecture_number_list(i), j, ith_center_list(j,:), sum(ith_center_list(j,:),2));
    end
end
fclose(fid);