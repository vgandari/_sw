% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Function: NORM_LARGEST - Sum of the k largest magnitudes of a vector
% Date: 18/06/2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function x = norm_largest( x, k )

error( nargchk( 2, 2, nargin ) );
if isa( x, 'scpexp' ) 
    
    if isnumeric( k )
        sk = mat2str( k );
    else
        error( '[SCP] Unknown "k" input!' );
    end

    x.expr  = strcat( 'norm_largest(', x.expr,  ',', sk,  ')' );
    x.vexpr = strcat( 'norm_largest(', x.vexpr, ',', sk,  ')' );
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 by Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++