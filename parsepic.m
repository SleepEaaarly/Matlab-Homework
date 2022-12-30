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
    
    st = 1;
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
    numMap = containers.Map();
    numMap(mapB(2,2)) = "B";
    numMap(mapL(2,2)) = "L";
    numMap(mapU(2,2)) = "U";
    numMap(mapR(2,2)) = "R";
    numMap(mapF(2,2)) = "F";
    numMap(mapD(2,2)) = "D";
    right_cube={'UF','UR','UB','UL','DF','DR','DB','DL','FR','FL','BR','BL','UFR','URB','UBL','ULF','DRF','DFL','DLB','DBR'};%正序
    statusStr(1) = strcat(numMap(mapU(3,2)),numMap(mapF(1,2)));
    statusStr(2) = strcat(numMap(mapU(2,3)),numMap(mapR(1,2)));
    statusStr(3) = strcat(numMap(mapU(1,2)),numMap(mapB(3,2)));
    statusStr(4) = strcat(numMap(mapU(2,1)),numMap(mapL(1,2)));
    statusStr(5) = strcat(numMap(mapD(1,2)),numMap(mapF(3,2)));
    statusStr(6) = strcat(numMap(mapD(2,3)),numMap(mapR(3,2)));
    statusStr(7) = strcat(numMap(mapD(3,2)),numMap(mapB(1,2)));
    statusStr(8) = strcat(numMap(mapD(2,1)),numMap(mapL(3,2)));
    statusStr(9) = strcat(numMap(mapF(2,3)),numMap(mapR(2,1)));
    statusStr(10) = strcat(numMap(mapF(2,1)),numMap(mapL(2,3)));
    statusStr(11) = strcat(numMap(mapB(2,3)),numMap(mapR(2,3)));
    statusStr(12) = strcat(numMap(mapB(2,1)),numMap(mapL(2,1)));
    statusStr(13) = strcat(numMap(mapU(3,3)),numMap(mapF(1,3)),numMap(mapR(1,1)));
    statusStr(14) = strcat(numMap(mapU(1,3)),numMap(mapR(1,3)),numMap(mapB(3,3)));
    statusStr(15) = strcat(numMap(mapU(1,1)),numMap(mapB(3,1)),numMap(mapL(1,1)));
    statusStr(16) = strcat(numMap(mapU(3,1)),numMap(mapL(1,3)),numMap(mapF(1,1)));
    statusStr(17) = strcat(numMap(mapD(1,3)),numMap(mapR(3,1)),numMap(mapF(3,3)));
    statusStr(18) = strcat(numMap(mapD(1,1)),numMap(mapF(3,1)),numMap(mapL(3,3)));
    statusStr(19) = strcat(numMap(mapD(3,1)),numMap(mapL(3,1)),numMap(mapB(1,1)));
    statusStr(20) = strcat(numMap(mapD(3,3)),numMap(mapB(1,3)),numMap(mapR(3,3)));
    status = statusStr;
    return;
end

