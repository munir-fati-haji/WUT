% maximal_control_error = 0.01;
% maximum_vel = cubic_vel(tf/2);
% time_response = maximal_control_error/maximum_vel;
w = 45;
Kp = (w^2*Jm*R)/Km;
Kd = R*(2*w*Jm-B)/Km;