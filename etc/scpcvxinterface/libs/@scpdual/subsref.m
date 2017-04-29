% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% OPERATOR: subsref: Expression of the "subsref" operator for class
%  "scpdual"
% Date: 09-06-2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function x = subsref( x, S ) % variable and its index subscript

% if "x" is an "scpdual" object.
if isa( x, 'scpdual' )
    
    indstr = mat2str( S.subs{1} );
    
    for k=2:length( S.subs )
        indstr = strcat( indstr, ',', mat2str(S.subs{k}) );
    end
    
    x.expr = strcat( 'subsref(', x.expr, ', substruct(', ...
        char(39), S.type, char(39), ', {', indstr, '} ) )' );
    
    x.dexpr = strcat( 'subsref(', x.dexpr, ', substruct(', ...
        char(39), S.type, char(39), ', {', indstr, '} ) )' );
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++