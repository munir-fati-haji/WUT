function a = LSPB_acc(t)
    tf = evalin('base', 'tf');
    if t > tf
        a = 0;
    else
        tb = evalin('base', 'tb');
        if t >= tf-tb
            a = -evalin('base', 'aLSPB');
        elseif t >= tb
            a = 0;
        else
            a = evalin('base', 'aLSPB');
        end
    end