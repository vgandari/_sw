function [lambda, theta] = SRT_q2lam(q)
    lambda = q(1:3)/norm(q(1:3));
    theta = acos(q(4));
end