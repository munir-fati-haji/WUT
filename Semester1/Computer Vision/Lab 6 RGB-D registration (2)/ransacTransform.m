function [R, T] = ransacTransform(pts1, pts2, iter, ratio, thr)
% RANSACTRANSFORM Estimate the best transform R, T between the two given 
% point sets, such that pts1 * R + T are as close to pts2 as possible
%
% Inputs:
%   pts1 : first set of points, of size Nx3
%   pts2 : second set of points, of size Nx3
%   iter : maximum number of RanSaC iterations
%   ratio: inliers ratio for the transformation to be treated as good [0..1]
%   thr  : threshold between the points to be treated as the inlier (in meters)

    % prepare output values
    R = eye(3);
    T = [0, 0, 0];
    
    % remember the best solution so far
    best_inl = 0;
    
    % number of point pairs
    N = size(pts1, 1);
    
    for i = 1:iter    
    % =[ your code starts here ]===========================================
   
        % 1. pick three random pairs of points from pts1 and pts2
        [points_in, points_out] = pickRandomPoints(3, pts1, pts2);
        % 2. calculate the [R, T] transform between them
        [R_old, T_old] = estimateTransform(points_in, points_out);
        % 3. apply the transform to the whole data
        pn=pts1*R_old+T_old;
        % 4. count inliers (points between the pts_new and pts2 that are 
        % closer to each other than given threshold
        diff_ = pn - pts2;
        dist_ = sqrt(sum(diff_.^2,2));
        inliners = sum(dist_ < thr);
        % 5. check, if inliers threshold is better than required and break
        % the loop if the solution is found
        ratio_ = inliners/N;

        if ratio_ > best_inl
            R=R_old;
            T=T_old;
            best_inl=ratio_;
        end
    
        if (ratio_ >= ratio)
            break;
        end
    
    % =[ your code ends here ]=============================================
    end

end

