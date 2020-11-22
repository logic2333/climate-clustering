function val = my_silhouette(dat, I, is_silhouette)
    X = dat(:, 1:end-3);
    num_records = size(X, 1);
    clust = zeros(num_records, 1);
    for i = 1:num_records
        clust(i, 1) = I(dat(i, end-2), dat(i, end-1));
    end
    if is_silhouette
        eva = evalclusters(X, clust, 'silhouette', 'Distance', 'Euclidean');
        val = eva.CriterionValues(1);
    else
        eva = evalclusters(X, clust, 'CalinskiHarabasz');
        val = eva.CriterionValues(1);
    end

end