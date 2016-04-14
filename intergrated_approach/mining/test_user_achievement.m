function test_user_achievement(query_user_number, raw_data, lecture_guide)
   
%% Compare a specific user's distribution with guilde line

query_user_data=raw_data(raw_data(:,1)==query_user_number,:);
query_user_lecture_count = size(query_user_data,1);

query_user_answer=zeros(query_user_lecture_count,3);
query_user_answer(:,1) = query_user_data(:,2);
query_user_answer(:,2) = sum(query_user_data(:,3:end),2);

for i=1:size(query_user_data,1)
    current_lecture_number = query_user_data(i,2);
%     current_lecture_action_count = sum(query_user_data(i,3:end));
%     current_lecture_guide = lecture_guide(lecture_guide(:,1)==current_lecture_number, 1:end-1);
    current_lecture_guide = lecture_guide(lecture_guide(:,1)==current_lecture_number, end);
    query_user_answer(i,3) = current_lecture_guide;
    %     a=[target_user_data(i,2:end) ;  current_lecture_guide]
end

%% Draw bar graph of action count (user vs guide)

user_achievement_data=zeros(size(lecture_guide,1),3);
user_achievement_data(:,1)=1:size(lecture_guide,1);

for i=1:query_user_lecture_count
    [~,index]=ismember(query_user_answer(i,1),lecture_guide(:,1));
    user_achievement_data(index,2)=query_user_answer(i,2);
    user_achievement_data(index,3)=query_user_answer(i,3);
end

data = [user_achievement_data(:,2) user_achievement_data(:,3)]
hb = bar(data,'stack');
set(hb(1), 'FaceColor','r');
set(hb(2), 'FaceColor','b');
% title('User achievement');
title( strcat('User-',int2str(query_user_number),' achievement') );
legend('User', 'Guide');
% axis([0 22 0 25]);
ylabel('Action#');
% xlabel('Lecture')
x_label_str=arrayfun(@num2str, lecture_guide(:,1), 'UniformOutput', false);
set(gca,'XTickLabel', x_label_str','XTick',1:numel(x_label_str));
%% compare action dist of user and guide


end