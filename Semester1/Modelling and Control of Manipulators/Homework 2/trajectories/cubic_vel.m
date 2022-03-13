function v = cubic_vel(t)
    if t <= evalin('base', 'tf')
        a = evalin('base', 'a');
        v = [0 1 2*t 3*t^2]*a;
    else
        v = evalin('base', 'vf');
    end