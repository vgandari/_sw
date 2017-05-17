function [p0p] = isenPressSS(k, M)
% calculates pressure ratio of supersonic flow
% assumes isentropic flow
p0p = isenDensSS(k, M)^k;
