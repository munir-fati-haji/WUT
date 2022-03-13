clc
clear
close all

imgFiles = dir('*.png');   % get all jpg files in current directory 
numfiles = length(imgFiles);  % total number of files 

% Prepare output vectors
statU=zeros(size(numfiles));  
statV=zeros(size(numfiles));
statr=zeros(size(numfiles));
statX=zeros(size(numfiles));
statY=zeros(size(numfiles));
statZ=zeros(size(numfiles));

for k = 1:numfiles-2   % loop for each file 
    img = imgFiles(k).name;    % present image file 
    
    % segmentation and calculation of the ball parameters is done
    [statU(k),statV(k),statr(k),statX(k),statY(k),statZ(k)]=statusofBall(img); 
    
    %Results visualization
    % Read RGB of present image file
    currentImage=imread(img);
    %Position the ball
    RGB = insertShape(currentImage,"FilledCircle",[statU(k) (1296-statV(k)) statr(k)],"Opacity",0.5,Color="green");
    imshow(RGB);
end

% Trajectory estimation and prediction
    figure;
    p=polyfit(statU(4:21),statV(4:21),2);
    y1=polyval(p,statU);
    plot(statU,y1,"--o")
    hold on
    plot(statU,statV,'--')
    hold off
    title("Curve Fitting");
    legend("Curve Fit","Original")



