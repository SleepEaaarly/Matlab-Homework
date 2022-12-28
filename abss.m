function [ret] = abss(vec1,vec2)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明

tmp1=abs(vec1(1)*vec1(1)-vec2(1)*vec2(1));
tmp2=abs(vec1(2)*vec1(2)-vec2(2)*vec2(2));
tmp3=abs(vec1(3)*vec1(3)-vec2(3)*vec2(3));
ret=1000-(tmp1+tmp2+tmp3);
end

