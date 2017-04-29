% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: scp_end - perform the command "scp_end".
% Date: 20-06-2009
% Created by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function scp_end

global scp_cvx___;

% check the validation
if isempty( scp_cvx___ ) 
    disp( '[SCP] No problem is defined! Exit ... ' );
    return;
elseif isfield( scp_cvx___, 'vstr' ) && isempty( scp_cvx___.vstr )
    disp( '[SCP] No problem is defined! Exit ... ' );
    return;
end

if isfield( scp_cvx___.vstr, 'vlist' ) && isempty( scp_cvx___.vstr.vlist )
    disp( '[SCP] No variable is declared! Exit ... ' );
    return;
end

% check call the command and keyword completely.
if scp_cvx___.stkw == 2
    error( '[SCP] - "convex_end_declare" must be called!' );
end

% call the solver.
[ xsol, fsol, dsol, exitflag, pinfo, dinfo, xoutexp, doutexp ] ...
  = scp_solver( scp_cvx___ );

% get optimal value.
assignin( 'caller', 'scp_optval', fsol );

% optimal solution and dual
assignin( 'caller', 'scp_optsol', xsol );
assignin( 'caller', 'scp_optdual', dsol );

% problem and solver information
assignin( 'caller', 'scp_exitflag', exitflag );
assignin( 'caller', 'scp_pinfo', pinfo );
assignin( 'caller', 'scp_dinfo', dinfo );

% clear primal variables.
scp_cloput( 'variables' );

% return the value for variables
if ~isempty( xoutexp ) & strfind( xoutexp, 'xsol' )
    assignin( 'caller', 'xsol', xsol );
    evalin( 'caller', xoutexp );
    evalin( 'caller', 'clear xsol' );
end

% return value for dual variables
if ~isempty( doutexp )
    eval( doutexp );
end

% clear path 
scp_cloput( 'path' );

% clear global variables
evalin( 'caller', 'clearvars -global scp_cvx___' );

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 by Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++