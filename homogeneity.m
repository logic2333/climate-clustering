% homogeneity score of V-measure
% I1 is reference(Koppen or vegetation, C), I2 is the clustering to be
% evaluated(K)
% score(C, K) = 1 - (H(C|K) + H(K)) / (H(C) + H(K))   harmonic, penalizes
% more clusters, as more clusters favor high homogeneity
% score(C, K) = 1 - H(C|K) / H(C)                     not harmonic
% score = 2 / (1 / score(C, K) + 1 / score(K, C))     dual
% class label 1 in I1, I2 stands for ocean, which should be ignored

function score = homogeneity(I1, I2, dual, harmonic)
    I1 = uint8(I1); I2 = uint8(I2);
    ent1 = entropy(I1(I1 ~= 1)); % H(C)
    ent2 = entropy(I2(I2 ~= 1)); % H(K)
    ent12 = 0;                   % H(C|K)
    num_clusters = max(I2, [], 'all');
    cnt = 0;
    for i = 2:num_clusters
        t = I1(I2 == i & I1 ~= 1);
        if ~isempty(t)
            cnt = cnt + length(t);
            ent12 = ent12 + entropy(t) * length(t);
        end
    end
    ent12 = ent12 / cnt;
    if harmonic
        score = 2 * (1 - (ent12 + ent2) / (ent1 + ent2));
    else
        score = 1 - ent12 / ent1;
    end
    if dual
        score = 2 / (1 / score + 1 / homogeneity(I2, I1, false, harmonic));
    end
end