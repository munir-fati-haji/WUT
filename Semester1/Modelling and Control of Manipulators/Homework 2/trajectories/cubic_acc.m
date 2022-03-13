function a = cubic_acc(t)
    if t <= evalin('base', 'tf')
        a = evalin('base', 'a');
        a = [0 0 2 6*t]*a;
    else
        a = 0;
    end