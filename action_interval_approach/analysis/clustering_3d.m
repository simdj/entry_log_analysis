% cluster_3d_viewer

% generate 3D dataset here.
% You may put your cluster data into P.
X=[0 1; 0 1; 0 1];
clusters = 5;
points = 100;
std_dev = 0.05;
P = nngenc(X, clusters, points, std_dev);

T = clusterdata(P', 'maxclust', clusters);

figure;
hold on;

Center = zeros(3, clusters);
clrMap = jet(clusters);

for kk = 1:clusters

    plot3(P(1, T==kk), P(2, T==kk), P(3, T==kk), 'LineStyle', 'none','Marker', 'o', 'color', clrMap(kk,:));
    xmean = mean(P(1, T==kk));
    ymean = mean(P(2, T==kk));
    zmean = mean(P(3, T==kk));
    
    text(xmean, ymean, zmean, num2str(kk), 'color', 'k','FontWeight', 'Bold');
end

title('input samples');
xlabel('p(1)');
ylabel('p(2)');
zlabel('p(3)');
grid on;
view(-45, 25);