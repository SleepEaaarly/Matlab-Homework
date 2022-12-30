%%
% 对state状态进行旋转(顺时针90°180°270°)，返回旋转后的状态
% 
% move=0时，U面顺时针旋转90°move=1时，U面顺时针旋转180°move=2时，U面顺时针旋转270°
% move=3时，D面顺时针旋转90°move=4时，D面顺时针旋转180°move=5时，D面顺时针旋转270°
% move=6时，F面顺时针旋转90°move=7时，F面顺时针旋转180°move=8时，F面顺时针旋转270°
% move=9时，B面顺时针旋转90°move=10时，B面顺时针旋转180°move=11时，B面顺时针旋转270°
% move=12时，L面顺时针旋转90°move=13时，L面顺时针旋转180°move=14时，L面顺时针旋转270°
% move=15时，R面顺时针旋转90°move=16时，R面顺时针旋转180°move=17时，R面顺时针旋转270°

%%
function [currentState] = applyMove(move,state) %move的值为0-17，每个面3种移动情况
    global affectedCubies;
    turns = mod(move,3)+1; %move对3求余+1  旋转90°的次数
    face = floor(double(move)/3); %move除3取整    定义旋转哪一个面 //0U,1D,2F,3B,4L,5R.
    while(turns ~= 0) %顺时针旋转turns个90°
        turns = turns - 1;
        orgState = state;
        for i = 0:1:7 %在旋转过程中分别对8个楞块和8个角块的方向进行赋值
            isCorner = i > 3; %判断是不是角块	将i>3的逻辑判断结果（0，1）赋给isCorner i>3才能取到affectedCubies中的后四位，即角块
            target = affectedCubies(face + 1,i + 1) + isCorner*12; %瞄准某个小色块，棱块面不加，角块面加12
            %fprintf("tset %d %d %d %d\n",move,face, i,target);
            %将面按顺序的下一个楞块或者角块的值取出来（用于移位）
            %i & 3:锁定第4个棱块或第4个角块  [(i & 3) == 3 ? i - 3 : i + 1]:得到第1个棱块或第1个角块 ，或i+1即下一个色块
            if bitand(int32(i),3) == 3 
                killer = affectedCubies(face + 1, i - 3 +1) + isCorner*12;
            else
                killer = affectedCubies(face + 1, i+1 +1) + isCorner*12;
            end
            %顺时针旋转后方向改变量（0.1.2）
            %棱块F/B面orientationDelta =1		角块U/D面orientationDelta =0，F/B/L/R面 1/3角块orientationDelta =2，2/4角块orientationDelta =1
            if i< 4
                orientationDelta = int32(face > 1 && face < 4);
            elseif face < 2
                orientationDelta = 0;
            else
                orientationDelta = 2 - bitand(int32(i) ,1);
            end
            %用后一个替换前一个，完成顺时针旋转
            state(target + 1) = orgState(killer + 1);
            state(target + 20 + 1) = orgState(killer + 20 + 1) + orientationDelta; %记录旋转后方向的值
            if turns == 0 %如果turns!=0即还要旋转，则不进入；若turns==0，则进入求余，防止方向值超过（0.1）或（0.1.2）
                state(target + 20 + 1) = mod(state(target + 20 + 1),(2 + isCorner)); %楞块和2求余，角块和3求余，不改变方向的值
            end
        end
    end
    currentState = state; %返回的是经过移动int move 后的状态state，state存储了魔方的状态
end

