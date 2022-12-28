I = imread("7.jpg");
out = cut_square(I);
imwrite(out,"7.png");
imshow(out);
% mapIn = color_detection();
% solvecube;