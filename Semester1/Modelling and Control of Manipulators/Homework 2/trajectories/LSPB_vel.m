function v = LSPB_vel(t)
    tf = evalin('base', 'tf');
    if t > tf
        v = evalin('base', 'vf');
    else
        tb = evalin('base', 'tb');
        if t >= tf-tb
            a = evalin('base', 'aLSPB');
            v = evalin('base', 'vLSPB')-a*(t-tf+tb);
        elseif t >= tb
            v = evalin('base', 'vLSPB');
        else
            a = evalin('base', 'aLSPB');
            v = a*t;
        end
    end