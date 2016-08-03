% clc; close all;
% clear all;

%% pre processing
% *** data format *** 
% key,id,lecture,run,+normal,+repeat,+if,5#,10#,30#,60#,300#,long#
% EjV5T1cU,1,409,1,4,1,2,7,0,0,0,0,0
% 8YsGBsNy,2,409,2,4,1,3,7,0,2,0,0,0
% ux19Kbo7,3,409,1,3,1,2,6,0,0,0,0,0

fileID = fopen('../data/clean_409.csv');
raw_data=textscan(fileID, '%s');
fclose(fileID);

% ignore the first row, first single -> start from (1,1)
data = csvread('../data/clean_409.csv',1,1);
data_run_and_total=[data(:,1:3) sum(data(:,4:6),2)];

lecture_index=409;
data_in_lecture = data_run_and_total(data_run_and_total(:,2)==lecture_index,:);

action_num_threshold=5;
% outlier_indicator=data_in_lecture(:,4)<minimum_action(lecture_index);
outlier_indicator=data_in_lecture(:,4)==5;
outlier_index = find(outlier_indicator==1,length(data));
% data_in_lecture(outlier_index,:)
% raw_data{1}{outlier_index}


fid=fopen('outlier_409_5.csv', 'wt');
fprintf(fid, 'key,id,lecture,run,+normal,+repeat,+if,5#,10#,30#,60#,300#,long#\n');
for i = 1:length(outlier_index)
    fprintf(fid,'%s\n',raw_data{1}{1+outlier_index(i)});
end
fclose(fid);

% remove outlier  
% data_in_lecture = data_in_lecture(data_in_lecture(:,4)>=minimum_action(lecture_index) ,:);








