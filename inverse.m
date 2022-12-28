function [Ans] = inverse(move)
Ans = move + 2 - 2 * (mod(move,3));
return;
end

