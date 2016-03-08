clc;clear all; close all;
%% Acquire data
action_arr=['run','addBlock','insertBlock','moveBlock','seperateBlock','destroyBlock','destroyBlockAlone'];
data = csvread('../data/good_action_10.csv',1,2);
% data = csvread('../data/raw_action_50.csv',1,2);
% small_data = csvread('data.csv',1,2,[1 2 3 8]);
normalized_data = bsxfun(@rdivide,data,sum(data,2));

%% Preprocessing
run_vec = normalized_data(:,1);
except_run_vec = sum(normalized_data(:,2:end)')';
add_vec = normalized_data(:,2);
insert_vec = normalized_data(:,3);
seperate_vec = normalized_data(:,4);
destroy_vec = normalized_data(:,6);
% scatter(run_vec,add_vec);

%% Call render
%%% construct vs destroy
X=[insert_vec+add_vec seperate_vec+destroy_vec];
render_with_kmeans(X,'construct vs destroy', 'construct probability', 'destory probability');
% 
% %%% construct vs run
% X=[insert_vec+add_vec run_vec];
% render_with_kmeans(X,'consturct vs run', 'construct probability', 'run probability');
% 
% %%% run vs others
% X=[run_vec except_run_vec];
% render_with_kmeans(X,'run vs others', 'run probability', 'others probability');
% 
% 
