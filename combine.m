clear; clc;

for i = 1:20
    back = imread(sprintf('%d_.png', i));
    front = imread(sprintf('%d.png', i));
    height_back = size(back, 1);
    width_back = size(back, 2);
    height_front = size(front, 1);
    width_front = size(front, 2);
    back(height_back - height_front + 1:end, 1:width_front, :) = front;
    imwrite(back, sprintf('A%d.png', i));
end