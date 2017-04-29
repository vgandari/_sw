% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: wsoptget - This function get the work default optional fields
% Date: 20-06-2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function optfield = wsoptget( options, name )

% check inputs
if nargin < 2, error( 'At least two inputs are provided!' ); end

% get default option
defwsoptions = defwsopt();

% get defaults name.
optfield = defwsoptions.(name);
try optfield = options.( name );
catch ME, optfield = []; end
if isempty( optfield ), optfield = defwsoptions.(name); end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++