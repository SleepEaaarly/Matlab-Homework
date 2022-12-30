function [face_info] = color_detection()
    % load six images
    images=[];
    for i = 1:6
        ori_image=imread(sprintf("%d.png",i));
        image=imresize(ori_image,[1000,1000]);
        images=[images, image];
    end

    % show the original images
    figure(1)
    % imshow(images)

    % convert rgb to yux space
    labs=rgb2ycbcr(images);
    reshape_labs=labs(:,:,2:3);
    lab_images=im2single(reshape_labs);

    % kmeans for classify
    labels=imsegkmeans(lab_images,6,NumAttempts=3);

    % show the first-processed images
    figure(2)
    % imshow(labels,[]);

    % initiate for coloring
    color = zeros(6,3);
    ids = double(images);
    centers = double(zeros(6,3,'double'));

    % initiate for channels
    R=zeros(size(labels,1),size(labels,2));
    G=zeros(size(labels,1),size(labels,2));
    B=zeros(size(labels,1),size(labels,2));

    % preprocess
    for i = 1:1000
        for j = 1:6000
            if ids(i,j,1)<50 && ids(i,j,2)<50 && ids(i,j,3)<50
                ids(i,j,1)=255;
                ids(i,j,2)=255;
                ids(i,j,3)=255;
            end
        end
    end

    % set the color of a classified label as the mean of these seeds
    for i=1:6
        for j=1:3
            mask=labels==i;
            tmp=ids(:,:,j);
            color(i,j)=mean(tmp(mask));
            if(j==1)
                R(mask)= color(i,j);
            end
            if(j==2)
                G(mask)= color(i,j);
            end
            if(j==3)
                B(mask)= color(i,j);
            end
        end
    end

    % show the final_processed images
    map=cat(3,R,G,B);
    figure(3);
    % imshow(uint8(map))  

    answ=[];
    for i = 1:6
        for j = 1:3
            res=[];
            for k = 1:3
                color_num=get_index(map, color, j, k, i);
                % if color_num==7
                %     color_num=3;
                % end
                res=[res,color_num];
            end
            answ=[answ;res];
        end  
    end
       
    % save color info
    f2 = fopen('color_7.txt','w');
    for i = 1:6
        new_i=i;
        for j = 1:3
            fprintf(f2, '%f ', color(new_i, j));
        end
        fprintf(f2, '\n');
    end    

    face_info=cube_map(answ,color);
    
    fid = fopen("input.txt","w+");
    for i=1:18
        for j=1:3
            fprintf(fid,"%g ", face_info(i,j));
        end
        fprintf(fid,"\n");
    end
    fclose(fid);
%    xlswrite("input.xlsx",face_info);

end