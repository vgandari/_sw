% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Function: SUM_LARGEST - for "cvx" solver
% Date: 18/06/2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function x = sum_largest( x, k, dim )

error( nargchk( 2, 3, nargin ) );
if nargin < 3 || isempty( dim )
    sdim = '';
elseif isnumeric( dim )
    sdim = strcat( ',', mat2str( dim ) );
else
    error( '[SCP] Unknown variable 3!' );
end

if isnumeric( k )
    sk = strcat( ',', num2str( k ) );
else
	error( '[SCP] Unknown variable 2!' );
end

if isa( x, 'scpexp' )
    x.expr  = strcat( 'sum_largest(', x.expr,  sk, sdim, ')' );
    x.vexpr = strcat( 'sum_largest(', x.vexpr, sk, sdim, ')' );
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 by Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++