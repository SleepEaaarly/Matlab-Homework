function [ret] = getvalue(map,key)
    if isKey(map,key)
        ret = map(key);
    else
        ret = 0;
    end
    return;
end

