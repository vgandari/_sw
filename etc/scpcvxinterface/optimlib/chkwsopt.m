% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: chkwsopt - check the workspace options.
% Date: 18/06/2009
% Create by: Quoc Tran Dinh - ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function wspars = chkwsopt( wspars )
    
    % get default workspace option and its name.
    default = defwsopt;
    namelist = optionfields;

    % check all the fields.
    for k=1:length( namelist )
        wspars = checkfield( wspars, default, namelist{k} );
    end
   
% end of the function.
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Function: checkfield 
% this function checks the field of optional parameters.
function wspars = checkfield( wspars, default, fieldname )
    
    fieldvalue = getfield( default, fieldname );
    if isfield( wspars, fieldname )
        optfieldval = getfield( wspars, fieldname );
        if isempty( optfieldval )
            wspars = setfield( wspars, fieldname, fieldvalue );
        end;
    else
        wspars = setfield( wspars, fieldname, fieldvalue );
    end;
    
% end of this function
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++