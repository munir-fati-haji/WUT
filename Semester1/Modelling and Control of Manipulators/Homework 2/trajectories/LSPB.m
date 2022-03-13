function q = LSPB(t)
    tf = evalin('base', 'tf');
    qf = evalin('base', 'qf');
    if t > tf
        q = qf;
    else
        tb = evalin('base', 'tb');
        q0 = evalin('base', 'q0');
        a = evalin('base', 'aLSPB');
        v = evalin('base', 'vLSPB');
        if t >= tf-tb
            q = qf-(a/2)*(t-(qf-q0)/v-v/a)^2;
        elseif t >= tb
            q = q0+(v^2)/(2*a)+v*(t-v/a);
        else
            q = q0+(a/2)*t^2;
        end
    end