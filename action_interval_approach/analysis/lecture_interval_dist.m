clc;clear all; close all;
%% pre processing
% raw_data = csvread('../data/good_interval_freq.csv',1,0);
% raw_data = csvread('../data/good_interval_freq_right_after_if.csv',1,0);
% raw_data = csvread('../data/good_interval_freq_right_after_repeat.csv',1,0);

% raw_data = csvread('../data/good_interval_freq_10_49.csv',1,0);
% raw_data = csvread('../data/good_interval_freq_right_after_if.csv',1,0);

% 2015
% raw_data = csvread('../data/good_interval_freq_right_after_repeat.csv',1,0);

% 2016
% id,lecture,run,+normal,+repeat,+if,5#,10#,30#,60#,300#,long#
raw_data = csvread('../../intergrated_approach_2016_summer/data/data.csv',3,0);
raw_data = [raw_data(:,1:2) raw_data(:,7:end)];


% raw_data format
% id,lecture,5#,10#,30#,60#,300#,600#,long#

% A = accumarray(subs,val) for a column vector subs and vector val works 
% by adding the number in val(i) to the total in row subs(i)

lecture_raw_data=raw_data(:,2:end);
[lecture_number,~,lecture_index] = unique(lecture_raw_data(:,1));

lecture_interval_dist_data=zeros(length(lecture_number), 7);
lecture_interval_dist_data(:,1)=lecture_number;


for i=2:7
    lecture_interval_dist_data(:,i) = accumarray(lecture_index,lecture_raw_data(:,i));
end

figure
for i=1:length(lecture_number)
    subplot(3,3,i)
    render_interval_dist(lecture_interval_dist_data(i,2:end), lecture_number(i));
end


