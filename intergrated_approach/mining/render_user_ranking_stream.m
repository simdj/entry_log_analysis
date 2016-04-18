function render_user_ranking_stream(center_data, user_data, lecture_number_list,k)
    % center_data is the cluster_center_3d_list
    % user_data contains the rows ( data(data(:,1)==user_id,:) )

    user_rank=zeros(size(lecture_number_list,1),1);
    for j=1:size(user_data,1)
        target_lecture_number = user_data(j,2);
        cluster_center_info = squeeze( center_data(lecture_number_list==target_lecture_number,:,:) );
        
        % find an index of cluster the user belongs to
        user_behavior = repmat(user_data(j,4:6),[length(cluster_center_info),1]);
        a=cluster_center_info - user_behavior;
        [~, argmin] = min(sqrt(sum(a.^2,2)));
        user_rank(lecture_number_list==target_lecture_number)=argmin;
    end
    markers = {'+','o','*','.','x','s','d','^','v','>','<','p','h'};
    plot(lecture_number_list(user_rank>0), user_rank(user_rank>0),  'Marker',markers{mod(user_data(1,1),numel(markers))+1},'MarkerSize',6, 'LineWidth',2)
    

% legend('Guide','median','mean');

xlabel('Lecture','FontSize',20);
ylabel('Rank','FontSize',20);
set(gca,'YTick', 0:k);
set(gca,'fontsize',16)

xlim([401.5 410.5])
ylim([0.5,k]);
end