% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: norm: Expression of the "norm" function.
% Date: 09-06-2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function x = norm( x, p )

% default norm is 2-norm.
if( nargin < 2) || isempty( p )
    p = 2; 
end

if isa( x, 'scpexp' )
    % if p is a number.
    if isnumeric( p )
        switch( p )
            case 1, 
                xexpr  = strcat( 'norm(', x.expr,  ', 1)' );
                xvexpr = strcat( 'norm(', x.vexpr, ', 1)' );
            case Inf, 
                xexpr  = strcat( 'norm(', x.expr,  ',Inf)' );
                xvexpr = strcat( 'norm(', x.vexpr, ',Inf)' );
            otherwise, 
                xexpr  = strcat( 'norm(', x.expr,  ',', num2str(p) ,')' );
                xvexpr = strcat( 'norm(', x.vexpr, ',', num2str(p) ,')' );
        end
    % if p is a string: 'inf', 'Inf' or 'fro', etc
    elseif ischar( p )
        switch( p )
            case {'inf', 'Inf', 'infinity', 'Infinity' }, 
            	xexpr  = strcat( 'norm(', x.expr,  ', Inf)' );
                xvexpr = strcat( 'norm(', x.vexpr, ', Inf)' );
            case {'fro', 'Fro', 'Frobenius', 'frobenius' }, 
                xexpr  = strcat( 'norm(', x.expr, ', ', ...
                                 char(39), 'fro', char(39), ')' );
                xvexpr = strcat( 'norm(', x.vexpr, ', ', ...
                                 char(39), 'fro', char(39), ')' );
            otherwise
                error( '[SCP] The second input must be "inf" or "fro"!' ); 
        end
    else
        error( '[SCP] The second input must be a number or a string!' ); 
    end
    
    % get expression
    x.expr  = xexpr; 
    x.vexpr = xvexpr;
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 by Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++