function s = inverse_quantile(X, y)
    sortedX = sort(X);
    listCumProb = (1/length(X))*(0.5:1:length(X)-0.5);
    s = interp1(sortedX, listCumProb, y);
end