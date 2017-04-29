% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: min: Expression of the "min" function
% Date: 09-06-2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function x = min( varargin )

if nargin == 1
    if isa( varargin{1}, 'scpexp' )
        x = varargin{1};
        x.expr  = strcat( 'min(', x.expr,  ')' );
        x.vexpr = strcat( 'min(', x.vexpr, ')' );
    end
elseif nargin == 2
    tmp1 = varargin{1}; tmp2 = varargin{2};
    if isa( tmp1, 'scpexp' )
        x = tmp1;
        s1expr = tmp1.expr; s1vexpr = tmp1.vexpr;
    elseif isreal( tmp1 ) 
        s1expr = mat2str( tmp1 ); s1vexpr = s1expr;
    end
    if isa( tmp2, 'scpexp')
        x = tmp2;
        s2expr = tmp2.expr; s2vexpr = tmp2.vexpr;
    elseif isreal( tmp2 ) 
        s2expr = mat2str( tmp2 ); s2vexpr = s2expr;
    end
    if isa( tmp1, 'scpexp' ) || isa( tmp2, 'scpexp' ) 
        x.expr  = strcat( 'min(', s1expr,  ',', s2expr,  ')' );
        x.vexpr = strcat( 'min(', s1vexpr, ',', s2vexpr, ')' );
    end
else
    if nargin == 3 && isa( varargin{1}, 'scpexp' ) ...
       && isempty( varargin(2) ) && isreal( varargin{3} )
        x = varargin{1};
        x.expr  = strcat( 'min(', x.expr,  ',[],', num2str(varargin{3}), ')' );
        x.vexpr = strcat( 'min(', x.vexpr, ',[],', num2str(varargin{3}), ')' );
    else
        isobject = false;
        tmp = varargin{1};
        if isa( tmp, 'scpexp' )
            x        = tmp;
            xexpr    = x.expr; 
            xvexpr   = x.vexpr;
            isobject = true; 
        elseif isreal( tmp )
            xexpr   = mat2str( tmp );
            xvexpr = xexpr;
        end

        for k=2:length( varargin )
            tmp = varargin{k};
            if isa( tmp, 'scpexp' )
                isobject = true;
                x        = tmp;
                xexpr  = strcat( xexpr,  ',', tmp.expr );
                xvexpr = strcat( xvexpr, ',', tmp.vexpr );
            elseif isreal( tmp )
                tmpval = mat2str( tmp );
                xexpr  = strcat( xexpr,  ',', tmpval );
                xvexpr = strcat( xvexpr, ',', tmpval );
            end
        end
        if isobject
            x.expr  = strcat( 'min(', xexpr,  ')');
            x.vexpr = strcat( 'min(', xvexpr, ')');
        end
    end
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 by Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++