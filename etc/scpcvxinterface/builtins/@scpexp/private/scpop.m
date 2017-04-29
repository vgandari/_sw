% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% OPERATOR: scpop - Expression of the two inputs operator
% Date: 09-06-2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function z = scpop( x, y, ops )

% if x is an "scpexp" object.n
if isa( x, 'scpexp' )
    % if y is also a "scpexp" object.
    if isa( y, 'scpexp' )
        x.expr  = strcat( '(', x.expr,  ops, y.expr ,  ')' );
        x.vexpr = strcat( '(', x.vexpr, ops, y.vexpr , ')' );
    elseif isnumeric( y )
        yexpr = mat2str( y );
        x.expr  = strcat( '(', x.expr,  ops, yexpr , ')' ); 
        x.vexpr = strcat( '(', x.vexpr, ops, yexpr , ')' ); 
    end
    z = x; % assign x return variable z.
elseif isnumeric( x )
    xexpr = mat2str( x );
    if isa( y, 'scpexp' )
        y.expr  = strcat( '(', xexpr, ops, y.expr ,  ')' ); 
        y.vexpr = strcat( '(', xexpr, ops, y.vexpr , ')' ); 
        z = y;
    end
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 by Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++