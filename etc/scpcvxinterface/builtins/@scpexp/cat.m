% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: CAT - Express the "cat" function
% Date: 09-06-2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function x = cat( dim, varargin )

% check dimension
if ~isnumeric( dim ) || any( size( dim ) ~= 1 ) || ...
   dim <= 0 || dim ~= floor( dim ),
    error( '[SCP] The first argument must be dimension.' );
end

% quick exit
if nargin == 2 && isa( varargin{1}, 'scpexp' )
    x = varargin{1};
    return
end

% otherwise
sdim = num2str( dim );
tmp = varargin{1};
isobj = false;
if isa( tmp, 'scpexp' )
    xexpr = tmp.expr; xvexpr = tmp.vexpr;
    isobj = true;
    x     = tmp;
elseif isnumeric( tmp )
    xexpr = mat2str( tmp ); xvexpr = xexpr;
else
    error( 'Unknown inputs!' );
end

for k=2:length( varargin )
    tmp = varargin{k};
    if isa( tmp, 'scpexp' )
        xexpr  = strcat( xexpr,  ',', tmp.expr ); 
        xvexpr = strcat( xvexpr, ',', tmp.vexpr );
        isobj  = true;
        x      = tmp;
    elseif isnumeric( tmp )
        tval   = mat2str( tmp );
        xexpr  = strcat( xexpr,  ',', tval );
        xvexpr = strcat( xvexpr, ',', tval );
    else
        error( 'Unknown inputs!' );
    end
end

if isobj
    x.expr  = strcat( 'cat(', sdim, ',', xexpr,  ')' );
    x.vexpr = strcat( 'cat(', sdim, ',', xvexpr, ')' );
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 by Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++