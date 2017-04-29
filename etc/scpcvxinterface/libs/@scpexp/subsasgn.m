% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% OPERATOR: subsasgn: Express the "subsasgn" operator for "scpexp" class.
% Date: 09-06-2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function x = subsasgn( x, S, y )

indstr = mat2str( S.subs{1} );
for k=2:length( S.subs )
    indstr = strcat( indstr, ',', mat2str(S.subs{k}) );
end

% if "x" is an "scpexp" object
if isa( x, 'scpexp' )
    
    if isa( y, 'scpexp' )
        yexpr  = y.expr;
        yvexpr = y.vexpr;
    elseif isnumeric( y )
        yexpr  = mat2str( y );
        yvexpr = yexpr;
    else 
        error( '[SCP] Unknown input!' );
    end
    
    x.expr = strcat( 'subsasgn(', x.expr, ', substruct(', ...
        char(39), '()', char(39), ', {', indstr, '} ),', yexpr, ' )' );
    
    x.vexpr = strcat( 'subsasgn(', x.vexpr, ', substruct(', ...
        char(39), '()', char(39), ', {', indstr, '} ),', yvexpr ,')' );
end

if isa( y, 'scpexp' )
    
    if isa( x, 'scpexp' )
        xexpr  = x.expr;
        xvexpr = x.vexpr;
    elseif isnumeric( x )
        xexpr  = mat2str( x );
        xvexpr = xexpr;
	else 
        error( '[SCP] Unknown input!' );
    end
    
    y.expr = strcat( 'subsasgn(', xexpr, ', substruct(', ...
        char(39), '()', char(39), ', {', indstr, '} ),', y.expr, ' )' );
    
    y.vexpr = strcat( 'subsasgn(', xvexpr, ', substruct(', ...
        char(39), '()', char(39), ', {', indstr, '} ),', y.vexpr ,')' );
    x = y;
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++