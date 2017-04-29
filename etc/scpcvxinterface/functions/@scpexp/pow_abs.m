% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: POW_ABS - For "cvx" solver
% Date: 18/06/2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function x = pow_abs( x, p )

if isa( x, 'scpexp' ) 
    if isnumeric( p )
        sp = mat2str( p );
    else
        error( '[SCP] Unknown variable 2!' );
    end
    x.expr  = strcat( 'pow_abs(', x.expr,  ',', sp, ')' );
    x.vexpr = strcat( 'pow_abs(', x.vexpr, ',', sp, ')' );
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 by Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++