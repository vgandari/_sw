function xdot = eulerEOM(nu, x)
    I1 = 500;
    I2 = 125;
    I3 = 425;
    
    K1 = (I2 - I3)/I1;
    K2 = (I3 - I1)/I2;
    K3 = (I1 - I2)/I3;
    
    xdot(1) = 2*pi*K1*x(2)*x(3);
    xdot(2) = 2*pi*K2*x(3)*x(1);
    xdot(3) = 2*pi*K3*x(1)*x(2);
    xdot = xdot';
    return
end