%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: getdattr - get attributes of the "scpdual" object. 
% Date: 09-06-2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function attr = getdattr( x, atk )

if nargin == 1
    atk = 'name'; %default - get name
end  

if isa( x, 'scpdual' )
    switch( atk )
        case 'name',    
            attr = x.name; 
        case 'value',   
            attr = x.value;
        case 'size',    
            attr = x.size;
        case 'type',    
            attr = x.type;
        case 'expr',    
            attr = x.expr;
        case 'isdual',  
            attr = x.isdual;
        case 'dexpr',   
            attr = x.dexpr;
        otherwise,      
            attr = [];
    end
else
    warning( '[SCP] This attribute does not belong to "scpdual" object! ' );
    attr = []; 
end
    
%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%  Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
%  See the file COPYING.txt for full copyright information.
%  The command 'scp_where' will show where this file is located.
%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++