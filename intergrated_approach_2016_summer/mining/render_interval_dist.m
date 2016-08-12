
function render_interval_dist(data, title_)
    x_label_str={'~5','5~10','10~30','30~60','60~'};
    total_run_count = max(1,sum(data,2));
    mean_interval=bsxfun(@rdivide,data,total_run_count);
    bar(1:numel(x_label_str), mean_interval');
    text(1:numel(x_label_str),mean_interval',num2str(mean_interval',' %0.2f'),...
    'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
    set(gca,'XTickLabel', x_label_str,'XTick',1:numel(x_label_str));
    title(title_);
    ylabel('Freq');
    axis([0 numel(x_label_str)+1 0 1])
    
end