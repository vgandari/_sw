% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: PLUS - "PLUS OPERATOR" using in "AUTOMATIC DIFFERENTATION"
% Date: 20-06-2009
% Created by: Quoc Tran Dinh, Phd student at ESAT/SCD and OPTEC,
% KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function x = plus( x, y )

if isa(x, 'scpvar')
    if isa( y, 'scpvar' )
        x.val  = x.val  + y.val;
        x.diff = x.diff + y.diff;
    elseif isnumeric( y )
        x.val = x.val + y;
    else
        error( 'Unknown second variable y' );
    end
elseif isnumeric( x )
    y.val  = x + y.val;
    x = y;
else
    error( 'Unknown first variable!' );
end
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

