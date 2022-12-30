global applicableMoves;
global affectedCubies; 
global phase;
% global mapIn;

% 0, 262143/*18个1*/, 259263/*111111010010111111*/, 74943/*10010010010111111*/, 74898/*10010010010010010*/
applicableMoves = [0, 262143, 259263, 74943, 74898];

%对每一个块编码，前四位棱块，后四位角块（顶层右下角开始0.1.2.3，底层右下角开始4.5.6.7），相同块数字相同
affectedCubies = [  0,  1,  2,  3,  0,  1,  2,  3;
                    4,  7,  6,  5,  4,  5,  6,  7;
                    0,  9,  4,  8,  0,  3,  5,  4;
                    2, 10,  6, 11,  2,  1,  7,  6;
                    3, 11,  7,  9,  3,  2,  6,  5;
                    1,  8,  5, 10,  1,  0,  4,  7];

%设置结果输出文件
outputFile = fopen('operation.txt','w');
% argv = parsepic(mapIn);
argv = parsepic();

%前十二位为棱块，后八位为角块
goal = ["UF","UR","UB","UL","DF","DR","DB","DL","FR","FL","BR","BL","UFR","URB","UBL","ULF","DRF","DFL","DLB","DBR"];
currentState = int32(zeros(1,40));
goalState = int32(zeros(1,40));

% 该for循环的作用: 将当前魔方状态输入到数表currentState里，
% 												由字母顺序转化到数字顺序，字母顺序包涵了位置和方向，
% 												数字顺序用一位表示位置，一位表示方向。
% 												规则为：0-11/12-19存按goal里编号楞块/角块的数字位置，
% 												20-39存楞块和角块的方向
% 												楞块如需翻转，则20-31对应位置为1；
% 												角块如需旋转，则顺时针旋转90°记为1，顺时针旋转180°记为2
for i = 1:20
    goalState(i) = i - 1; %初始化目标魔方各个楞块和角块的位置
    %--- Current (start) state.（//输入魔方各个楞块和角块的位置）
    cubie = argv(i);
    %和目标魔方块的位置比较，块需要顺时针旋转90°或者楞块翻转180°
    while ~myfind(goal,cubie) %查找cubie在goal中的下标，如没有返回20，下标赋值给currentState[i]
		currentState(i) = 20;
        cubie = extractAfter(cubie,1) + extract(cubie,1); %复制cubie[1]及后面的元素与 cubie[0]连接成新的cubie  如"UF"变成"FU","UFR"变成"FRU"	//旋转后块的字母顺序
		currentState(i+20) = currentState(i+20) + 1; %记录到方向，回到正确位置需要顺时针旋转180°为2，顺时针旋转90°为1
    end
    currentState(i) = find(goal == cubie) - 1;
end

%--- Dance the funky Thistlethwaite...（//开始牛逼的西斯尔思韦特操作）
phase = 1;
q = zeros(1000000,40);
while phase < 5 %开始循环五个过程

    %--- Compute ids for current and goal state, skip phase if equal.（//计算当前和目标状态的方向取值id，如果相等(表明方向正确，不需要调整)则跳过）
    currentId = id(currentState);
    goalId = id(goalState);
    if isequal(currentId,goalId)
        phase = phase + 1;
        continue;
    end

    %--- Initialize the BFS queue.（//初始化BFS（广度优先）队列（先进先出））
    q(1,:) = currentState;
    q(2,:) = goalState;
    front = 1;
    back = 2;

    %--- Initialize the BFS tables.（//初始化BFS算法的图表	map通过平衡二叉树对节点进行存储）
    predecessor = containers.Map(); %旋转前后的状态表存进predecessor，旋转后的表前面出现过则不存（即状态等价不存）
    direction = containers.Map(); %direction：存放不同状态的方向，该状态由输入魔方旋转得到，则关键字为1；由目标魔方旋转得到，关键字为2
    lastmove = containers.Map(); %lastMove：将旋转后的方向值存入并记录当时的move值(即旋转的方式）
    direction(parsestr(currentId)) = 1;
    direction(parsestr(goalId)) = 2; 

    %--- Dance the funky bidirectional BFS...（//开始牛逼的BFS算法）
    flag = 0;
    cnt = 0;
    while 1
        %--- Get state from queue, compute its ID and get its direction.（//从队列获取状态，计算它的ID并得到它的方向）
        oldstate = q(front,:);
        front = front + 1;
        oldId = id(oldstate);
        cnt = cnt + 1;
        oldDir = direction(parsestr(oldId));

        %--- Apply all applicable moves to it and handle the new state.（//将所有适用的动作(每个面旋转90.180.270)应用到它并记录新的状态）
        for move = 0:17
            if bitand(applicableMoves(phase + 1),bitshift(1,move)) ~= 0 %在phase=2时，控制FB面只能旋转180°即降群到<U,D,F2,B2,L,R>
                                                %在phase=3时，控制FBLR面只能旋转180°即降群到<U,D,F2,B2,L2,R2>
												%在phase=4时，控制UDFBLR面只能旋转180°即降群到<U2,D2,F2,B2,L2,R2>
                %--- Apply the move.（//旋转）
                newState = applyMove(move, oldstate); %旋转后的状态
%                if phase == 2
%                    fprintf("%d:",move);
%                    outvi(newState);
%                end
                newId = id(newState); %旋转后的状态各个楞块和角块的方向
%                if phase == 2
%                   outvi(newId);
%                end
                newDir = getvalue(direction,parsestr(newId)); %拥有新方向的状态是否出现过，是，则返回关键字给newDir；否，则以关键字为0存入direction
                lastnewId = newId;
                %--- Have we seen this state (id) from the other direction already?（//判断该状态是否出现过）
                %--- I.e. have we found a connection?（//判断是否能和关键字为2的状态联系起来，如果能，则找到解法，否，则继续搜索）
                if newDir && newDir ~= oldDir %由目标魔方旋转后的状态的方向值与输入魔方某一状态的方向值相等时if成立
                    %--- Make oldId represent the forwards and newId the backwards search state.（//oldId表示之前的状态的方向，newId表示旋转后的状态的方向值，搜索解法）
                    if oldDir > 1
                        temp = newId;
                        newId = oldId;
                        oldId = temp;
                        move = inverse(move);
                    end

                    %--- Reconstruct the connecting algorithm.（//重现联系这两个状态的步骤move）
                    algorithm = move; %用于存放步骤
                    while ~isequal(oldId,currentId) %在predecessor表里查找oldId==currentId，并记录需要的步骤到algorithm（算法）
                                                    %即输入魔方按照algorithm的步骤旋转就可到达目标魔方旋转后的状态（即联系direction的关键字1和2）
                        algorithm = [lastmove(parsestr(oldId)),algorithm];
                        oldId = predecessor(parsestr(oldId));
                    end
                    while ~isequal(newId,goalId) %还原到目标魔方状态需要转动的步骤
                        algorithm = [algorithm,inverse(lastmove(parsestr(newId)))];
                        newId = predecessor(parsestr(newId));
                    end
                    %--- Print and apply the algorithm.（//打印并应用该算法）	serial_write(going_write[i]);
                    [~,length] = size(algorithm);
                    op = "UDFBLR";
                    for i = 1:length
                        fprintf(outputFile,"%c %d\n",extract(op,floor(algorithm(i)/3)+1),mod(algorithm(i),3)+1); %打印需要旋转的面和角度，1.2.3顺时针旋转90.180.270
                        currentState = applyMove(algorithm(i), currentState); %旋转后的值赋给currentState（当前值）
                    end

                    %--- Jump to the next phase.
                    flag = 1;
                    break; %进入牛逼的西斯尔思韦特的下一步
                end
                
                %--- If we've never seen this state (id) before, visit it.
                if ~newDir
                    back = back + 1;
                    q(back,:) = newState;
                    direction(parsestr(lastnewId)) = oldDir;
                    lastmove(parsestr(newId)) = move;
                    predecessor(parsestr(newId)) = oldId;
                end
            end
        end
        if flag 
            break;
        end 
    end
    phase = phase + 1;
end
        
        








