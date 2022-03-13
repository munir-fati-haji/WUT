function v = sinusoidal_vel(t)
    A = evalin('base', 'sinusoidal_amplitude');
    w = evalin('base', 'sinusoidal_frequency');
    v = w*A*cos(w*t);