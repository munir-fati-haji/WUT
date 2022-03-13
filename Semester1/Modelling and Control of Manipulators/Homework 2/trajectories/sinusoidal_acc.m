function a = sinusoidal_acc(t)
    A = evalin('base', 'sinusoidal_amplitude');
    w = evalin('base', 'sinusoidal_frequency');
    a = -(w)^2*A*sin(w*t);