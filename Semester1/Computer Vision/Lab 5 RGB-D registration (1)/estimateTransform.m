function [R, T] = estimateTransform(p1, p2)
% ESTIMATETRANSFORM Estimate rigid ransform between two sets of 3D points
% 
% The estimated transform should be the best fit between the given set of
% points, i.e. p1 * R + T should be (almost) equal to p2
%
% Inputs:
%   p1 : first set of 3D points (stored as a row-vectors)
%   p2 : second set of 3D points (stored as a row-vectors)
%
% Outputs:
%   R : rotation matrix (3x3 in MATLAB format)
%   T : translation vector (single row)

    % prepare output values
    R = eye(3);
    T = [0, 0, 0];

    % =[ your code starts here ]===========================================

    % Find centroid 
    c1 = mean(p1);
    c2 = mean(p2);
    
    % Find deviations from centroid
    d1 = p1-c1;
    d2 = p2-c2;
    
    % Covariance matrix
    C = d1'*d2;
    
    % Solve equations using SVD
    [U,~,V] = svd(C);
    
    % Handle the reflection case
     R = (V * det(V*U') * U')';
     T = (R * mean(p2, 1)' - mean(p1, 1)')';

    % =[ your code ends here ]=============================================
 
end


