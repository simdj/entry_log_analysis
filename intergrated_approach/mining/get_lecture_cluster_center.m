function cluster_center_3d_list = get_lecture_cluster_center(data, k, feature_count)
%     data spec - id, lecture, run, +normal, +repeat, +if, 
%     -normal, -repeat, -if
%     feature_count = 3;
    
    [lecture_number_list,~,~] = unique(data(:,2));
    cluster_center_3d_list = zeros(length(lecture_number_list),k,feature_count);
%     figure('units','normalized','Position',[0.2 0.4 0.55, 0.35]),
    
    
    for i = 1:length(lecture_number_list)
%         subplot(3,3,i)
        figure('Position',[100 100 800 600]);
        target_data = data(data(:,2)==lecture_number_list(i), 4:6);
        target_data = remove_outlier(target_data);
        size(target_data)
        [idx,center,~] = kmedoids(target_data, k);

        
        % compute the row totals
        row_totals = sum(center,2);

        % sort the row totals 
        [~, row_ids] = sort(row_totals, 'ascend');
        cluster_rank=zeros(length(row_ids),1);
        for j=1:length(row_ids)
            cluster_rank(row_ids(j))=j;
        end

        % and display the original data in that order (concatenated with the sums)
%         disp([A(row_ids,:), row_totals(row_ids)])
        
        cluster_center_3d_list(i,:,:)=center(row_ids,:); 
        
        scatter3(target_data(:,1),target_data(:,2),target_data(:,3),[],cluster_rank(idx),'fill','MarkerEdgeColor','k');
        title(strcat('Lecture - ',int2str(lecture_number_list(i))));
        xlim([0 inf]);
        ylim([0 inf]);
        zlim([0 inf]);
        xlabel('normal');
        ylabel('repeat');
        zlabel('if');
        view(-45, 25);
        colormap(autumn)
    end
end