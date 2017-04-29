% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: POLYVAL - for "cvx" solver
% Date: 09-06-2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function x = polyval( p, x )

if isempty( p )
    sp = '[]';
else
    if isnumeric( p )
        sp = mat2str( p );
    else
        error( '[SCP] Unknown the second input!' );
    end
end

if isa( x, 'scpexp' )
    x.expr  = strcat( 'polyval(', sp, ',', x.expr,  ')' ); 
    x.vexpr = strcat( 'polyval(', sp, ',', x.vexpr, ')' ); 
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 by Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++