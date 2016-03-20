function render_lecture_ct(title_,guide, median_vector, mean_vector, lecture_number_list)
display_index = guide>0;
x_label_str=arrayfun(@num2str, lecture_number_list(display_index), 'UniformOutput', false);

data = [guide(display_index)     median_vector(display_index)     mean_vector(display_index)];
hb = bar(data);
set(hb(1), 'FaceColor','b');
set(hb(2), 'FaceColor','g');
set(hb(3), 'FaceColor','r');
legend('Guide','median','mean');
title(title_);
ylabel('Action#');
xlabel('Lecture');
set(gca,'XTickLabel', x_label_str','XTick',1:numel(x_label_str));
end