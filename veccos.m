function cosans = veccos(vec1, vec2)
    [m1,n1] = size(vec1);
    [m2,n2] = size(vec2);
    if n1 ~= n2 || m1 ~= m2
        cosans = -1;
    else
        cosans = sum(vec1.*vec2) / (norm(vec1) * norm(vec2));
    end
end