clc; 
% close all;
clear all;
%% pre processing
% |row| = 16388 in lecture 4-9 
% *** raw_data format *** 
% user,user2int,lec,#run,#action,err_incomplete,err_without_ct,err_etc
% OUMKvehe,18,409,6,15,0,0,5
% 8PEGM3AI,42,409,1,6,0,0,0
% ASnwrbqm,43,409,2,7,0,0,1

data = csvread('../data/feature.csv',1,1);

lecture_index=409;
data_interest = data(data(:,2)==lecture_index,:);

%% remove outlier  

data_interest = data_interest(data_interest(:,4)>=minimum_action(lecture_index) ,:);
% 3:run
% 4:edit
run_threshold = prctile(data_interest(:,3),99.5);
edit_threshold = prctile(data_interest(:,4),99.5);

data_interest = data_interest(data_interest(:,3)<=run_threshold,:);
data_interest = data_interest(data_interest(:,4)<=edit_threshold,:);


% run_count = data_interest(:,3);
% run_count(run_count>run_threshold)=run_threshold;
% action_count = data_interest(:,4);
% action_count(action_count>edit_threshold)=edit_threshold;
% action_count(action_count(:,4)<edit_threshold)=data_interest(data_interest(:,4)<edit_threshold,4);

% data_interest = data_interest(data_interest(:,4)<prctile(data_interest(:,4),99),:);

%% extract
run_count = data_interest(:,3);
action_count = data_interest(:,4);
err_incomplete = data_interest(:,5);
err_without_ct = data_interest(:,6);
err_etc = data_interest(:,7);

%% normalization
% n1 = prctile(err_incomplete,99);
% n2 =prctile(err_without_ct,99);
% n3 =prctile(err_etc,99);
% n4 =prctile(action_count,99);
% err_incomplete = err_incomplete/n1;
% err_without_ct = err_without_ct/n2;
% err_etc = err_etc/n3;
% action_count=action_count/n4;
%% 
X = [err_without_ct err_incomplete+err_etc  action_count];
[Nuser,Ndim] = size(X);



%% K medoid clustering
k=5;
rng(0) 
% kmedoid dimension=4 k=4, rng(6) °¡Àå ±¦Ãá
% kmeans dimension=4 k=4, rng(5) °¡Àå ±¦Ãá


% [idx,center,~] = kmedoids(X, k);

% [idx,center,sumd] = kmeans(X, k,'start',seeds);
X_normalized = X;
n1 = prctile(X(:,1),99);
n2 = prctile(X(:,2),99);
n3 = prctile(X(:,3),99);
% n4 = prctile(X(:,4),99);
X_normalized(:,1)=X(:,1)/n1;
X_normalized(:,2)=X(:,2)/n2;
X_normalized(:,3)=X(:,3)/n3;
% X_normalized(:,4)=X(:,4)/n4;

% seeds=[0 0 0; n1 0 0; 0 n2 0 ; 0 0 n3;
%     n1 n2 0; n1 0 n3; n1 n2 0 ; n1 n2 n3];
% seeds=[0 0 0; n1/2 0 n3/2; 0 n2/2 n3/2 ; n1/2 n2/2 n3/2; ];
% k=length(seeds);
% [idx,normalized_center,sumd] = kmeans(X_normalized, k,'start',seeds);
[idx,normalized_center,sumd] = kmeans(X_normalized, k);


restore = [n1 n2 n3 ];
center = [normalized_center.*repmat(restore,k,1) hist(idx, unique(idx))' ];

% idx=clusterdata(X,'maxclust',5,'linkage', 'ward');
% gmfit = fitgmdist(X,k,'CovarianceType','full', 'SharedCovariance',true);
% idx = cluster(gmfit,X);

% X=data_interest(:,5:end);
[uniqueX, ia, n] = unique(X, 'rows');
% Find number of occurrences
nHist = hist(n, unique(n));



% figure
% scatter3(uniqueX(:,1),uniqueX(:,2),uniqueX(:,3),(log(nHist*4).^3)*3,idx(ia),'filled');
scatter3(uniqueX(:,1),uniqueX(:,2),uniqueX(:,3),50,idx(ia),'.');

hold on
scatter3(center(:,1),center(:,2),center(:,3), 1000,1:k ,'x','LineWidth',3);
hold off
xlabel('Error (Not satisfactory)','FontSize', 20)
ylabel('Error (Not correct)','FontSize', 20)
zlabel('# of Edit','FontSize', 20)
title(strcat('Lecture - ',num2str(lecture_index), ' (Sequences,Loops,Conditionals) '), 'FontSize', 20);
% xlim([0 inf])
% ylim([0 inf])
% zlim([0 inf])
colormap(jet)
sortrows(center, Ndim)
'´äÀº ¸Â´Âµ¥ Á¶°ÇºÎÇÕx, ¿À´ä, action'
% cluster_center = [center(:,1) center(:,2) center(:,3) ];
% sortrows(cluster_center,3)

uint32(sortrows(center, Ndim))

