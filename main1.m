% 非GUI版 main测试
images = [];
for i = 1:6
    I = imread(sprintf("%d.jpg", i));
    out = cut_square(I);
    imwrite(out,sprintf("%d.png", i));
end
%% 然后以下3行逐行在命令行窗口执行
% mapIn = color_detection();
% parsepic()
% solvecube;
