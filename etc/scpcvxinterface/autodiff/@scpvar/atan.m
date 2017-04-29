% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: ATAN - "ARCTAN" function using in "AUTOMATIC DIFFERENTATION"
% Date: 20-06-2009
% Created by: Quoc Tran Dinh, Phd student at ESAT/SCD and OPTEC,
% KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function x = atan( x )

if isa( x, 'scpvar' )
    x.diff = composite_rule( 1./( 1 + x.val.*x.val ), x.diff ); 
    x.val  = atan( x.val );
end
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

