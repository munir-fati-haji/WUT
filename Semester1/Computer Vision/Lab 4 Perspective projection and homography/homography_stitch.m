clear;
clc;
close all;

% load sample image
I1=imread('974-1.jpg');
I2=imread('975-1.jpg');

% show the image and wait for the points selection (be sure to check if exactly four points were selected)

% While exactly four points are not selected get points picture 1
while 1
    figure(1)
    imshow(I1)
    title('Select exactly 4 corners for stiching - Picture 1')
    [x,y] = getpts;
    close(figure(1))
    if length(x) == 4
        clc
        break
    else
        fprintf('Number of inputs should exactly be four \n')
    end
end

% While exactly four points are not selected get points picture 2
while 1
    figure(1)
    imshow(I2)
    title('Select exactly 4 corners for stiching - Picture 2')
    [X,Y] = getpts;
    close(figure(1))
    if length(X) == 4
        clc
        break
    else
        fprintf('Number of inputs should exactly be four \n')
    end
end

% prepare reference points
% fill with appropriate output of the getpts command
points_in = [x';y'];
points_out = [X';Y'];

% calculate the homography - this function should be implemented by you
H = calculate_homography(points_in, points_out);

% prepare image reference information
Rin1=imref2d(size(I1));
Rin2=imref2d(size(I2));

% convert homography matrix to the Matlab projective transformation
t = projective2d(H');

% warp the image and get the output reference information
[I3, Rout]=imwarp(I1, Rin1, t);
nexttile;
imshow(I3);
p = imfuse(I2,Rin2, I3, Rout,'blend');
imshow(p)
    
