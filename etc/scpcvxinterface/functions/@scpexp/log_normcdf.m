% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Function: LOG_NORMCDF - Logarithm of the norm CDF (approximation)
% Date: 18/06/2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function x = log_normcdf( x )

if isa( x, 'scpexp' )
    x.expr  = strcat( 'log_normcdf(', x.expr,  ')' );
    x.vexpr = strcat( 'log_normcdf(', x.vexpr, ')' );
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 by Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++