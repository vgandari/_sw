% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: prod - Expression of the "prod" function
% Date: 09-06-2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function x = prod( x, dim )

% if there is only one input.
if nargin < 2, dim = 1; end

% check dim variable.
if ~isnumeric( dim ), error('[SCP]The second input must be a number!'); end

% x is a scpexp object.
if isa( x, 'scpexp' )
    if nargin > 1, 
        xdim = inputname(2);
        if isempty( xdim ) 
            if isnumeric( dim ),  xdim = mat2str( dim ); end
        end;
        x.expr  = strcat( 'prod(', x.expr, ',',  xdim, ')' );
        x.vexpr = strcat( 'prod(', x.vexpr, ',', xdim, ')' );
    else
        x.expr  = strcat( 'prod(', x.expr,  ')' );
        x.vexpr = strcat( 'prod(', x.vexpr, ')' );
    end
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 by Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++