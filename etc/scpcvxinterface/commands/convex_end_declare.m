% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: convex_end_declare - perform the command "convex_end_declare".
% Date: 20-06-2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function convex_end_declare

global scp_cvx___;
if scp_cvx___.stkw == 3
    error( '[SCP] This keword is already called!' );
elseif scp_cvx___.stkw ~= 2
    error( '[SCP] The keword "convex_begin_declare" must be called!' );
else
    scp_cvx___.stkw = 3;
end

% clear dual variables.
scp_cloput( 'dual' );

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 by Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++