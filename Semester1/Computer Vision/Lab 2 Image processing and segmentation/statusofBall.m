function [u,v,r,x,y,z]=statusofBall(imgname)
% Read the image 
I = imread(imgname);

%Create Mask
[bg1,~]=createMask1(I);
[bg2,~]=createMask2(I);
[bg3,~]=createMask3(I);

%Combine the created mask
bg12=or(bg1,bg2);
bg123=or(bg12,bg3);
    
c=segmentImage(I,bg123); %Segment the combined mask

%Calculating the ball parameters (image)
stats=regionprops(c,'Centroid','EquivDiameter');
u=stats.Centroid(1,1);
v=1296-stats.Centroid(1,2);
d=stats.EquivDiameter(1,1);
r=d/2;

%calibration parameters
fx=1.410286280662771e+03;
fy=1.411201655272964e+03;
cx=6.109592316589534e+02;
cy=5.519463767814938e+02;

% Given diameter of the ball
D=200;

% Calculating the ball parameters (world)
z=(fx*D)/d;
x=(z*(u-cx))/fx;
y=(z*(v-cy))/fy;
end