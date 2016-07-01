clc; 
% close all;
% clear all;

%% pre processing
% |row| = 221330
% *** raw_data format *** 
% 'id','lecture','run', '+normal', '+repeat','+if', '5#', '10#', '30#', '60#','300#','long#'
% 0,1,2,3,4,5,6,7,8
% 1,402,1,8,0,0,0,0,0
% 2,206,4,13,0,0,3,0,0
data = csvread('../data/intergrated_data.csv',1,0);
% filter only user course 4
% data = data(data(:,2)>400,:); # already filtered in generating.py
[user_id_list, ~, ~] = unique(data(:,1));
[lecture_number_list, ~, ~] = unique(data(:,2));


%% get center list of each lecture
k=5;
feature_number = 3;

% center_data=get_lecture_cluster_center(raw_data, k,feature_number,0);
% d=squeeze(center_data(3,:,:));

center_data = zeros(length(lecture_number_list),k,feature_number);
figure
for i = 1:length(lecture_number_list)
%    i=5;
    target_data = data(data(:,2)==lecture_number_list(i), 4:6);
    % target_data = remove_outlier(target_data);
    sample_size_list = 50:50:(50*50);
    target_data_sample = datasample(target_data,sample_size_list(end));
    cluster_size_dist=zeros(length(sample_size_list), k+2);
    
    for sample_idx=1:length(sample_size_list)
%         rng(1);
        [idx,center,~] = kmeans(target_data_sample(1:sample_size_list(sample_idx),:), k);

        % compute the row totals
        row_totals = sum(center,2);
        % sort the row totals 
        [~, row_ids] = sort(row_totals, 'ascend');
        % compute cluster size distribution
%         cluster_size_dist=zeros(1,k);    
        for j=1:k
            cluster_size_dist(sample_idx,j)=nnz(idx==row_ids(j));
        end
        cluster_size_dist(sample_idx,1:k) = bsxfun( @rdivide, cluster_size_dist(sample_idx,1:k), sum(cluster_size_dist(sample_idx,1:k),2) );
        
%         overall_dist = bsxfun( @rdivide, sum(cluster_size_dist(:,1:k)), sum(sum(cluster_size_dist(:,1:k)),2) );
        previous_overall_dist = zeros(1,k);
        if sample_idx ~= 1
            previous_overall_dist = cluster_size_dist(sample_idx-1,1:k);
            cosine_distance = pdist([cluster_size_dist(sample_idx,1:k); previous_overall_dist],'cosine');
            euclidian_distance = sqrt(sum((abs(cluster_size_dist(sample_idx,1:k)-previous_overall_dist)).^2));
            cluster_size_dist(sample_idx,end-1)=cosine_distance;
            cluster_size_dist(sample_idx,end)=euclidian_distance;
        end
        
        
%         [cluster_size_dist(sample_idx,:); overall_dist]
        % cosine similarity
        
%         abs_distance = sum(abs(cluster_size_dist(sample_idx,1:k)-overall_dist));
        
        
        
        center_data(i,:,:)=center(row_ids,:); 
    end
%     cluster_size_dist
    
    subplot(3,3,i);
    hold on
    start_idx=3;
    % cosine
    plot(sample_size_list(start_idx:end)',cluster_size_dist(start_idx:end,end-1));
    myfit = polyfit(sample_size_list(start_idx:end)', cluster_size_dist(start_idx:end,end-1),1);
    plot(sample_size_list(start_idx:end)', polyval(myfit, sample_size_list(start_idx:end)'),':');
    % Euclidian
    plot(sample_size_list(start_idx:end)',cluster_size_dist(start_idx:end,end));
    myfit = polyfit(sample_size_list(start_idx:end)', cluster_size_dist(start_idx:end,end),1);
    plot(sample_size_list(start_idx:end)', polyval(myfit, sample_size_list(start_idx:end)'),'--');
    
    xlabel('Sample size')
    title(lecture_number_list(i));
    legend('Cosine distance','Cosine trend', 'Euclidian distance','Euclidian trend');
    
    hold off
    
%     overall_dist = bsxfun( @rdivide, sum(cluster_size_dist), sum(sum(cluster_size_dist),2) )
end
