% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Function: [ ... ] = convex_subprob0( ... )
% Purpose: Solve convex subproblem P_cvx( xk )
%                 __________________________________
%                |    min fk(dx) :=  c'*dx          |
%                |    subject to                    |
%                |       gk + Jgk*dx == 0,          | 
%                |       dx in omegaset - xk.       |
%                |__________________________________|
% Here: gk = g(xk) and Jgk = Jg(xk) is the jacobian of g at x.
%
% Date: 20-06-2009
% Created by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function [ xout, dout, xsol, fsol, dsol, exitflag, pinfo ] ...
         = convex_subprob0( varexp, dualexp, objexp, omegaset, ...
           gvalk, Jgvalk, xgk, xfordgf, xkexp, dforLz, reguexp, wspars )
        
	%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    % Get options for cvx
    %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    quiet     = wspars.cvxQuiet;
    precision = wspars.cvxPrecision;
    cvxtype   = wspars.cvxProbType;
    cvxsolver = wspars.cvxSolver;
    expert    = wspars.cvxExpert;
   
    %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    % make expression for the linearization constraints.
    %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    if ~isempty( gvalk ) && ~isempty( Jgvalk ) && ~isempty( xgk )
        gfexpk = inputname(5);
        dgexpk = inputname(6);
        tmpdual = [' dual ', dforLz, ';' ];
        
        % make "lnzconexp" for linearization constraint expression
        lnzconexp = strcat( gfexpk, '+', dgexpk, '*(', xfordgf, ...
                 '-', mat2str(xgk), ') == 0 :', dforLz, ';' );

        omegaset = strcat( omegaset, tmpdual, lnzconexp );
    end
    
    %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    % do regularization
    %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    if ~isempty( reguexp ) 
        if objexp(end) == ';', objexp = objexp(1:end-2); 
        else objexp = objexp(1:end-1); end
        objexp = strcat( objexp, '+', reguexp, ');' );
    end
    
    %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    % create the command line for cvx_solver
    %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    if quiet, cmdline = 'cvx_quiet( true );'; end
    if ~isempty( cvxsolver )
        cmdline = [ cmdline, 'cvx_solver(', char(39), ...
                    cvxsolver, char(39), ');' ];
    end
    if expert, cmdline = [ cmdline, 'cvx_expert( true );' ]; end
    
    if ~isempty( precision ) && ischar( precision )
        cmdline = [ cmdline, 'cvx_precision(', char(39), ...
                    precision, char(39), ');' ];
    end
    
    if ~isempty( cvxtype ),
        cmdline = [ cmdline , 'cvx_begin ', char(39), cvxtype, ...
                    char(39), ';' ];
    else
        cmdline = [ cmdline , 'cvx_begin;' ];
    end
    
    cmdline = [ cmdline, varexp, dualexp, objexp, 'subject to;', omegaset ];
    cmdline = [ cmdline, 'cvx_end;' ];
    
    %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    % caller cvx solver
    %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    evalin( 'caller', cmdline );
    
    %-------------------------------------------------------
    % get results for the convex subproblem
    %-------------------------------------------------------
    fsol    = evalin( 'caller', 'cvx_optval' );
    xsol    = evalin( 'caller', 'cvx_optpnt' );
    dsol    = evalin( 'caller', 'cvx_optdpt' );
    pinfo   = evalin( 'caller', 'cvx_status' );
    
    if strcmpi( pinfo, 'solved' )
        exitflag = 0; 
    else
        exitflag = 1;
    end
    
    % get result for next step
    xout  = evalin( 'caller', xkexp );
    if ~isempty( gvalk ) && ~isempty( Jgvalk ) && ~isempty( xgk )
        dout  = evalin( 'caller', dforLz  );
    else
        dout = []; 
    end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++