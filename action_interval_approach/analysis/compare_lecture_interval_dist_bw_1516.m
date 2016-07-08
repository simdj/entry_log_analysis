clc;close all;
% clear all; 
%% pre processing
% raw_data format
% id,lecture,5#,10#,30#,60#,300#,600#,long#

% raw_data = csvread('../data/good_interval_freq.csv',1,0);
% raw_data = csvread('../data/good_interval_freq_right_after_if.csv',1,0);
% raw_data = csvread('../data/good_interval_freq_right_after_repeat.csv',1,0);

% raw_data = csvread('../data/good_interval_freq_10_49.csv',1,0);
% raw_data = csvread('../data/good_interval_freq_right_after_if.csv',1,0);

% 2015 -old
% raw_data = csvread('../data/good_interval_freq_right_after_repeat.csv',1,0);

% 2015 -new
raw_data_15 = csvread('../../intergrated_approach/data/intergrated_data_2015.csv',3,0);
raw_data_15 = [raw_data_15(:,1:2) raw_data_15(:,7:end)];


% 2016
% id,lecture,run,+normal,+repeat,+if,5#,10#,30#,60#,300#,long#
raw_data_16 = csvread('../../intergrated_approach_2016_summer/data/data_train.csv',3,0);
raw_data_16 = [raw_data_16(:,1:2) raw_data_16(:,7:end)];



%%

% A = accumarray(subs,val) for a column vector subs and vector val works 
% by adding the number in val(i) to the total in row subs(i)

lecture_raw_data_15=raw_data_15(:,2:end);
[lecture_number_15,~,lecture_index_15] = unique(lecture_raw_data_15(:,1));

lecture_interval_dist_data_15=zeros(length(lecture_number_15), 7);
lecture_interval_dist_data_15(:,1)=lecture_number_15;


for i=2:7
    lecture_interval_dist_data_15(:,i) = accumarray(lecture_index_15,lecture_raw_data_15(:,i));
end


%%
lecture_raw_data_16=raw_data_16(:,2:end);
[lecture_number_16,~,lecture_index_16] = unique(lecture_raw_data_16(:,1));

lecture_interval_dist_data_16=zeros(length(lecture_number_16), 7);
lecture_interval_dist_data_16(:,1)=lecture_number_16;


for i=2:7
    lecture_interval_dist_data_16(:,i) = accumarray(lecture_index_16,lecture_raw_data_16(:,i));
end

%%
figure
for i=1:length(lecture_number_15)
    subplot(3,3,i)
%     render_interval_dist([lecture_interval_dist_data_15(i,2:end)], lecture_number_15(i));
data = [lecture_interval_dist_data_15(i,2:end);lecture_interval_dist_data_16(i,2:end)];
    x_label_str={'0~5','5~10','10~30','30~60','1~5Ка','5Ка~'};
    total_action_cnt = max(1,sum(data,2));
    a=bsxfun(@rdivide,data,total_action_cnt);
    b=bar(1:numel(x_label_str), a');
    b(1).FaceColor='red';
    b(2).FaceColor='blue';
    
    
    text(1:numel(x_label_str),a(1,:)',num2str(a(1,:)',' %0.2f'),...
    'Rotation',15,...
    'HorizontalAlignment','right',...
    'VerticalAlignment','bottom');

    text(1:numel(x_label_str),a(2,:)',num2str(a(2,:)',' %0.2f'),...
    'Rotation',15,...
    'HorizontalAlignment','left',...
    'VerticalAlignment','bottom');
    
    set(gca,'XTickLabel', x_label_str,'XTick',1:numel(x_label_str));
    title(lecture_number_15(i));
    ylabel('Freq');
    axis([0 numel(x_label_str)+1 0 1])
    legend('2015','2016');

end

