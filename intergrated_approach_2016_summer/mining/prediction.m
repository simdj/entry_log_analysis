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


lecture_index=409;
user_list = data(data(:,2)==lecture_index,1);
[user_interest,~,~]=unique(user_list);

%% 406,407,408로 409를 예측해보장~

data = data(data(:,2)>=406 & data(:,2)<410,:);

data_interest = data(ismember(data(:,1),user_interest),:);
data_interest = sortrows(data_interest);

[C,ia,ic]=unique(data_interest(:,1));
% C <=> A(ia) ia가 짧음
% A <=> C(ic) ic는 원래 맵핑

% [uniqueX, ia, n] = unique(X, 'rows');
% Find number of occurrences
% nbin = unique(data_interest(:,1));
nHist = hist(data_interest(:,1),C);
% clean_user = data_interest(:,1);
clean_user = C(nHist==4);
data_interest = data_interest(ismember(data_interest(:,1),clean_user),:);

%%
data_interest = data_interest(:,3:end);
[n,Nfeature]=size(data_interest);
Nuser = n/4;

train_data = zeros(Nuser, 4*Nfeature);
for i=1:length(data_interest)/4
    train_data(i,1:Nfeature)=data_interest(4*i-3,:);
    train_data(i,Nfeature+1:2*Nfeature)=data_interest(4*i-2,:);
    train_data(i,2*Nfeature+1:3*Nfeature)=data_interest(4*i-1,:);
    train_data(i,3*Nfeature+1:4*Nfeature)=data_interest(4*i,:);
end


X=[   train_data(:,1:12)    ];
y = train_data(:,14);

% X=X(1:500,:);
% y=y(1:500,:);


% r = randi([0 50],1,length(y));
% lm = fitlm(X(:,:),r(:,:),'linear')
lm = fitlm(X(:,:),y(:,:),'linear')
anova(lm)
% stats : 
% the R2 statistic, the F statistic 
% and its p value, and an estimate of the error variance.
scatter_points = [X(:,1) y];
[unique_scatter_points, ia, n] = unique(scatter_points, 'rows');
% Find number of occurrences
nHist = hist(n, unique(n));

% scatter(unique_scatter_points(:,1), unique_scatter_points(:,2),log2(nHist*4).^3,'fill');
scatter(unique_scatter_points(:,1), unique_scatter_points(:,2), nHist,'fill');

xlim([0 30])
ylim([0 30])
% hold on
% [b,bint,r,rint,stats]=regress(y,[ones(length(X),1) X]);
% xx=[ones(30,1) (1:30)'];
% plot(1:30,xx*b)
% hold off
% 
% scatter3(x1,x2,y,'filled')
% hold on
% x1fit = min(x1):100:max(x1);
% x2fit = min(x2):10:max(x2);
% [X1FIT,X2FIT] = meshgrid(x1fit,x2fit);
% YFIT = b(1) + b(2)*X1FIT + b(3)*X2FIT + b(4)*X1FIT.*X2FIT;
% mesh(X1FIT,X2FIT,YFIT)
% xlabel('x1')
% ylabel('x2')
% zlabel('y')
% view(50,10)
% 


