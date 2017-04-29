% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: size: Expression of the "size" function
% Date: 09-06-2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function x = size( x, dim )

if isa( x, 'scpexp' )
    sdim = '';
    if nargin > 1 && isreal( dim )
        sdim = strcat( ',', num2str( dim ) ); 
    end
    x.expr  = strcat( 'size(', x.expr ,  sdim, ')' );
    x.vexpr = strcat( 'size(', x.vexpr , sdim, ')' );
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 y Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++