% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: RDIVIDE -"RDIVIDE OPERATOR" using in "AUTOMATIC DIFFERENTATION"
% Date: 20-06-2009
% Created by: Quoc Tran Dinh, Phd student at ESAT/SCD and OPTEC,
% KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function x = rdivide( x, y )

if isa(x, 'scpvar')
    if isa(y, 'scpvar')
        x.diff = (1./y.val).* x.diff - ( x.val ./ y.val.^2 ).*y.diff;
        x.val  = x.val ./ y.val;
    elseif isnumeric( y )
        x.diff = 1./y.*x.diff;
        x.val  = x.val./y;
    else 
        error( 'Unknown type of the second variable' );
    end
elseif isnumeric( x )
    y.diff = -x./y.val.^2 .*y.diff;
    y.val  = x./y.val;
    x = y;
else
    error( 'Unknown type of the first variable' );
end
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

