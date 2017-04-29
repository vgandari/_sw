% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Function: [ ... ] = convex_subprob( ... )
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
function [ xout, dout, xsol, fsol, dsol, exitflag, pinfo, dinfo ] ...
         = convex_subprob( varexp, dualexp, objexp, omegaset, ...
           gvalk, Jgvalk, xgk, xfordgf, xkexp, dforLz, reguexp, wspars )
        
	%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    % Get options for cvx
    %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    quiet     = wspars.cvxQuiet;
    precision = wspars.cvxPrecision;
    cvxtype   = wspars.cvxProbType;
    cvxsolver = wspars.cvxSolver;
    cvx_quiet( quiet );
    cvx_precision( precision );
    cvx_solver( cvxsolver );
    
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
    
    % do regularization
    if ~isempty( reguexp ) 
        if objexp(end) == ';', objexp = objexp(1:end-2); 
        else objexp = objexp(1:end-1); end
        objexp = strcat( objexp, '+', reguexp, ');' );
    end
    
    %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    % CVX_BEGIN - Start CVX solver
	evalin( 'caller', ['cvx_begin ', cvxtype ] );
    %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                
        %----------------------------------------
        % process variables
        %----------------------------------------
        if ischar( varexp ) && ~isempty( varexp )
             evalin( 'caller', varexp );
        end
        
        %----------------------------------------
        % process dual variables
        %----------------------------------------
        if ischar( dualexp ) && ~isempty( dualexp )
             evalin( 'caller', dualexp );
        end
        
        %----------------------------------------
        % process objective function
        %----------------------------------------
        if ischar( objexp ) && ~isempty( objexp )
             evalin( 'caller', objexp );
        end
        
        %----------------------------------------
        % keyword: subject to
        %----------------------------------------
        evalin( 'caller', 'subject to' );
        
        %----------------------------------------
        % process the constraints
        %----------------------------------------
        if ischar( omegaset ) && ~isempty( omegaset )
             evalin( 'caller', omegaset );
        end
        
	%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    % CVX_END - Finish CVX solver
	evalin( 'caller', 'cvx_end' );
    %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    %-------------------------------------------------------
    % get results for the convex subproblem
    %-------------------------------------------------------
    fsol    = evalin( 'caller', 'cvx_optval' );
    xsol    = evalin( 'caller', 'cvx_optpnt' );
    dsol    = evalin( 'caller', 'cvx_optdpt' );
    pinfo   = evalin( 'caller', 'cvx_status' );
    dinfo   = [];
    if strcmpi( pinfo, 'solved' ), exitflag = 0; else exitflag = 1; end
    
    % get result for next step
    xout  = evalin( 'caller', xkexp );
    if ~isempty( gvalk ) && ~isempty( Jgvalk ) && ~isempty( xgk )
        dout  = evalin( 'caller', dforLz  );
    else dout = []; end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
