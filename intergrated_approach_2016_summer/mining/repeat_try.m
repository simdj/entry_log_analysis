clc; close all;
clear all;
%% pre processing
% |row| = 221330
% *** raw_data format *** 
% 'id','lecture','run', '+normal', '+repeat','+if', '5#', '10#', '30#', '60#','300#','long#'
% 0,1,2,3,4,5,6,7,8
% 1,402,1,8,0,0,0,0,0
% 2,206,4,13,0,0,3,0,0
% raw_data = csvread('../data/intergrated_data.csv',1,0);
% data = csvread('../data/data_train.csv',3,0);
% data = csvread('../data/cleaned_data_409.csv',4,1);
data = csvread('../data/clean_409.csv',1,1);
data_run_and_total=[data(:,1:3) sum(data(:,4:6),2)];

lecture_index=409;
data_in_lecture = data_run_and_total(data_run_and_total(:,2)==lecture_index,:);
% remove outlier  
data_in_lecture = data_in_lecture(data_in_lecture(:,4)>=minimum_action(lecture_index) ,:);
a=data_in_lecture(:,4)<minimum_action(lecture_index);
outlier_index = find(a==1,100);
data_in_lecture(outlier_index,:)
data_in_lecture = data_in_lecture(data_in_lecture(:,4)<75,:);
data_in_lecture = data_in_lecture(data_in_lecture(:,3)>0,:);
data_in_lecture = data_in_lecture(data_in_lecture(:,3)<50,:);

num_total = data_in_lecture(:,4);
num_run = data_in_lecture(:,3);
X = [num_total num_run];

%% clustering - kmedoids
% k=5;
% [idx,center,~] = kmedoids(X, k);
%% clustering - GMM
figure
k=2;
% GMM setting
d = 300;
x1 = linspace(min(X(:,1)) - 2,max(X(:,1)) + 2,d);
x2 = linspace(min(X(:,2)) - 2,max(X(:,2)) + 2,d);
[x1grid,x2grid] = meshgrid(x1,x2);
X0 = [x1grid(:) x2grid(:)];
threshold = sqrt(chi2inv(0.99,2));
options = statset('MaxIter',1000); % Increase number of EM iterations
% GMM start
gmfit = fitgmdist(X,k);
% gmfit = fitgmdist(X,k,'Options',options);
% gmfit = fitgmdist(X,k,'CovarianceType','full','SharedCovariance',false,'Options',options);
clusterX = cluster(gmfit,X);
mahalDist = mahal(gmfit,X0);
% GMM rendering
h1 = gscatter(X(:,1),X(:,2),clusterX);
hold on 
    % area rendering
    for m = 1:k;
        idx = mahalDist(:,m)<=threshold;
        Color = h1(m).Color*0.75 + -0.5*(h1(m).Color - 1);
        h2 = plot(X0(idx,1),X0(idx,2),'.','Color',Color,'MarkerSize',1);
        uistack(h2,'bottom');
    end
    % y=x rendering
    y_x_line = plot(ylim,ylim,'--' , 'LineWidth',1.5); M1='y=x';  
    % cluster center rendering
    plot(gmfit.mu(:,1),gmfit.mu(:,2),'kx','LineWidth',2,'MarkerSize',10)
hold off
% rendering option
title(strcat('Lecture - ',num2str(lecture_index), ' (Sequences) '), 'FontSize', 20);
xlim([0 inf]);
ylim([0 inf]);
xlabel('#Actions');
ylabel('#Runs');
colormap(jet)


%% clustering self-organizing-map
% inputs = transpose(X);
% net = selforgmap([1 2]);
% [net,tr] = train(net,inputs);
% outputs = net(inputs);
% plotsompos(net,inputs)
% % View the Network
% view(net)
% 
% % Plots
% % Uncomment these lines to enXle various plots.
% figure, plotsomtop(net)
% figure, plotsomnc(net)
% figure, plotsomnd(net)
% figure, plotsomplanes(net)
% figure, plotsomhits(net,inputs)
% figure, plotsompos(net,inputs)
% 
% [~, idx] = max(outputs, [], 1);
% 
% % clustering rendering
% scatter(X(:,1),X(:,2),[],idx,'fill','MarkerEdgeColor','k');
% hold on 
% y_x_line = plot(ylim,ylim,'--' , 'LineWidth',1.5); M1='y=x';
% hold off
% title(strcat('Lecture - ',num2str(lecture_index), ' (Sequences) '), 'FontSize', 20);
% xlim([0 inf]);
% ylim([0 inf]);
% xlabel('#Actions');
% ylabel('#Runs');
% colormap(jet)
%% total vs run
figure;
% Find unique rows and corresponding indices
[uniqueX, ~, n] = unique(X, 'rows');
% Find number of occurrences
nHist = hist(n, unique(n));

log_nHist = round(log2(2+nHist));
mx = max(log_nHist);
% Create colors for each number of occurrence
colors = jet(mx);
colormap(colors);
% Construct a color matrix
cMatrix = colors(log_nHist, :);
% Create scatter plot
scatter(uniqueX(:, 1), uniqueX(:, 2), 5*log_nHist, cMatrix,'filled');
% mx=10
colorbar('YTick', linspace(1/(2*mx), 1-1/(2*mx), mx), ...
         'YTicklabel', 2.^(0:mx));


fitY=polyfit(num_total,num_run,1);
disp(fitY);
hold on;
y_x_line = plot(ylim,ylim,'--' , 'LineWidth',1.5); M1='y=x';
% best_fit = plot(num_total,polyval(fitY,num_total)); M2='best fit';

mean_num_total_line = plot([mean(num_total)+0.5 mean(num_total)+0.5], ylim, 'LineWidth',3); M3='Mean(#action)';
% line([median(num_total)+0.5 median(num_total)+0.5], ylim); M4='Median(#action)';
% line([prctile(num_total,75) prctile(num_total,75)], [0 50]); M5='Median(#action)';

mean_num_run_line = plot(xlim,[mean(num_run)+0.5 mean(num_run)+0.5], 'LineWidth',3); M5='Mean(#run)';

% line(xlim,[median(num_run)+0.5 median(num_run)+0.5]);  M6='Median(#run)';





legend([y_x_line, mean_num_total_line, mean_num_run_line], M1,M3,M5);


title(strcat('Lecture - ',num2str(lecture_index), ' (Sequences) '), 'FontSize', 20);
% title(strcat('Lecture - ',num2str(lecture_index), ' (Sequences, Loops) '), 'FontSize', 20);
% title(strcat('Lecture - ',num2str(lecture_index), ' (Sequences, Loops, Conditionals) '), 'FontSize', 20);
xlabel('#Action', 'FontSize', 20);
ylabel('#Run', 'FontSize', 20);

hold off;

%% total/run
% figure;
% avg_num_action_per_run = num_total./num_run;
% max_avg = 20;
% % remove outlier
% avg_num_action_per_run = avg_num_action_per_run(avg_num_action_per_run<max_avg);
% [unique_avg_num_action_per_run, ~, n] = unique(avg_num_action_per_run, 'rows');
% % Find number of occurrences
% avg_and_co = [unique_avg_num_action_per_run, histc(avg_num_action_per_run, unique_avg_num_action_per_run)];
% bar(avg_and_co(:,1), avg_and_co(:,2),200);
% axis([0 max_avg 0 inf])
% title(strcat('Lecture - ',num2str(lecture_index), ' (Sequences, Loops, Conditionals) '), 'FontSize', 20);
% % title(strcat('Lecture - ',num2str(lecture_index), ' (Sequences) '), 'FontSize', 20);
% xlabel('#Action per run', 'FontSize', 20);
% ylabel('#User', 'FontSize', 20);
% % sum(avg_and_co(avg_and_co(:,1)<=2,2))
% 
% troll_threshold = mode(avg_num_action_per_run);
% troll_count = length(avg_num_action_per_run(avg_num_action_per_run<troll_threshold)); 
% user_count = length(avg_num_action_per_run);
% disp([troll_count, user_count, troll_count/user_count*100])
