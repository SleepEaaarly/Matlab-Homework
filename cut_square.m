function output = cut_square(I)

I = imresize(I, 0.5);
Ig = rgb2gray(I);
Ig = imgaussfilt(Ig, 3);

Ib = edge(Ig);

[H,T,R]=hough(Ib);
P=houghpeaks(H,25,'Threshold',round(0.3*max(H(:))));
lines = houghlines(Ib, T, R, P);   

remove=[];
lines_num = length(lines);
for i=1:lines_num
    count=0;
    
    for j=1:lines_num
        if(abs(lines(i).theta-lines(j).theta)>10 && abs(lines(i).theta-lines(j).theta)<80 || abs(lines(i).theta-lines(j).theta)>100 && abs(lines(i).theta-lines(j).theta)<170)
            count=count+1;
        end
    end
    if(count >= 0.6*lines_num)
        remove=[remove,i];
    end
end
lines(remove)=[];

remove=[];
dis=[];
lines_num = length(lines);
for i=1:lines_num
    d=0;
    n=0;
    for j=1:lines_num
        if(abs(lines(i).theta-lines(j).theta)<10||abs(lines(i).theta-lines(j).theta)>170)
            temp = norm((lines(i).point1+lines(i).point2)/2-(lines(j).point1+lines(j).point2)/2);
            if(temp>20)
                d=d+temp;
                n=n+1;
            end
        end
    end
    dis=[dis,d/n];
end
for i=1:lines_num
    if(dis(i)>3.5*min(dis))
        remove=[remove i];
    end
end
lines(remove)=[];



points = [];
for i = 1:length(lines)
     xy = [lines(i).point1; lines(i).point2];
    for j = 1:length(lines)
        if(i~=j)
            if(abs(lines (i).theta-lines (j).theta)<75||abs(lines (i).theta-lines (j).theta)>105)
                continue
            end
            
            xy1 = [lines(j).point1; lines(j).point2];
            [x, y] = line_intersection([xy(1,1) xy(1,2) xy(2,1) xy(2,2)],[xy1(1,1) xy1(1,2) xy1(2,1) xy1(2,2)]);
            
            points = [points; [round(x) round(y)]];
            
        end
    end
end
x = points(:,1:1);
y = points(:,2:2);
k = boundary(x,y);
% hold on;
% plot(x,y,'.');
% plot(x(k),y(k),'.');
x = x(k);
y = y(k);

dist = norm([x(1),y(1)]-[x(2),y(2)]);
mark1 = 1;
mark2 = 2;
for i = 1:length(k)
    for j = 1:length(k)
        if i ~= j
            temp = norm([x(i),y(i)]-[x(j),y(j)]);
            if temp > dist
                dist = temp;
                mark1 = i;
                mark2 = j;
            end
        end
    end
end

p1 = [x(mark1);y(mark1)];
p2 = [x(mark2);y(mark2)];

dist_p = 0;
dist_n = 0;
markp = 1;
markn = 1;
for i = 1:length(k)
    p0 = [x(i);y(i)];
    dist = det([p2-p1,p0-p1])/norm(p2-p1);
    if dist > dist_p
        dist_p = dist;
        markp = i;
    end
    if dist < dist_n
        dist_n = dist;
        markn = i;
    end
end
p3 = [x(markp);y(markp)];
p4 = [x(markn);y(markn)];
p = [p1,p2,p3,p4]';
x_mean = mean([p1(1),p2(1),p3(1),p4(1)]);
y_mean = mean([p1(2),p2(2),p3(2),p4(2)]);
res_point = zeros(4,2);
for i = 1:4
    pp = p(i,:);
    if pp(1) < x_mean && pp(2) < y_mean
        res_point(3,:) = p(i,:);
    end
    if pp(1) > x_mean && pp(2) > y_mean
        res_point(1,:) = p(i,:);
    end
    if pp(1) < x_mean && pp(2) > y_mean
        res_point(2,:) = p(i,:);
    end
    if pp(1) > x_mean && pp(2) < y_mean
        res_point(4,:) = p(i,:);
    end
end

out_points = [1000 1000; 100 1000 ;100 100;1000 100];
tform = fitgeotrans(res_point, out_points, 'projective');
B = imwarp(I, tform,'OutputView', imref2d( 5*size(I) ));
% imshow(B);
I2=imcrop(B,[100 100 900 900]);

imshow(I2);

output = I2;

end

