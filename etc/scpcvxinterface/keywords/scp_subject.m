% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: scp_subject - perform the keyword "scp_subject".
% Date: 20-06-2009
% Created by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function scp_subject( varargin )

global scp_cvx___;

% check if not declare any variable.
if isempty( scp_cvx___.vstr.vlist )
   error( '[SCP] You have not declare any variables yet!' );
end

% this function only calls one time
if scp_cvx___.stkw == 1
    error( '[SCP] This keyword only call one time!' ); 
else
    scp_cvx___.stkw = 1; 
end

% check input.
if ~iscellstr( varargin ),
    error( '[SCP] SUBJECT TO must be used in the command mode.' );
elseif nargin ~= 1 || ~strcmpi( varargin{1}, 'to' ),
    error( 'Syntax: subject to' );
elseif isempty( scp_cvx___ ),
    error( '[SCP] SUBJECT TO can only be used within the SCP-CVX model.' );
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++