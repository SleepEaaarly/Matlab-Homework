function [status] = parsepic()
%将图片色块转化为状态字符串
mapIn = load('input.txt');
% size(mapIn)
for i = 1:18
    for j = 1:3
        if mapIn(i,j) == 7
            mapIn(i,j) = 3;
        end
    end
end

st =1;
for i = 1:6
    for j = st:st+2
        for z = 1:3
            switch i
                case 1
                    mapU(j-st+1,z) = num2str(mapIn(j,z));
                case 2
                    mapF(j-st+1,z) = num2str(mapIn(j,z));
                case 3
                    mapD(j-st+1,z) = num2str(mapIn(j,z));
                case 4
                    mapB(j-st+1,z) = num2str(mapIn(j,z));
                case 5
                    mapL(j-st+1,z) = num2str(mapIn(j,z));
                case 6
                    mapR(j-st+1,z) = num2str(mapIn(j,z));
            end
        end
    end
    st = st + 3;
end
numMp = containers.Map();
numMp(mapB(2,2)) = "B";
numMp(mapL(2,2)) = "L";
numMp(mapU(2,2)) = "U";
numMp(mapR(2,2)) = "R";
numMp(mapF(2,2)) = "F";
numMp(mapD(2,2)) = "D";
right_cube={'UF','UR','UB','UL','DF','DR','DB','DL','FR','FL','BR','BL','UFR','URB','UBL','ULF','DRF','DFL','DLB','DBR'};%正序
Ans(1) = strcat(numMp(mapU(3,2)),numMp(mapF(1,2)));
Ans(2) = strcat(numMp(mapU(2,3)),numMp(mapR(1,2)));
Ans(3) = strcat(numMp(mapU(1,2)),numMp(mapB(3,2)));
Ans(4) = strcat(numMp(mapU(2,1)),numMp(mapL(1,2)));
Ans(5) = strcat(numMp(mapD(1,2)),numMp(mapF(3,2)));
Ans(6) = strcat(numMp(mapD(2,3)),numMp(mapR(3,2)));
Ans(7) = strcat(numMp(mapD(3,2)),numMp(mapB(1,2)));
Ans(8) = strcat(numMp(mapD(2,1)),numMp(mapL(3,2)));
Ans(9) = strcat(numMp(mapF(2,3)),numMp(mapR(2,1)));
Ans(10) = strcat(numMp(mapF(2,1)),numMp(mapL(2,3)));
Ans(11) = strcat(numMp(mapB(2,3)),numMp(mapR(2,3)));
Ans(12) = strcat(numMp(mapB(2,1)),numMp(mapL(2,1)));
Ans(13) = strcat(numMp(mapU(3,3)),numMp(mapF(1,3)),numMp(mapR(1,1)));
Ans(14) = strcat(numMp(mapU(1,3)),numMp(mapR(1,3)),numMp(mapB(3,3)));
Ans(15) = strcat(numMp(mapU(1,1)),numMp(mapB(3,1)),numMp(mapL(1,1)));
Ans(16) = strcat(numMp(mapU(3,1)),numMp(mapL(1,3)),numMp(mapF(1,1)));
Ans(17) = strcat(numMp(mapD(1,3)),numMp(mapR(3,1)),numMp(mapF(3,3)));
Ans(18) = strcat(numMp(mapD(1,1)),numMp(mapF(3,1)),numMp(mapL(3,3)));
Ans(19) = strcat(numMp(mapD(3,1)),numMp(mapL(3,1)),numMp(mapB(1,1)));
Ans(20) = strcat(numMp(mapD(3,3)),numMp(mapB(1,3)),numMp(mapR(3,3)));
status = Ans;
return;
end

