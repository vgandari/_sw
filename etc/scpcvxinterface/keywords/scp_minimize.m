% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Function: scp_minimize - perform the keyword "scp_minimize".
% Date: 20-06-2009
% Created by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function scp_minimize( varargin )

global scp_cvx___;

% check errors
if isempty( scp_cvx___ )
    error( '[SCP] This function only calls in the SCP-CVX mode!' );
end

if nargin < 1,
    error( '[SCP] Objective expression missing.' );
elseif iscellstr( varargin ),
    arg = evalin( 'caller', sprintf( '%s ', varargin{:} ) );
elseif nargin > 1,
    error( '[SCP] Too many input arguments.' );
else
    arg = varargin{1};
end

if ~isa( arg, 'scpexp' ) && ~isa( arg, 'double' ) && ~isa( arg, 'sparse' ),
    error( sprintf( '[SCP] Cannot accept an objective of type ''%s''.', ...
           class( arg ) ) );
end

% only have one objective function
fstr = scp_cvx___.fstr;
if ~isempty( fstr.obfun ) 
    error( '[SCP] Only accepted for one objective function!' );
else
    fstr.obfun = arg; 
    fstr.obdir = -1;
end
scp_cvx___.fstr = fstr;

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++