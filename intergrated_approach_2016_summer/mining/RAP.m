clc; 
% close all;
clear all;
%% pre processing
% |row| = 16388 in lecture 4-9 
% *** raw_data format *** 
% user,user2int,lec,#run,#action,#action_per_run,interval_bw_run
% OUMKvehe,21,409,6,15,2,11
% 8PEGM3AI,48,409,1,6,6,10

data = csvread('../data/feature.csv',1,1);


lecture_index=408;
data_interest = data(data(:,2)==lecture_index,:);

%% remove outlier  

a=data_interest(:,4)==6;
outlier_index = find(a==1,1000);
data_interest(outlier_index,:);

data_interest = data_interest(data_interest(:,4)>=minimum_action(lecture_index) ,:);

data_interest = data_interest(data_interest(:,4)<75,:);
data_interest = data_interest(data_interest(:,3)>0,:);
data_interest = data_interest(data_interest(:,3)<50,:);

%% extract
run_count = data_interest(:,3);
action_count = data_interest(:,4);
action_count_per_run = data_interest(:,5);
interval_bw_run = data_interest(:,6);

%% normalize
interval_bw_run = log(interval_bw_run);

% X = [action_count run_count  action_count_per_run interval_bw_run ];
X = [action_count run_count  action_count_per_run ];

k=4;

%% K medoid clustering
% [idx,center,~] = kmedoids(X, k);
[idx,center,sumd] = kmeans(X, k);
% %%
% % % GMM setting
% % d = 300;
% % x1 = linspace(min(X(:,1)) - 2,max(X(:,1)) + 2,d);
% % x2 = linspace(min(X(:,2)) - 2,max(X(:,2)) + 2,d);
% % [x1grid,x2grid] = meshgrid(x1,x2);
% % X0 = [x1grid(:) x2grid(:)];
% % threshold = sqrt(chi2inv(0.99,2));
% options = statset('MaxIter',1000); % Increase number of EM iterations
% % GMM start
% % gmfit = fitgmdist(X,k);
% % gmfit = fitgmdist(X,k,'Options',options);
% % gmfit = fitgmdist(X,k,'CovarianceType','full','SharedCovariance',true,'Options',options);
% gmfit = fitgmdist(X,k,'CovarianceType','full', 'SharedCovariance',true);
% idx = cluster(gmfit,X);
%% ward?
% idx=clusterdata(X,'maxclust',5,'linkage', 'ward');
%%
[uniqueX, ia, n] = unique(X, 'rows');
% Find number of occurrences
nHist = hist(n, unique(n));



figure
scatter3(uniqueX(:,1),uniqueX(:,2),uniqueX(:,3),(log(nHist*2).^3)*3,idx(ia),'filled');



%%
hold on
y_x_line_range = 0:1:min([ max(xlim) max(ylim) ]);
% y_x_line = scatter3(y_x_line_range,y_x_line_range,y_x_line_range,[],'black'); 
hold off
view([0 0 ]); % x,z

%%
xlim([0 inf]);
ylim([0 inf]);
zlim([0 inf]);
title(strcat('Lecture - ',num2str(lecture_index), ' (Sequences,Loops,Conditionals) '), 'FontSize', 20);
xlabel('#Actions');
ylabel('#Runs');
zlabel('#Actions per run');
colormap(jet)