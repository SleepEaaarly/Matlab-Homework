function [ret] = inverse(move) %用于返回move的逆动作
    ret = move + 2 - 2 * (mod(move,3));
    return;
end

