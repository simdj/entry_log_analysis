clc;clear all; close all;
%% pre processing
% raw_data = csvread('../data/good_block_action.csv',1,0);
raw_data = csvread('../data/good_block_action.csv',10,0,[10,0, 30 8]);

% raw_data format
% id,lecture,run,+normal,+repeat,+if,-normal,-repeat,-if
% 1,402,1,8,0,0,0,0,0
% 2,206,4,13,0,0,3,0,0

% A = accumarray(subs,val) for a column vector subs and vector val works 
% by adding the number in val(i) to the total in row subs(i)

lecture_raw_data=raw_data(:,2:end);
[lecture_number,~,lecture_index] = unique(lecture_raw_data(:,1));

lecture_group_data=zeros(length(lecture_number), 8);
lecture_group_data(:,1)=lecture_number;


for i=2:8
    lecture_group_data(:,i) = accumarray(lecture_index,lecture_raw_data(:,i));
end
% 
% total_action_cnt = sum(lecture_group_data(:,2:end),2);
% % lecture, total_action_cnt,
% % + action_distribution (run,addBlock,insertBlock,moveBlock,seperateBlock,destroyBlock,destroyBlockAlone)
% data = [ lecture_group_data(:,1) total_action_cnt bsxfun(@rdivide,lecture_group_data(:,2:end),total_action_cnt)  ];
% 
% 




% 
% lecture_dist_plot=1;
% %% drawing data
% if lecture_dist_plot==1
%     figure;
%     subplot(2,2,1);
%     bar(1:length(data(:,1)), data(:,3:end), 0.5, 'stack');
%     legend('run','addBlock','insertBlock','moveBlock','seperateBlock','destroyBlock','destroyBlockAlone')
%     axis([0 25 0 1.5]);
%     title('lecture-distribution');
%     xlabel('lecture id');
%     ylabel('distribution');
%     subplot(2,2,2);
%     bar(1:length(data(:,1)), bsxfun(@times,data(:,3:end),total_action_cnt), 0.5, 'stack');
%     legend('run','addBlock','insertBlock','moveBlock','seperateBlock','destroyBlock','destroyBlockAlone')
%     title('lecture-action count');
%     xlabel('lecture id');
%     ylabel('action count');
% end
% % A=[run_vec(1:end) except_run_vec(1:end) insert_vec(1:end)];
% % X=[run_vec run_vec];
% % 
% % [Auniq,~,IC] = unique(X(:,1:2),'rows');
% % cnt = accumarray(IC,1);
% 
% %% pre processing 2
% raw_data = csvread('../data/good_action_50.csv',1,0);
% % raw_data format
% % id,lecture,run,addBlock,insertBlock,moveBlock,seperateBlock,destroyBlock,destroyBlockAlone
% % 0,408,10,9,23,2,11,1,0
% % 1,409,1,6,6,0,0,0,0
% lecture_raw_data=raw_data(:,2:end);
% [lecture_number,ia,c] = unique(lecture_raw_data(:,1));
% lecture_group_data=lecture_number;
% 
% for i=2:8
%     lecture_group_data = [lecture_group_data, accumarray(c,lecture_raw_data(:,i))];
% end
% 
% total_action_cnt = sum(lecture_group_data(:,2:end),2);
% % lecture, total_action_cnt,
% % + action_distribution (run,addBlock,insertBlock,moveBlock,seperateBlock,destroyBlock,destroyBlockAlone)
% data = [ lecture_group_data(:,1) total_action_cnt bsxfun(@rdivide,lecture_group_data(:,2:end),total_action_cnt)  ];
% 
% 
% 
% %% drawing data
% if lecture_dist_plot==1
%     
%     subplot(2,2,3);
%     bar(1:length(data(:,1)), data(:,3:end), 0.5, 'stack');
%     legend('run','addBlock','insertBlock','moveBlock','seperateBlock','destroyBlock','destroyBlockAlone')
%     axis([0 25 0 1.5]);
%     title('lecture-distribution');
%     xlabel('lecture id');
%     ylabel('distribution');
%     subplot(2,2,4);
%     bar(1:length(data(:,1)), bsxfun(@times,data(:,3:end),total_action_cnt), 0.5, 'stack');
%     legend('run','addBlock','insertBlock','moveBlock','seperateBlock','destroyBlock','destroyBlockAlone')
%     title('lecture-action count');
%     xlabel('lecture id');
%     ylabel('action count');
% end
% 
% 
% 
% %% draw
% % size_array =cnt; 
% % color_array=log(log(log(cnt+1)+1)+1);
% % 
% % % scatter3(Auniq(:,1), Auniq(:,2), Auniq(:,3),size_array,color_array, 'filled');
% % scatter(Auniq(:,1), Auniq(:,2), size_array,color_array, 'filled');
% % colormap(jet);
% % axis([0 1 0 1]);
% % title('construct-destroy');
% % xlabel('construct probability');
% % ylabel('destroy probablilty');

