% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: QUAD_OVER_LIN - For "cvx" solver
% Date: 18/06/2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function z = quad_over_lin( x, y, dim )

error( nargchk( 2, 3, nargin ) );

if nargin < 3 || isempty( dim ); 
    sdim = '';
else 
    sdim = strcat( ',', mat2str( dim ) );
end

if isa( x, 'scpexp' ) 
    xexpr  = x.expr; 
    xvexpr = x.vexpr;
    z      = x;
elseif isnumeric( x )
    xexpr  = mat2str( x );
    xvexpr = xexpr;
end

if isa( y, 'scpexp' ) 
    yexpr  = y.expr;
    yvexpr = y.vexpr;
    z      = y;
elseif isnumeric( y )
    yexpr  = mat2str( y );
    yvexpr = yexpr;
end

if isa( x, 'scpexp' ) || isa( y, 'scpexp' )
    z.expr  = strcat( 'quad_over_lin(', xexpr,  ',', yexpr,  sdim, ')' );
    z.vexpr = strcat( 'quad_over_lin(', xvexpr, ',', yvexpr, sdim, ')' );
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 by Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++