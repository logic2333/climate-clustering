clear; clc;

points = hextop([6 6]);
cm = turbo(36);
%cm = turbo(26);
% dict = [6 5 13 14 26 26 ...
% 4 10 15 24 24 25 ...
% 2 3 12 18 21 21 ...
% 7 9 12 17 22 22 ...
% 7 3 9 11 23 19 ...
% 2 1 8 16 20 20];

xlim([-0.5 6]); ylim([-0.5 5]);
set(gca, 'xtick', [1.5-1 3.5-1 5.5-1], 'ytick', [1.5-1 3.5-1 5.5-1], 'TickLength', [0 0]);
xticklabels({'cold', 'mild', 'hot'});
yticklabels({'dry/Medit', 'transitional', 'humid'});
xlabel('temperature'); ylabel('precipitation in accordance with heat');
hold on;
grid_transparency = 0.25;
line([1.5, 1.5], [-0.5, 5], 'Color', [0 0 0 grid_transparency]);
line([3.5, 3.5], [-0.5, 5], 'Color', [0 0 0 grid_transparency]);
line([-0.5, 6], [1.5, 1.5], 'Color', [0 0 0 grid_transparency]);
line([-0.5, 6], [3.5, 3.5], 'Color', [0 0 0 grid_transparency]);
for i = 1:36
    text(points(1, i), points(2, i), sprintf('%d', i), 'Color', cm(i, :));
    %text(points(1, i), points(2, i), sprintf('%d', dict(i)), 'Color', cm(dict(i), :));
end
arrow([0 0], points(:, 36));
text(points(1, 36), points(2, 36)-0.2, 'grow season');
hold off;