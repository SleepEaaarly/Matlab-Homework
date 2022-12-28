function [num] = get_index(rgbMap, main_co_rgb, i, j, picture_num)
    [x_len, y_len, ~] = size(rgbMap);
    [class_num, ~] = size(main_co_rgb);
    freq = zeros(class_num);
    
    x_left = (i - 1) * x_len / 3 + 1;
    x_right = i * x_len / 3 - 1;
    
    y_len = y_len / 6;
    y_left = (j - 1) * y_len / 3 + (picture_num - 1) * y_len + 1;
    y_right = j * y_len / 3 + (picture_num - 1) * y_len - 1;

    % randomly select 100*100 seeds and match a similar color
    for ii = 1:100
        for jj = 1:100
            temp_x = fix(unifrnd(x_left, x_right));
            temp_y = fix(unifrnd(y_left, y_right));
            
            for kk = 1:class_num
                if rgbMap(temp_x, temp_y, 1) == main_co_rgb(kk, 1) && rgbMap(temp_x, temp_y, 2) == main_co_rgb(kk, 2) && rgbMap(temp_x, temp_y, 3) == main_co_rgb(kk, 3)
                    freq(kk) = freq(kk) + 1;
                end
            end    
        end
    end 

    % find the max_freq index for the specific block
    num = -1;
    max_freq = -1;
    for ii = 1:class_num
        if freq(ii) > max_freq
            max_freq = freq(ii);
            num = ii;
        end    
    end    
end