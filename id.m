function [nowid] = id(state) %取出输入状态的方向的值id
    global phase; %整个西斯尔思韦特的步骤
    %--- Phase 1: Edge orientations.（//第一步：棱块取向）
    if(phase < 2)
        nowid = state(1,21:32); %返回输入state状态的棱块的取向，共12位，0表示方向正确，1表示方向错误（即翻转了180°）
        return; %返回state中下标为20到31即state[20]-state[31]共12个值  值为棱块方向
    end
    %-- Phase 2: Corner orientations, E slice edges.（//第二步：角块方向，E层（即中间层）棱块）
    if(phase < 3)
        result = state(1,32:40); %将state中下标为31到39即state[31]-state[39]共9个值赋值给result	//取角块的方向值给result
        for e = 1:12
            result(1) = bitor(result(1),bitshift(floor(double(state(e)) / 8),e-1)); %result[0]用于存E层（中间层）楞块的位置（用二进制表示）
        end
        nowid = result; %返回角块的方向（0.1.2）和E层楞块的位置（result[0]）
        return;
    end
    result = int32(zeros(1,3)); %重新定义result为长度为3的整型向量
    %--- Phase 3: Edge slices M and S, corner tetrads, overall parity.（//第三步：M层S层的楞块，对应角块呈现正四面体型）
    if phase < 4
        for e = 1 : 12
            if state(e)  > 7
                result(1) = bitor(result(1),bitshift(2,2*(e-1))); %result[1]用24位存12个楞块位置正确，
            else
                result(1) = bitor(result(1),bitshift(bitand(state(e),1),2*(e-1)));
            end
        end
        for c = 1:8
            result(2)  = bitor(result(2),bitshift(bitand(state(c+12)-12,5),3*(c-1))); %result[2]用24位存放8个角块的位置
        end
        for i = 13:20
            for j = i+1:20
                result(3) = bitxor(result(3),int32(state(i) > state(j))); %result[3]=0表示角块方向正确，result[3]=1表示角块方向错误
            end
        end
        nowid = result;
        return;
    end
    %--- Phase 4: The rest.
    nowid = state;
    return;
end

