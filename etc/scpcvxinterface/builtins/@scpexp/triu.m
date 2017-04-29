% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: TRIU - for "cvx" solver
% Date: 09-06-2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function x = triu( x, k )

if nargin < 2
    striuk = '';
else
    if isnumeric( k )
        striuk = strcat( ',', num2str( k ) );
    else
        error( '[SCP] Unknown input 2!' );
    end
end

if isa( x, 'scpexp' )
    x.expr  = strcat( 'triu(', x.expr,  striuk, ')' ); 
    x.vexpr = strcat( 'triu(', x.vexpr, striuk, ')' ); 
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 by Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++