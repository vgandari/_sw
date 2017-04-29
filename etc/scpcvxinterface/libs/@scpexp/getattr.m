%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: getattr - get attribute of the "scpexp" object.
% Date: 09-06-2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function attr = getattr( x, atk )

if nargin == 1, 
    atk = 'name';  % default - get name
end

if isa( x, 'scpexp' )
    switch( atk )
        case 'name'
            attr = x.name; 
        case 'value'
            attr = x.value;
        case 'size'
            attr = x.size;
        case 'expr'
            attr = x.expr;
        case 'type'
            attr = x.type;
        case 'isvar'
            attr = x.isvar;
        case 'vexpr'
            attr = x.vexpr;
        otherwise
            attr = [];
    end
else
    warning( '[SCP] This attribute does not belong to "scpexp" object! ' );
    attr = [];
end
    
%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%  Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
%  See the file COPYING.txt for full copyright information.
%  The command 'scp_where' will show where this file is located.
%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++