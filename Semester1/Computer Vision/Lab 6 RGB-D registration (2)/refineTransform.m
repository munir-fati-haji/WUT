function [R_ref, T_ref] = refineTransform(pc_next, pc_curr, R, T)
% REFINETRANSFORM Refine the transformation between the given pointclouds
% given initial [R, T] coarse transform between them. 
%
% Inputs:
%   pc_nect : "moving" pointcloud
%   pc_curr : "fixed" pointcloud
%   R       : coarse rotation matrix
%   T       : coarse translation vector

    % prepare the coarse rigid transform object (can be usefull in the ICP
    % invocation)
    tform_coarse = rigid3d(R, T);

    % invoke the ICP algorithm
    
    % =[ your code starts here ]===========================================
    
    % this is the basic ICP invocation, you have to manipulate the other
    % arguments (tolerance, metric etc.) to get the desired results with
    % your data
    
    tform_icp = pcregistericp(pc_next, pc_curr, 'InitialTransform', tform_coarse,'Metric','pointToPlane','Tolerance',[0.001 0.005]);
        
    % =[ your code ends here ]=============================================
    
    % extract the translation and rotation from the ICP result
    R_ref = tform_icp.Rotation;
    T_ref = tform_icp.Translation;

end