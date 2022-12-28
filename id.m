function [nowid] = id(state)
global phase;
if(phase < 2)
    nowid = state(1,21:32);
    return;
end
if(phase < 3)
    result = state(1,32:40);
    for e = 1:12
        result(1) = bitor(result(1),bitshift(floor(double(state(e)) / 8),e-1));
    end
    nowid = result;
    return;
end
result = int32(zeros(1,3));
if phase < 4
    for e = 1 : 12
        if state(e)  > 7
            result(1) = bitor(result(1),bitshift(2,2*(e-1)));
        else
            result(1) = bitor(result(1),bitshift(bitand(state(e),1),2*(e-1)));
        end
    end
    for c = 1:8
        result(2)  = bitor(result(2),bitshift(bitand(state(c+12)-12,5),3*(c-1)));
    end
    for i = 13:20
        for j = i+1:20
            result(3) = bitxor(result(3),int32(state(i) > state(j)));
        end
    end
    nowid = result;
    return;
end
nowid = state;
return;
end

