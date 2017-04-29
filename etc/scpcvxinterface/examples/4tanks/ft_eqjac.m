% -------------------------------------------------------------------------
% Function: ft_eqjac - This function compute Jacobian matrix of 
%           equality constraints
%
% Created by: Quoc Tran Dinh, ESAT/SCD-OPTEC, KULeuven, Belgium
% Date: 22-06-2009
%
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% -------------------------------------------------------------------------
function javal = ft_eqjac( x, u, n, x0, h, A1, A2, A3, A4, a1, a2, a3, a4, ...
                        g, gamma1, gamma2, k1, k2 )

% Size of variable x and u.
nx = 4*n; nu = 2*n; nw = 6*n;
xk = x0; E4 = eye(4); 
javal = zeros( 4*n, nw );

% Compute Jacobian.
for k = 1:n
    uk = u(2*k-1:2*k,1);
    
    [Dfxk, Dfuk] = ft_dfxu( xk, uk, A1, A2, A3, A4, a1, a2, a3, a4, g, ...
                         gamma1, gamma2, k1, k2  ); 
                     
    javal(4*k-3:4*k, nx+2*k-1:nx+2*k) = h*Dfuk;
    
    if k == 1
       javal(4*k-3:4*k, 1:4) = -E4;
    else
       javal(4*k-3:4*k, 4*k-3:4*k) = -E4; 
       javal(4*k-3:4*k, 4*k-7:4*k-4) = E4 + h*Dfxk;
    end

    xk = x(4*k-3:4*k,1);
end
% -------------------------------------------------------------------------
% End
% -------------------------------------------------------------------------