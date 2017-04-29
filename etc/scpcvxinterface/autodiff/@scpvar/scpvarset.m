% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: scpvarset - set attributes to "scpvar" class
% Date: 20-06-2009
% Created by: Quoc Tran Dinh, PhD student at ESAT/SCD and OPTEC, 
% KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function x = scpvarset( x, opt, val )

if isa( x, 'scpvar' )
    switch( opt )
        case 'val',  
            if isnumeric( val ), x.val  = val; x.size = size( val ); end
        case 'size', 
            if isnumeric( val ), x.size = val; end
        case 'diff', 
            if isnumeric( val ), x.diff = val; end
    end
end
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

