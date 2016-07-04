
function render_interval_dist(data, title_)
    x_label_str={'0~5','5~10','10~30','30~60','1~5Ка','5Ка~'};
    total_action_cnt = max(1,sum(data,2));
    a=bsxfun(@rdivide,data,total_action_cnt);
    bar(1:numel(x_label_str), a');
    text(1:numel(x_label_str),a',num2str(a',' %0.2f'),...
    'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
    set(gca,'XTickLabel', x_label_str,'XTick',1:numel(x_label_str));
    title(title_);
    ylabel('Freq');
    axis([0 numel(x_label_str)+1 0 1])
    
end