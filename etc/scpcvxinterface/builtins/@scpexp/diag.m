% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: diag : expression of the "diag" function
% Date: 09-06-2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function x = diag( x, k )

if nargin == 1, 
    k = 0;
end
if isnumeric( k )
    sk = num2str( k );
else
    error( '[SCP] The second input must be an integer number!' );
end
    
if isa( x, 'scpexp' )
    x.expr  = strcat( 'diag(', x.expr,  ',', sk, ')' ); 
    x.vexpr = strcat( 'diag(', x.vexpr, ',', sk, ')' ); 
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 by Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++