% ------------------------------------------------------------------------
% Function: ft_eqpoint - Compute the equilibrium point of dynamic system:
%                   x' = f(x, u)
% that means f(x, u ) = 0, so, if for given uref, solve a system 
% of equations f(x, uref) = 0.
%
% Created by: Quoc Tran Dinh, ESAT/SCD-OPTEC, KULeuven, Belgium
% Date: 22-06-2009
%
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ------------------------------------------------------------------------
function xref = ft_eqpoint( uref, c11, c13, c15, c22, c24, c26, ...
                             c33, c36, c44, c45 )

% Compute the 
A = [ c11, 0, c13, 0; 0, c22, 0, c24; 0, 0, c33, 0; 0, 0, 0, c44 ];
b = -[ c15*uref(1,1); c26*uref(2,1); c36*uref(2,1); c45*uref(1,1) ];

xref = inv(A)*b;
xref = xref.*xref;
% ------------------------------------------------------------------------
% End
% ------------------------------------------------------------------------