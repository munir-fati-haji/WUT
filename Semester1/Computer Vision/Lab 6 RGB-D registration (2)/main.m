close all

scale = 5000;
fx = 481.2;
fy = 480.0;
cx = 319.5;
cy = 239.5;

step = 10;
last_frame = 20;

% 0 - RanSaC only, 1 - use ICP
do_refine = 1;

% initialize the data of the first frame
I_curr = imread("rgb/0.png");
D_curr = imread("depth/0.png");
XYZ_curr = reproject(D_curr, scale, fx, fy, cx, cy);
pc_curr = pointCloud(XYZ_curr, 'Color', I_curr);

% initialize the first pose of the camera
camera_poses = [
    1 0 0 0
    0 1 0 0
    0 0 1 0
    0 0 -2.5 1
];

curr_cam = camera_poses;

% load the reference trajectory
traj = load('traj.txt');

cam_fig = figure;
hold on;
axis equal;

% iterate over all frames
for frame = 1:last_frame
    next_id = frame * step;
    I_next = imread(sprintf("rgb/%d.png", next_id));
    D_next = imread(sprintf("depth/%d.png", next_id));

    % calculate the reprojection
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

    % estimate ransac transform
    [R, T] = ransacTransform(pts_next_3d, pts_curr_3d, 100, 0.5, 0.015);

    tform=rigid3d(R, T);
    pc_next=pointCloud(XYZ_next, 'Color', I_next);

    % create the transformation matrix between the two frames
    Tf = [
        R, zeros(3,1);
        T, 1
    ];

    % calculate and store the camera pose by moving the previous camera by 
    % the current Tf
    next_cam = Tf * curr_cam;
    camera_poses(:,:,frame+1) = next_cam;

    if do_refine > 0
        % calculate the refined transform based on the initial one
        [R_ref, T_ref] = refineTransform(pc_next, pc_curr, R, T);
        % create the transformation matrix between the two frames
        Tf = [
            R_ref, zeros(3,1);
            T_ref, 1
        ];
        next_cam = Tf * curr_cam;
        camera_poses(:,:,frame+1) = next_cam;
    end
    
    
    % store the 'next' values as the 'curr' for the next loop
    I_curr = I_next;
    D_curr = D_next;
    XYZ_curr = XYZ_next;
    pc_curr = pc_next;
    curr_cam = next_cam;
    
    mult = mod(frame-1, 10) / 10;
    
    % plot the cameras
    ref_T = traj(frame+1, 2:4) .* [1 -1 1];
    ref_R = q2r(traj(frame+1, 5:8));
    plotCam(ref_T, ref_R, 0.5, [1.0, mult, 0.0]);
    plotCam(curr_cam(4,1:3), curr_cam(1:3, 1:3), 0.5, [0, mult, 1.0]);
    plotLine(ref_T, curr_cam(4,1:3), [0 0 0])
    
    fprintf('%d/%d\n', frame+1, last_frame);
end



view(0, 0);
xlabel('X')
ylabel('Y')
zlabel('Z')

plot_ate(traj, camera_poses);


function plot_ate(ref, calc)
    cnt = size(calc, 3);
    ate = zeros(1,cnt);
    rte = zeros(1,cnt);
    
    rre = zeros(1,cnt);
    are = zeros(1,cnt);
    
    for i = 2:cnt
        ref_T = ref(i, 2:4) .* [1 -1 1];
        ref_R = q2r(ref(i, 5:8));
        
        calc_T = calc(4,1:3,i);
        calc_R = calc(1:3,1:3,i);
        
        ate(i) = sqrt( sum( (ref_T - calc_T).^2 ) );
        
        prev_ref_T = ref(i-1, 2:4) .* [1 -1 1];
        prev_ref_R = q2r(ref(i-1, 5:8));
        ref_dT = ref_T - prev_ref_T;
        ref_dR = ref_R * prev_ref_R^-1;
        
        prev_calc_T = calc(4,1:3,i-1);
        prev_calc_R = calc(1:3,1:3,i-1);
        calc_dT = calc_T - prev_calc_T;
        calc_dR = calc_R * prev_calc_R^-1;
        
        rte(i) = sqrt( sum( (ref_dT - calc_dT).^2 ) );
        
        dR = calc_dR * ref_dR^-1;
        rre(i) = acos(0.5 * (trace(dR) - 1));
        
        dR = calc_R * ref_R^-1;
        are(i) = acos(0.5 * (trace(dR) - 1));
    end
    
    figure
    plot(ate)
    hold on
    plot(rte)
    xlabel('frame')
    ylabel('dist [m]')
    legend('ATE', 'RTE')
    
    figure
    plot(rad2deg(are))
    hold on
    plot(rad2deg(rre))
    xlabel('frame')
    ylabel('angle [deg]')
    legend('ARE', 'RRE')
end

% plot line connecting two cameras
function plotLine(P1, P2, color)
    P = [P1; P2];
    plot3(P(:, 1), P(:, 2), P(:, 3), 'color', color);
end

% calcualte rotation matrix from the quaternion
function R=q2r(q)
    qx = -q(1); 
    qy = q(2);
    qz = q(3);
    qw = q(4);
    
    R = [1 - 2*qy^2 - 2*qz^2   2*qx*qy - 2*qz*qw     2*qx*qz + 2*qy*qw;
         2*qx*qy + 2*qz*qw     1 - 2*qx^2 - 2*qz^2   2*qy*qz - 2*qx*qw;
         2*qx*qz - 2*qy*qw     2*qy*qz + 2*qx*qw     1 - 2*qx^2 - 2*qy^2]';
     
    toggle = [1, 0, 0; 0 0 1; 0 1 0];
    %R = toggle * R * toggle;
end

% plot the simple 3D camera
function plotCam(T, R, scale, color)
    w=0.03;
    h=0.02;
    d=0.1;
    model = [
        0 0 0
        -w -h d
        -w h d
        0 0 0
        w -h d
        w h d
        0 0 0
    ] * scale;

    model = T + model * R;
    plot3(model(:, 1), model(:, 2), model(:, 3), 'color', color);
end
