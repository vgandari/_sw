% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: sum - expression of the "sum" function
% Date: 10-06-2009
% Created by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function x = sum( x, dim, mode )

if isa( x, 'scpexp' )
    if nargin < 3,       mode = []; smode = ''; end
    if nargin < 2,       dim  = []; sdim  = ''; end
    if isempty( mode ),  mode = []; smode = ''; end
    if isempty( dim ),   dim  = []; sdim  = ''; end
    
    if ~isempty( dim ) && isnumeric( dim )
        sdim = strcat( ',', num2str( dim ) );
    else
        sdim = ''; 
    end

    if ~isempty( mode ) && ischar( mode ) && ...
       (strcmp( 'double', mode ) || strcmp( 'native', mode )) 
        smode = strcat( ',', char(39), mode, char(39) );
    else
        smode = ''; 
    end
    
    x.expr  = strcat('sum(', x.expr, sdim, smode, ')');
    x.vexpr = strcat('sum(', x.vexpr, sdim, smode, ')');
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 by Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++