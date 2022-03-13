function q = sinusoidal(t)
    Amp = evalin('base', 'sinusoidal_amplitude');
    w = evalin('base', 'sinusoidal_frequency');
    q = Amp*sin(w*t);