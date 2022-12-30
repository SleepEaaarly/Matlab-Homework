function [canfind] = myfind(str,tarstr)
    [~,length] = size(str);
    for i = 1:length
        if strcmp(str(i),tarstr)
            canfind = true;
            return;
        end
    end
    canfind = false;
    return;
end

