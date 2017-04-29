% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Function: scp_where - perform the command "scp_where".
% Date: 20-06-2009
% Created by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% References: CVX_WHERE - by Michael C. Grant and Stephen P. Boyd.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function output = scp_where

output = '-completenames';
output = eval( 'dbstack(output)', 'dbstack' );
output = output(1);
output = eval( 'output.file', 'output.name' );
if ispc, fstr = '\'; else fstr = '/'; end
temp = strfind( output, fstr );
output( temp(end-1) + 1 : end ) = [];

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 by Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++