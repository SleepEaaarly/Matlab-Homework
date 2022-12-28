function [nowstate] = applyMove(move,state)

global affectedCubies;
turns = mod(move,3)+1;
face = floor(double(move)/3);
while(turns ~= 0)
    turns = turns - 1;
    oldstate = state;
    for i = 0:1:7 
        isCorner = i > 3;
        target = affectedCubies(face + 1,i + 1) + isCorner*12;
        %fprintf("tset %d %d %d %d\n",move,face, i,target);
        if bitand(int32(i),3) == 3 
            killer = affectedCubies(face + 1, i - 3 +1) + isCorner*12;
        else
            killer = affectedCubies(face + 1, i+1 +1) + isCorner*12;
        end
        if i< 4
            orientationDelta = int32(face > 1 && face < 4);
        elseif face < 2
            orientationDelta = 0;
        else
            orientationDelta = 2 - bitand(int32(i) ,1);
        end
        state(target + 1) = oldstate(killer + 1);
        state(target + 20 + 1) = oldstate(killer + 20 + 1) + orientationDelta;
        if turns == 0
            state(target + 20 + 1) = mod(state(target + 20 + 1),(2 + isCorner));
        end
    end
end
nowstate = state;
end

