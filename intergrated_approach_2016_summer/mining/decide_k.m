clc; 
% close all;
clear all;
%% pre processing
% |row| = 16388 in lecture 4-9 
% *** raw_data format *** 
% user,user2int,lec,#run,#action,#action_per_run,interval_bw_run
% OUMKvehe,21,409,6,15,2,11
% 8PEGM3AI,48,409,1,6,6,10

data = csvread('../data/feature.csv',1,1);


lecture_index=409;
data_interest = data(data(:,2)==lecture_index,:);

%% remove outlier  

a=data_interest(:,4)==6;
outlier_index = find(a==1,1000);
data_interest(outlier_index,:);

data_interest = data_interest(data_interest(:,4)>=minimum_action(lecture_index) ,:);

data_interest = data_interest(data_interest(:,4)<75,:);
data_interest = data_interest(data_interest(:,3)>0,:);
data_interest = data_interest(data_interest(:,3)<50,:);

%% extract
run_count = data_interest(:,3);
action_count = data_interest(:,4);
action_count_per_run = data_interest(:,5);
interval_bw_run = data_interest(:,6);

%% normalize
interval_bw_run = log(interval_bw_run);

% X = [action_count run_count  action_count_per_run interval_bw_run ];
X = [action_count run_count  action_count_per_run ];

k=4;

%% K medoid clustering
% [idx,center,~] = kmedoids(X, k);
[idx,center,sumd] = kmeans(X, k);

max_k = 10;
error_list = zeros(max_k,1);
for k=1:max_k
    [~,~,sumd] = kmeans(X, k);
    error_list(k)=sum(sumd);
end
subplot(2,1,1)
plot(1:max_k, error_list(1:end));
subplot(2,1,2)
plot(2:max_k, error_list(2:end));

