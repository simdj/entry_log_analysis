 function cluster_center_3d_list = get_lecture_cluster_center(data, k, feature_count, render_flag)
%     data spec - id, lecture, run, +normal, +repeat, +if, 
%     -normal, -repeat, -if
%     feature_count = 3;
    
    [lecture_number_list,~,~] = unique(data(:,2));
    cluster_center_3d_list = zeros(length(lecture_number_list),k,feature_count);
%     figure('units','normalized','Position',[0.2 0.4 0.55, 0.35]),
    
    
    for i = 1:length(lecture_number_list)
        target_data = data(data(:,2)==lecture_number_list(i), 4:6);
        target_data = remove_outlier(target_data);
%         size(target_data)
        [idx,center,~] = kmeans(target_data, k);
        
        
        % compute the row totals
        row_totals = sum(center,2);

        % sort the row totals 
        [~, row_ids] = sort(row_totals, 'ascend');
        cluster_rank=zeros(length(row_ids),1);
        for j=1:length(row_ids)
            cluster_rank(row_ids(j))=j;
        end

        
        cluster_center_3d_list(i,:,:)=center(row_ids,:); 
        if render_flag==1
%             subplot(3,3,i)
            figure('Position',[100 100 1100 700]);
            scatter3(target_data(:,1),target_data(:,2),target_data(:,3),[],cluster_rank(idx),'*');
%             scatter3(target_data(:,1),target_data(:,2),target_data(:,3),50,cluster_rank(idx),'*');
            
            title(strcat('Lecture - ',int2str(lecture_number_list(i))),'FontSize',20);
            xlim([0 inf]);
            ylim([0 inf]);
            zlim([0 inf]);
            xlabel('#NORMAL','FontSize',20);
            ylabel('#REPEAT','FontSize',20);
            zlabel('#IF','FontSize',20);
            view(-15, 25);
            colormap(jet)
            colorbar
            hold on
            scatter3(cluster_center_3d_list(i,:,1),cluster_center_3d_list(i,:,2),cluster_center_3d_list(i,:,3), histcounts(cluster_rank(idx)),1:k,'fill','o');
            colormap(jet)
            hold off
            
        end
        
    end
end