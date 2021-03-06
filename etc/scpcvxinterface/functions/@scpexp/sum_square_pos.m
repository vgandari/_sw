% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: SUM_SQUARE_POS - sum of squares of positive parts
% Date: 18/06/2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function x = sum_square_pos( x, dim )

error( nargchk( 1, 2, nargin ) );

if nargin < 2 || isempty( dim )
    sdim = '';
else
    sdim = strcat( ',', mat2str( dim ) );
end

if isa( x, 'scpexp' )
    x.expr  = strcat( 'sum_square_pos(', x.expr,  sdim, ')' );
    x.vexpr = strcat( 'sum_square_pos(', x.vexpr, sdim, ')' );
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 by Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++