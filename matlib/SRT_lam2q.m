function q = SRT_lam2q(lambda, theta)
    q = [lambda(1)*sin(theta/2);
        lambda(2)*sin(theta/2);
        lambda(3)*sin(theta/2);
        cos(theta/2)];
end