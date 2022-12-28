function [outputArg] = sos(answ,rgb)
    vec = [53.535697,123.980734,192.216981;
        243.618320,115.251637,93.534082;
        4.836534,183.129883,70.126067;
        150.352498,39.116838,48.162118;
        156.707638,211.256991,36.489513;
        159.433170,191.461176,218.201655];
    % rgb = load("rgb.txt");
    mapid = zeros(1,6);
    for i = 1:6
        maxc = veccos(vec(i, :), rgb(1, :));
        maxj = 1;
        for j = 2:7
            if maxc < veccos(vec(i, :), rgb(j, :))
                maxj = j;
                maxc = veccos(vec(i, :), rgb(j, :));
            end
        end
        mapid(i) = maxj;
    end

    disp(vec(1, :))
    disp(rgb(1, :))
    disp(answ);
    disp(rgb);
    disp(mapid);

    [m,n] = size(answ);
    ret = zeros(m,n);
    for i = 1:m
        for j = 1:n
            for k = 1:6
                if mapid(k) == answ(i,j)
                    ret(i,j) = k;
                end
            end
        end
    end

    outputArg = ret
end

