% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Function: LOGSUMEXP_SDP - for "cvx" solver.
% Date: 18/06/2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function x = logsumexp_sdp( x, dim, tol )

error( nargchk( 1, 3, nargin ) );
if nargin < 2 || isempty( dim )
    dim = 1; 
end

if ~isnumeric( dim )
    error( '[SCP] The second variable is not numerical!' );
end

if nargin < 3 || isempty( tol )
    tol = 0.01; 
elseif ~isnumeric( tol ) | length( tol ) ~= 1 | ~isreal( tol ) | ...
        tol <= 0 | tol >= 1,
    error( '[SCP] "tol" must be a number between 0 and 1, exclusive.' );
end

if isa( x, 'scpexp' )
    sdim = strcat( ',', mat2str( dim ) );
    stol = strcat( ',', num2str( tol ) );
    x.expr  = strcat( 'logsumexp_spd(', x.expr,  sdim, stol , ')' );
    x.vexpr = strcat( 'logsumexp_spd(', x.vexpr, sdim, stol , ')' );
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 by Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++