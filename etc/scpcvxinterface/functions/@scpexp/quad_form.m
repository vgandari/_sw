% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: QUAD_FORM - For "cvx" solver
% Date: 18/06/2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function x = quad_form( x, Q, tol )

error( nargchk( 2, 3, nargin ) );

if nargin < 3, 
    tol = 4 * eps; 
end

if isa( x, 'scpexp' ) 
    if isnumeric( Q )
        sQ = mat2str( Q );
    else
        error( '[SCP] Unknown variable 2!' );
    end
    stol = num2str( tol );
    
    x.expr  = strcat( 'quad_form(', x.expr,  ',', sQ, ',', stol, ')' );
    x.vexpr = strcat( 'quad_form(', x.vexpr, ',', sQ, ',', stol, ')' );
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 by Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++