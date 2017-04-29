% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: blkdiag : expression of the "blkdiag" function
% Date: 09-06-2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function z = blkdiag( varargin )

if nargin < 1
    error( '[SCP] At least one variable is provided!' );
end

tmp = varargin{1};
isvar = 0;
if isa( tmp, 'scpexp' )
    isvar = 1;
    z = tmp;
    xexpr  = tmp.expr;
    xvexpr = tmp.vexpr;
elseif isnumeric( tmp )
    xexpr  = mat2str( tmp );
    xvexpr = xexpr;
else
    error( '[SCP] Unknown inputs!' );
end

for k=2:length( varargin )
    tmp = varargin{k};
    if isa( tmp, 'scpexp' )
        isvar = 1;
        z = tmp;
        xexpr  = strcat( xexpr,  ',', tmp.expr );
        xvexpr = strcat( xvexpr, ',', tmp.vexpr );
    elseif isnumeric( tmp )
        tmpval = mat2str( tmp );
        xexpr  = strcat( xexpr,  ',', tmpval );
        xvexpr = strcat( xvexpr, ',', tmpval );
    else
        error( '[SCP] Unknown inputs!' );
    end
end

if isvar 
    z.expr  = strcat( 'blkdiag(', xexpr,  ')' );
    z.vexpr = strcat( 'blkdiag(', xvexpr, ')' );
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 by Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++