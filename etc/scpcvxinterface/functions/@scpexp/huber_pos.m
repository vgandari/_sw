% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Function: HUBER_POS - Monototic Huber - style function
% Date: 18/06/2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function x = huber_pos( x, M, t )

error( nargchk( 1, 3, nargin ) );

if isa( x, 'scpexp' )
    if nargin < 3 | isempty( t ), t = 1; end
    if nargin < 2 | isempty( M ), M = 1; end
    if isnumeric( t )
        st = mat2str( t ); 
    else
        error( '[SCP] Unknown "t" input!' );
    end
    if isnumeric( M )
        sM = mat2str( M ); 
    else
        error( '[SCP] Unknown "M" input!' );
    end
        
    x.expr  = strcat( 'huber_pos(', x.expr,  ',', sM, ',', st, ')' );
    x.vexpr = strcat( 'huber_pos(', x.vexpr, ',', sM, ',', st, ')' );
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 by Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++