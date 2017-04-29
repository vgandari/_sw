% ------------------------------------------------------------------------
% Function: ft_dynsys - This function computes value of f(x, u) 
% from the dynamic system:
%                 x' = f(x, u)
%
% Created by: Quoc Tran Dinh, ESAT/SCD-OPTEC, KULeuven, Belgium
% Date: 22-06-2009
%
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ------------------------------------------------------------------------
function val = ft_dynsys( x, u, A1, A2, A3, A4, a1, a2, a3, a4, gamma1, ...
               gamma2, g, c11, c13, c15, c22, c24, c26, c33, c36, ...
               c44, c45 )

% Compute
val(1,1) = c11*sqrt( x(1) ) + c13*sqrt( x(3) ) + c15*u(1);
val(2,1) = c22*sqrt( x(2) ) + c24*sqrt( x(4) ) + c26*u(2);
val(3,1) = c33*sqrt( x(3) ) + c36*u(2);
val(4,1) = c44*sqrt( x(4) ) + c45*u(1);

% ------------------------------------------------------------------------
% End.
% ------------------------------------------------------------------------