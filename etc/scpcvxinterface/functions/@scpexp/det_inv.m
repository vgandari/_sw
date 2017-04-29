% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Function: DET_INV determinant of the inverse of an SPD matrix.
% Date: 18/06/2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function x = det_inv( x, p )

error( nargchk( 1, 2, nargin ) );
if isa( x, 'scpexp' )

    if nargin < 2, p = 1; end
    if ~isnumeric( p ) | ~isreal( p ) | numel( p ) ~=  1 | p <= 0,
        error( 'The second argument must be a positive scalar.' );
    end;

    x.expr  = ['det_inv(', x.expr,  ',', mat2str(p), ')'];
    x.vexpr = ['det_inv(', x.vexpr, ',', mat2str(p), ')'];
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 by Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++