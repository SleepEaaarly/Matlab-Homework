global applicableMoves;
global affectedCubies; 
global phase;
% global mapIn;
applicableMoves = [0, 262143, 259263, 74943, 74898];
affectedCubies = [0,  1,  2,  3,  0,  1,  2,  3;
    4,  7,  6,  5,  4,  5,  6,  7;
    0,  9,  4,  8,  0,  3,  5,  4;
    2, 10,  6, 11,  2,  1,  7,  6;
    3, 11,  7,  9,  3,  2,  6,  5;
    1,  8,  5, 10,  1,  0,  4,  7];

fid = fopen('operation.txt','w');
% argv = parsepic(mapIn);
argv = parsepic();
goal = ["UF","UR","UB","UL","DF","DR","DB","DL","FR","FL","BR","BL","UFR","URB","UBL","ULF","DRF","DFL","DLB","DBR"];
currentState = int32(zeros(1,40));
goalState = int32(zeros(1,40));
for i = 1:20
    goalState(i) = i-1;
    cubie = argv(i);
    while ~Findstr(goal,cubie)
		currentState(i) = 20;
        cubie = extractAfter(cubie,1) + extract(cubie,1);
		currentState(i+20) = currentState(i+20) + 1;
    end
    currentState(i) = find(goal == cubie) - 1;
end
phase = 1;
q = zeros(1000000,40);
while phase < 5
    currentId = id(currentState);
    goalId = id(goalState);
    if isequal(currentId,goalId)
        phase = phase + 1;
        continue;
    end
    q(1,:) = currentState;
    q(2,:) = goalState;
    front = 1;
    back = 2;
    predecessor = containers.Map();
    direction = containers.Map();
    lastmove = containers.Map();
    direction(parsestr(currentId)) = 1;
    direction(parsestr(goalId)) = 2; 
    flag = 0;
    cnt = 0;
    while 1
        oldstate = q(front,:);
        front = front + 1;
        oldId = id(oldstate);
        cnt = cnt + 1;
        oldDir = direction(parsestr(oldId));
        for move = 0:17
            if bitand(applicableMoves(phase + 1),bitshift(1,move)) ~= 0
                newState = applyMove(move, oldstate);
%                if phase == 2
%                    fprintf("%d:",move);
%                    outvi(newState);
%                end
                newId = id(newState);
%                if phase == 2
%                   outvi(newId);
%                end
                newDir = getvalue(direction,parsestr(newId));
                lastnewId = newId;
                if newDir && newDir ~= oldDir
                    if oldDir > 1
                        temp = newId;
                        newId = oldId;
                        oldId = temp;
                        move = inverse(move);
                    end
                    algorithm = move;
                    while ~isequal(oldId,currentId)
                        algorithm = [lastmove(parsestr(oldId)),algorithm];
                        oldId = predecessor(parsestr(oldId));
                    end
                    while ~isequal(newId,goalId) 
                        algorithm = [algorithm,inverse(lastmove(parsestr(newId)))];
                        newId = predecessor(parsestr(newId));
                    end
                    [~,length] = size(algorithm);
                    op = "UDFBLR";
                    for i = 1:length
                        fprintf(fid,"%c %d\n",extract(op,floor(algorithm(i)/3)+1),mod(algorithm(i),3)+1);
                        currentState = applyMove(algorithm(i), currentState);
                    end
                    flag = 1;
                    break;
                end
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
    phase=phase + 1;
end
        
        








