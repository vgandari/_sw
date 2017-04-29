% -------------------------------------------------------------------------
% Function: ft_eqcon - This function compute value of equality constraints
%
% Created by: Quoc Tran Dinh, ESAT/SCD-OPTEC, KULeuven, Belgium
% Date: 22-06-2009
%
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% -------------------------------------------------------------------------
function val = ft_eqcon( x, u, n, x0, h, A1, A2, A3, A4, a1, a2, a3, a4, ...
               gamma1, gamma2, g, c11, c13, c15, c22, c24, c26, ...
               c33, c36, c44, c45 )

% Compute value.
xk = x0;
for k=1:n
    xk1 = x(4*k-3:4*k,1);
    uk  = u(2*k-1:2*k);
    val(4*k-3:4*k, 1) = -xk1 + xk + h*ft_dynsys( xk, uk, A1, A2, A3, A4, ...
                                    a1, a2, a3, a4, gamma1, gamma2, ...
                                    g, c11, c13, c15, c22, c24, c26, ...
                                    c33, c36, c44, c45 );
    xk = xk1;
end
% -------------------------------------------------------------------------
% End
% -------------------------------------------------------------------------