% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Function: NORMS - Computation of multiple vector norm
% Date: 18/06/2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function x = norms( x, p, dim )

if isa( x, 'scpexp' )

    error( nargchk( 1, 3, nargin ) );

    if nargin < 2 || isempty( p ),
        p = 2;
    elseif ~isnumeric( p ) || numel( p ) ~= 1 || ~isreal( p ),
        error( '[SCP] The second argument must be a real number.' );
    elseif p < 1 || isnan( p ),
        error( '[SCP] The second argument must be between 1 and +Inf.' );
    end
    sp = mat2str( p );
    
    % Check the third argument
    if nargin < 3 || isempty( dim )
        sdim = strcat( 'cvx_default_dimension(size(', x.expr, '))' );
    else
        sdim = mat2str( dim );
    end
    
    x.expr  = strcat( 'norms(', x.expr,  ',', sp, ',', sdim,  ')' );
    x.vexpr = strcat( 'norms(', x.vexpr, ',', sp, ',', sdim,  ')' );
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 by Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++