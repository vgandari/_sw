% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Function: NORMS_LARGEST - Sum of the k largest magnitudes of a vector
% Date: 18/06/2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function x = norms_largest( x, k, dim )

error( nargchk( 2, 3, nargin ) );
if isa( x, 'scpexp' ) 
    
    if isnumeric( k )
        sk = mat2str( k );
    else
        error( '[SCP] Unknown "k" input!' );
    end

    if nargin < 3 || isempty( dim )
        sdim = '';
    else 
        sdim = strcat( ',', mat2( dim ) );
    end
    
    x.expr  = strcat( 'norms_largest(', x.expr,  ',', sk, sdim, ')' );
    x.vexpr = strcat( 'norms_largest(', x.vexpr, ',', sk, sdim, ')' );
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 by Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++