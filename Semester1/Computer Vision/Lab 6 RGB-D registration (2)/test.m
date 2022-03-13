%% Test 1
% Read RGB and depth image, calculate XYZ and display the colored cloud

I = imread("rgb/0.png");
D = imread("depth/0.png");
scale = 5000;
fx = 481.2;
fy = 480.0;
cx = 319.5;
cy = 239.5;

% calculate the reprojection
XYZ = reproject(D, scale, fx, fy, cx, cy);

% display the colored cloud
pcshow(XYZ, I);

%% Test 2
% Calculate the transform between two given sets of points

pts1 = [
    1 0 0
    0 1 0
    0 0 1
    2 5 8
    ];

% no rotation
Rin = eye(3);

% simple translation
Tin = [1 2 3];

pts2 = pts1 * Rin + Tin;

[Rout, Tout] = estimateTransform(pts1, pts2)

% difference between the actual and estimated values should be (almost) zero
Rdiff = Rout - Rin;
Tdiff = Tout - Tin;

%% Test 3
% Calculate the transform between two given sets of points

pts1 = [
    1 0 0
    0 1 0
    0 0 1
    2 5 8
    ];

% rotation around the Z axis
theta = pi / 6;
Rin = [
     cos(theta) sin(theta)  0 ; 
    -sin(theta) cos(theta)  0 ; 
          0          0      1
    ];

% no translation
Tin = [0 0 0];

pts2 = pts1 * Rin + Tin;

[Rout, Tout] = estimateTransform(pts1, pts2)

% difference between the actual and estimated values should be (almost) zero
Rdiff = Rout - Rin;
Tdiff = Tout - Tin;

%% Test 4
% Calculate the coarse and refined transforms between the two views

scale = 5000;
fx = 481.2;
fy = 480.0;
cx = 319.5;
cy = 239.5;

I_curr = imread("rgb/380.png");
D_curr = imread("depth/380.png");

I_next = imread("rgb/390.png");
D_next = imread("depth/390.png");

% calculate the reprojection
XYZ_curr = reproject(D_curr, scale, fx, fy, cx, cy);
XYZ_next = reproject(D_next, scale, fx, fy, cx, cy);

% find the matching point pairs between the images
[pts_curr, pts_next] = matchPoints(I_curr, I_next);

% read the 3D coordinates of the matched points
pairs_cnt = size(pts_curr, 1);
pts_curr_3d = zeros(pairs_cnt, 3);
pts_next_3d = zeros(pairs_cnt, 3);

for i=1:pairs_cnt
    % points from matching are in u-v order, i.e. col-row
    pts_curr_3d(i,:) = XYZ_curr(pts_curr(i, 2), pts_curr(i, 1), :);
    pts_next_3d(i,:) = XYZ_next(pts_next(i, 2), pts_next(i, 1), :);
end

% estimate ransac transform [0 0 0]
% for the pair of views 0 and 50, T should be around [-0.26, 0.01, -0.01]
% with the deviation of up to 2-3 cm.
[R, T] = ransacTransform(pts_next_3d, pts_curr_3d, 100, 0.5, 0.02)

tform=rigid3d(R, T);
pc_curr=pointCloud(XYZ_curr, 'Color', I_curr);
pc_next=pointCloud(XYZ_next, 'Color', I_next);
pc_tran=pctransform(pc_next, tform);

figure;
% red cloud is the current (fixed)
pcshow(pc_curr.Location, [1 0 0]);
hold on;
% green cloud is the next (moving)
pcshow(pc_next.Location, [0 1 0]);
% blue cloud is after applying the calculated transform (should overlap the red one)
pcshow(pc_tran.Location, [0 0 1]);

%%
% calculate the refined transform based on the initial one
[R_ref, T_ref] = refineTransform(pc_next, pc_curr, R, T);

% transform the cloud using the refined transform
tform_ref = rigid3d(R_ref, T_ref);
pc_ref=pctransform(pc_next, tform_ref);

figure;
% red cloud is the current (fixed)
pcshow(pc_curr.Location, [1 0 0]);
hold on;
% blue cloud is after applying the calculated coarse transform (should overlap the red one)
pcshow(pc_tran.Location, [0 0 1]);
% green cloud is the ICP refined one (shold overlap the red one even better)
pcshow(pc_ref.Location, [0 1 0]);