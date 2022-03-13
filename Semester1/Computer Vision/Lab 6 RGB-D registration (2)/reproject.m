function XYZ = reproject(depth, scale, fx, fy, cx, cy)
% REPROJECT Reproject depth values to 3D coordinates using camera
% intrinsic parameters
%   
% Inputs:
%   depth  : depth map image 
%   scale  : depth scaling factor
%   fx, fy : focal lengths
%   cx, cy : principal point

    % convert depth values to real numbers
    depth = double(depth);

    % create the X, Y and Z arrays of the same size as the input image
    X = zeros(size(depth));
    Y = zeros(size(depth));
    
    % Z coordinate is read directly from the depth image by scaling it
    Z = depth / scale;
    
    % =[ your code starts here ]==========================================
    
    sz = size(Z);
    [x, y] = meshgrid(1:sz(2), 1:sz(1));
    X = Z.*(x-cx)./fx;
    Y = Z.*(y-cy)./fy;

    % =[ your code ends here ]=============================================
    
    % create the resulting MxNx3 matrix storing the XYZ coordinates for
    % every point
    XYZ = X;
    XYZ(:,:,2) = Y;
    XYZ(:,:,3) = Z;
end

