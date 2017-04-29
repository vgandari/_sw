% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Function: DET_ROOTN nth-root of the determinant of an SPD matrix.
% Date: 18/06/2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function x = det_rootn( x )

if isa( x, 'scpexp' )
    x.expr  = strcat( 'det_rootn(', x.expr, ')' );
    x.vexpr = strcat( 'det_rootn(', x.vexpr, ')' );
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 by Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++