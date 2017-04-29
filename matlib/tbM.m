function theta = tbM(M1, beta, k)
    theta = atan(2/tan(beta)*(M1^2*sin(beta^2) - 1)/(M1^2*(k + cos(2*beta)) + 2));
end