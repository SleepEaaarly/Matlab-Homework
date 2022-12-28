images = [];
for i = 1:1
    I = imread(sprintf("%d.jpg", i));
    out = cut_square(I);
    imwrite(out,sprintf("%d.png", i));
end
% mapIn = color_detection();
% parsepic()
% solvecube;
