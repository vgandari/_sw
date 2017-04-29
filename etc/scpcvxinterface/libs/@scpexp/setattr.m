%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: setattr - Set the attributes to the "scpexp" object.
% Date: 09-06-2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function x = setattr( x, attr, value )

if nargin < 3
    error( '[SCP] This function requires at least 3 inputs!' ); 
end

if isa( x, 'scpexp' )
    switch( attr )
        case 'name', 
            if ischar( value)
                x.name = value;
            else
                error( '[SCP] Name must be a string!'); 
            end
            
        case 'expr', 
            if ischar( value )
                x.expr = value;
            else
                error( '[SCP] Expression must be a string!'); 
            end
            
        case 'value', 
            if isnumeric( value) 
                x.value = value;
            else
                error( '[SCP] Name must be numerical!'); 
            end
            
        case 'size', 
            if isnumeric( value)
                x.size = value;
            else
                error( '[SCP] Size must be numerical!'); 
            end
            
        case 'type',
            if ischar( value)
                x.type = value;
            else
                error( '[SCP] Type must be a string!');
            end
            
        case 'isvar',
            if ischar( value)
                x.isvar = value;
            else
                error( '[SCP] IsVar must be logical!'); 
            end
            
        case 'vexpr',
            if ischar( value)
                x.vexpr = value;
            else
                error( '[SCP] VarExpr must be a string!'); 
            end
    end
end

%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%  Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
%  See the file COPYING.txt for full copyright information.
%  The command 'scp_where' will show where this file is located.
%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++