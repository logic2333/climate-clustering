clear; clc;

load('res_vegetation.mat');
veg = res.I;
load('res.mat');
I = res.I;
stat = [];
C = categories(veg);
C(1, :) = [];

for i = 2:max(I, [], 'all')
    if ~isempty(I(I == i))
        counts = histcounts(veg(I == i), C);
        stat = [stat; i - 1 counts / sum(I == i, 'all')];        
    end
end

stat = stat';
C = cellstr(C);
C = ['Category'; C];
stat = array2table(stat, 'RowNames', C);
writetable(stat, 'stat_veg.xlsx', 'WriteVariableNames', false, 'WriteRowNames', true);