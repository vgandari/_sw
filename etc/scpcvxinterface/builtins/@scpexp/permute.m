% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: PERMUTE - for "cvx" solver
% Date: 09-06-2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function x = permute( x, order )

if nargin < 2
    sorder = '';
else
    if isnumeric( order )
        sorder = strcat( ',', mat2str( order ) );
    else
        error( '[SCP] Unknown input 2!' );
    end
end

if isa( x, 'scpexp' )
    x.expr  = strcat( 'permute(', x.expr,  sorder, ')' ); 
    x.vexpr = strcat( 'permute(', x.vexpr, sorder, ')' ); 
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 by Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++