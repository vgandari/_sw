% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: TAN - "TAN" function using in "AUTOMATIC DIFFERENTATION"
% Date: 20-06-2009
% Created by: Quoc Tran Dinh, Phd student at ESAT/SCD and OPTEC,
% KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function x = tan( x )

if isa( x, 'scpvar' )
    x.diff = composite_rule( 1 ./ cos( x.val ).^2 , x.diff ); 
    x.val  = tan( x.val );
end
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

