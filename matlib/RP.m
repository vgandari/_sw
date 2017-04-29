function [p02p2 p02p1] = RP(k, M1, M2)
% Rayleigh-Pitot?
    p02p2 = (((k + 1)^2*M1^2)/(4*k*M1^2 - 2*(k - 1)))^(k/(k - 1))*((1 - k + 2*k*M1^2)/(k + 1));
    p02p1 = ((1 + (k - 1)/2*M2^2)^(k/(k - 1)))/((1 + (k - 1)/2*M1^2)^(k/(k - 1)));
    
end