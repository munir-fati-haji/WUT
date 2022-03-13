function q = step(t)
    if t > evalin('base', 'step_threshold')
        q = evalin('base', 'qf');
    else
        q = evalin('base', 'q0');
    end