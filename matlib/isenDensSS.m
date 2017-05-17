function [r0r] = isenDensSS(k, M)
% calculates density ratio of supersonic flow
% assumes isentropic flow
r0r = isenTempSS(k, M)^(1/(k-1));;
