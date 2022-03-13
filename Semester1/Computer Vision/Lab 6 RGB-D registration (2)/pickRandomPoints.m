function [p1, p2] = pickRandomPoints(cnt, pts1, pts2)
% PICKRANDOMPOINTS Pick N random point pairs from the given sets
%
% Inputs:
%   cnt  : number of pairs to return
%   pts1 : first set of points (Nx3)
%   pts2 : second set of points (Nx3)
%
% Outputs:
%   p1   : first subset of points (cnt x 3)
%   p2   : second subset of points (cnt x 3)

    ids = randperm(size(pts1, 1), cnt);
    
    p1 = pts1(ids, :);
    p2 = pts2(ids, :);

end

