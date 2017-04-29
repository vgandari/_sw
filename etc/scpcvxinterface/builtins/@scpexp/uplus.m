% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% OPERATOR: uplus: Expression of the "+x" (+) operator
% Date: 09-06-2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function x = uplus( x )

if isa( x, 'scpexp' ) 
    x.expr  = strcat( 'uplus(', x.expr,  ')' );
    x.vexpr = strcat( 'uplus(', x.vexpr, ')' );
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 by Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++