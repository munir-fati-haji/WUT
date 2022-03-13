clear;
clc;
close all;

% load sample image
I=imread('door.jpg');

% show the image and wait for the points selection (be sure to check if exactly four points were selected)

% While exactly four points are not selected get points
while 1
    figure(1)
    layout=tiledlayout(1,3);
    title(layout, 'Select exactly 4 corners of the door')
    nexttile;
    imshow(I)

    [x,y] = getpts;

    if length(x) == 4
        clc
        break
    else
        fprintf('Number of inputs should exactly be four \n')
    end
end


% prepare reference points
% fill with appropriate output of the getpts command
points_in = [x';y'];
points_out = [0 0 270 270;0 600 600 0]; %[X;Y]

% calculate the homography - this function should be implemented by you
H = calculate_homography(points_in, points_out);

% prepare image reference information
Rin=imref2d(size(I));

% convert homography matrix to the Matlab projective transformation
t = projective2d(H');

% warp the image and get the output reference information
[I2, Rout]=imwarp(I, Rin, t);
nexttile;
imshow(I2);

% crop the output based on the reference information
I3 = crop_image(I2, Rout, points_out);
nexttile;
imshow(I3);

