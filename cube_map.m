function [outputArg] = cube_map(answ,rgb)
    vec = [53.535697,123.980734,192.216981; % blue
        243.618320,115.251637,93.534082; % orange
        4.836534,183.129883,70.126067; % green
        150.352498,39.116838,48.162118; % red
        156.707638,211.256991,36.489513; % yellow
        159.433170,191.461176,218.201655]; % light blue

    RGB = load("color_7.txt");

    mapid = zeros(1,6);
    visit = zeros(1,6);
    for i = 1:6
        % maxc = veccos(vec(i, :), rgb(1, :));
        maxc=abss(vec(i, :), rgb(1, :));
        maxj = 1;
        for j = 2:6
            if visit(j)>0
                continue;
            end
            if maxc < abss(vec(i,:), rgb(j,:))
                maxj = j;
                maxc = abss(vec(i,:), rgb(j,:));
            end
        end
        mapid(i) = maxj;
        visit(maxj) = 1;
    end

    rgb_convert=[];
    for i=1:6
        tmp=[];
        for j=1:3
            tmp=[tmp,RGB(mapid(i),j)];
        end    
        rgb_convert=[rgb_convert;tmp];
    end
    
    fid = fopen("rgb.txt","w+");
    for i=1:6
        for j=1:3
            fprintf(fid,"%g ", rgb_convert(i,j));
        end
        fprintf(fid,"\n");
    end
    fclose(fid);

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

    outputArg = ret;
end

