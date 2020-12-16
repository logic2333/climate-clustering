from scipy.stats import entropy

def homogeneity(I1, I2, dual, alpha):

    ent1 = entropy(I1)
    ent2 = entropy(I2)
    ent12 = 0
    num_clusters = max(I2)
    cnt = 0
    for i in range(num_clusters):
        t = I1[I2 == i]
        if t is not None:
            cnt = cnt + len(t)
            ent12 = ent12 + entropy(t) * len(t)

    ent12 = ent12 / cnt
    score = (1 + alpha) * (1 - (ent12 + (alpha * ent2)) / (ent1 + (alpha * ent2)))
    if dual:
        score = 2 / (1 / score + 1 / homogeneity(I2, I1, False, alpha))
    return score