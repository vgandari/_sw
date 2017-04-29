% -------------------------------------------------------------------------
% Function: ft_dfxu - This function comput Dfx and Dfu of function f(x, u).
%
% Created by: Quoc Tran Dinh, ESAT/SCD-OPTEC, KULeuven, Belgium
% Date: 22-06-2009
%
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% -------------------------------------------------------------------------
function [ Dfx, Dfu ] = ft_dfxu( x, u, A1, A2, A3, A4, a1, a2, ...
                        a3, a4, g, gamma1, gamma2, k1, k2 )

% Compute some components
T1 = A1*sqrt(2*x(1)/g)/a1;
T2 = A2*sqrt(2*x(2)/g)/a2;
T3 = A3*sqrt(2*x(3)/g)/a3;
T4 = A4*sqrt(2*x(4)/g)/a4;

% Compute Dfx.
Dfx = [ -1/T1, 0, A3/(A1*T3), 0; ...
        0, -1/T2, 0, A4/(A2*T4); ...
        0, 0, -1/T3, 0; ...
        0, 0, 0, -1/T4 ];
    
% Compute Dfu.
Dfu = [ gamma1*k1/A1, 0; 0, gamma2*k2/A2; ...
        0, (1-gamma2)*k2/A3; (1-gamma1)*k1/A4, 0 ];

% -------------------------------------------------------------------------
% End
% -------------------------------------------------------------------------