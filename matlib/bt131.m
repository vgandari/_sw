function [p, n] = bt131(C)

    n = acos(C(1, 1));
    
    th1s = asin(C(3, 1)/sin(n));
    th1c = acos(C(2, 1)/sin(n));

    th2s = pi - th1s;
    th2c = 2*pi - th1c;

    if abs(th1s-th1c) < pi/180
        p = th1c;
    elseif abs(th1s-th2c) < pi/180
        p = th2c;
    elseif abs(th2s-th1c) < pi/180
        p = th1c;
    elseif abs(th2s-th2c) < pi/180
        p = th2c;
    else
        p = 0;
    end
end

