% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: POLY_ENV - Convex or concave envelope of a polynomial
% Date: 18/06/2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function x = poly_env( p, x )

if isa( x, 'scpexp' ) 
    if isnumeric( p )
        sp = mat2str( p );
    else
        error( '[SCP] Unknown "k" input!' );
    end

    x.expr  = strcat( 'poly_env(', sp, ',', x.expr,  ')' );
    x.vexpr = strcat( 'poly_env(', sp, ',', x.vexpr, ')' );
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 by Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++