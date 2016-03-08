clc;clear all; close all;
%% pre processing
raw_data = csvread('../data/good_action_50.csv',1,0);
% raw_data format
% id,lecture,run,addBlock,insertBlock,moveBlock,seperateBlock,destroyBlock,destroyBlockAlone
% 0,408,10,9,23,2,11,1,0
% 1,409,1,6,6,0,0,0,0

% target data format
% user, lecture, (action count of the user in the lecture), guide(intially 0)
data = [raw_data(:,1:2) sum(raw_data(:,3:end),2) zeros(length(raw_data),1)];
data = sortrows(data,1:2);

% target data format
% lecture, guide(min of #action in the lecture)
[lecture_number,~,mapping_vector] = unique(data(:,2));
lecture_guide = [lecture_number, accumarray(mapping_vector,data(:,3),[],@min)];

% fill guide data 
for i=1:length(data)
    data(i,end)=lecture_guide(mapping_vector(i),2);
end
%% drawing 1) each user vs guide line
figure
hold on

for i=1:10
    each_user_lecture=mapping_vector(data(:,1)==i)
    each_user = data(data(:,1)==i,3);
    plot(each_user_lecture, each_user);
end

plot(1:length(lecture_guide), lecture_guide(:,2),'r--*');
hold off


%% drawing 2) action# graph per lecture
% figure
% 
% for i=1:length(lecture_number)
%     subplot(3,7,i);
%     histogram( data(data(:,2)==lecture_number(i),3) );
%     hold on
%     line([lecture_guide(i,2) lecture_guide(i,2)], get(gca, 'ylim'));
%     hold off
%     
%     title(strcat('lecture ',int2str(lecture_number(i))));
%     xlabel('Action count');
%     ylabel('Frequency');
%     %     legend('')
% end



%%
% target data format
% user, lecture, (action count of the user in the lecture), guide of the lecture

