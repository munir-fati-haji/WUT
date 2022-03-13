function [pts1, pts2] = matchPoints(I1, I2)
% MATCHPOINTS Find and match the feature points between the given images
% 
% Inputs:
%   I1, I2: input RGB or grayscale images
%
% Outputs:
%   pts1, pts2: positions of matching points on both images

    % Convert images to grayscale if needed
    if size(I1, 3) > 1
        I1 = rgb2gray(I1);
    end
    
    if size(I2, 3) > 1
        I2 = rgb2gray(I2);
    end

    % Find the SURF features. MetricThreshold controls the number of detected
    % points. To get more points make the threshold lower.
    points1 = detectSURFFeatures(I1, 'MetricThreshold', 100);
    points2 = detectSURFFeatures(I2, 'MetricThreshold', 100);

    % Extract the features.
    [f1,vpts1] = extractFeatures(I1, points1);
    [f2,vpts2] = extractFeatures(I2, points2);

    % Match points and retrieve the locations of matched points.
    indexPairs = matchFeatures(f1,f2) ;
    matchedPoints1 = vpts1(indexPairs(:,1));
    matchedPoints2 = vpts2(indexPairs(:,2));

    % Display the matching points. The data still includes several outliers, 
    % but you can see the effects of rotation and scaling on the display of 
    % matched features.
    %figure; showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2, 'montage');
    %legend('matched points 1','matched points 2');
    
    % Extract and return the point pairs (rounded)
    pts1 = round(double(vpts1(indexPairs(:,1)).Location));
    pts2 = round(double(vpts2(indexPairs(:,2)).Location));
end
