function [T0T] = isenTempSS(k, M)
% calculates temperature ratio of supersonic flow
% assumes isentropic flow
T0T = 1 + (k-1)/2*M^2;
