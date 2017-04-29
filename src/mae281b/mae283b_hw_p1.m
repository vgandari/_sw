function xdot = mae283b_hw_p1(t, x)
% global theta = [60 0.5 40 6 4e4];
global theta
u = 0;
xdot(1) = -theta(1)*x(1) - theta(2) * x(2) * u + theta(3);
xdot(2) = theta(4) * x(2) + theta(5) * x(1) * u;
xdot = xdot';
end