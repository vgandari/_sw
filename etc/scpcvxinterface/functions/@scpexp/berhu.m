% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Function: berhu - call from "cvx" solver.
% Date: 18/06/2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function x = berhu( x, M, t )

error( nargchk( 1, 3, nargin ) );
if isa( x, 'scpexp')
    if nargin < 2,
        M = 1;
    elseif ~isreal( M ) | any( M( : ) <= 0 ),
        error( 'The second argument must be real and positive.' );
    end
    if nargin < 3,
        t = 1;
    elseif ~isreal( t ),
        error( 'The third argument must be real.' );
    end

    x.expr  = strcat( 'berhu(', x.expr,  ',', mat2str(M), ',' , ...
                     num2str(t), ')' );
	x.vexpr = strcat( 'berhu(', x.vexpr, ',', mat2str(M), ',' , ...
                     num2str(t), ')' );
end
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 by Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++