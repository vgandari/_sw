% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: MTIMES -"MTIMES OPERATOR" using in "AUTOMATIC DIFFERENTATION"
% Date: 20-06-2009
% Created by: Quoc Tran Dinh, Phd student at ESAT/SCD and OPTEC,
% KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function x = mtimes( x, y )

if isa(x, 'scpvar')
    if isa(y, 'scpvar')
        x.diff = composite_rule( x.val , y.diff ) ...
               + composite_rule( y.val, x.diff );
        x.val  = x.val'* y.val;
    elseif isnumeric( y )
        x.val  = x.val'*y;
        x.diff = composite_rule( y, x.diff );
    else 
        error( 'Unknown type of the second variable' );
    end
elseif isnumeric( x )
    y.val  = x'*y.val;
    y.diff = composite_rule( x, y.diff );
    x = y;
else
    error( 'Unknown type of the first variable' );
end
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

