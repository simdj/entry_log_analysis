function result_data = remove_outlier(data)
%     data: (+normal, +repeat, +if)
%     feature_count = 3;
    row_sum = sum(data,2);
    outlier_border = prctile(row_sum,90);
    result_data=data(row_sum <= outlier_border & row_sum>0,:);    
end