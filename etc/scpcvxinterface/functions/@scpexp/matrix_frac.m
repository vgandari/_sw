% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Function: MATRIX_FRAC - Matrix fractional function
% Date: 18/06/2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function z = matrix_frac( x, y )

error( nargchk( 2, 2, nargin ) );

if isa( x, 'scpexp' )
    xexpr  = x.expr;
    xvexpr = x.vexpr;
    z      = x;
elseif isnumeric( x )
    xexpr  = mat2str( x );
    xvexpr = xexpr;
else
    error( '[SCP] Unknown input 1!' );
end

if isa( y, 'scpexp' )
    yexpr  = y.expr;
    yvexpr = y.vexpr;
    z      = y;
elseif isnumeric( y )
    yexpr  = mat2str( y );
    yvexpr = yexpr;
else
    error( '[SCP] Unknown input 1!' );
end

if isa( x, 'scpexp' ) || isa( y, 'scpexp' )
    z.expr  = strcat( 'matrix_frac(', xexpr,  ',', yexpr,  ')' );
    z.vexpr = strcat( 'matrix_frac(', xvexpr, ',', yvexpr, ')' );
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 by Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++