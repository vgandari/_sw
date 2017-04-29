% #######################################################################
% Function: [ ... ] = hc_eqcon( ... )
% This function is equality constraints.
%
% Created by: Quoc Tran Dinh, ESAT/SCD-OPTEC, KULeuven, Belgium
% Date: 22-06-2009
%
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% #######################################################################
function fval = hc_eqcon( x4, x5, u1, u2, n,  x0, h, M, I, r )

% Compute the coefficient constants 
A = h/M;
B = h*r/I;

% The iterative loop to compute the functional components.
x3 = x0(3);
x6 = x0(6);

for k=1:n
    
    % compute x4(k) and x5(k).
    if( k == 1 )
        fval(2*k-1, 1) = x0(4) - x4(k) + A*( u1(k) + u2(k))*cos( x3 );
        fval(2*k, 1)   = x0(5) - x5(k) + A*( u1(k) + u2(k))*sin( x3 );
    else
        fval(2*k-1, 1) = x4(k-1) - x4(k) + A*( u1(k) + u2(k) )*cos( x3 );
        fval(2*k, 1)   = x5(k-1) - x5(k) + A*( u1(k) + u2(k) )*sin( x3 );
    end;
    
    % compute x3(k) and x6(k).
    x3 = x3 + h*x6;
    x6 = x6 + B*( u1(k) - u2(k) );
    
end

% #######################################################################
% End of the function.
% #######################################################################