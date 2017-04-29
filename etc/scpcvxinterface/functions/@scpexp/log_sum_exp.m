% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Function: LOG_SUM_EXP - for "cvx" solver.
% Date: 18/06/2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function x = log_sum_exp( x, dim )

error( nargchk( 1, 2, nargin ) );
if nargin < 2 || isempty( dim )
    dim = 1; 
end

if ~isnumeric( dim )
    error( '[SCP] The second variable is not numerical!' );
end

if isa( x, 'scpexp' )
    x.expr  = strcat( 'log_sum_exp(', x.expr,  ',', mat2str(dim), ')' );
    x.vexpr = strcat( 'log_sum_exp(', x.vexpr, ',', mat2str(dim), ')' );
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 by Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++