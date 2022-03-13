% Requirements
q0 = 0; % Initial position
qf = 0.5; % Final position
v0 = 0; % Initial velocity
vf = 0; % Final velocity
t0 = 0; % Movement start
tf = 1; % Movement end

% Trajectory selection
 % Allow access to trajectory functions
CUBIC_ = 0; LSPB_ = 1; SINUSOIDAL_ = 2; STEP_ = 3;
trajectory = CUBIC_; % Initial trajectory is cubic

% 0 Cubic plynomial trajectory
A = [ ... 
    1       t0      t0^2    t0^3; ... 
    0       1       2*t0    3*t0^2; ... 
    1       tf      tf^2    tf^3; ... 
    0       1       2*tf    3*tf^2; ... 
    ];
b = [q0; v0; qf; vf];
a = A\b; % Parameters for cubic polynomial trajectory

% 1 LSPB
tb = 0.2*tf; % blend time
vLSPB = (qf-q0)/(tf-tb);
aLSPB = vLSPB/tb;

% 2 Sinusoidal
sinusoidal_amplitude = 0.25; % rad
sinusoidal_frequency = 1; % rad/s To be correcte after calculating the control

% 3 Step
step_threshold = 0.5; % s