function q = cubic(t)
    if t <= evalin('base', 'tf')
        a = evalin('base', 'a');
        q = [1 t t^2 t^3]*a;
    else
        q = evalin('base', 'qf');
    end