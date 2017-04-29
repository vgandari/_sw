% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++ SEQUENTIAL CONVEX PROGRAMMING ALGORITHM +++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Function: [...] = mainalg( ... )
% Purpose:  
%   This sequential convex programming (SCP) algorithm focus on solving 
%   problem as follows
%                  _______________________
%                 |  min f(x) := c'*x     |
%                 |  subject to           |
%                 |      g(x) = 0,        | 
%                 |      x in Omegaset.   |
%                 |_______________________|
%   where c in Rn, g: Rn to Rm nonlinear and smooth
%   and Omegaset in Rn convex.
%
% Date: 18/06/2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function [ xsol, fsol, dsol, exitflag, pinfo, dinfo ] ...
           = scp_mainalg( varexp, dualexp, objexp, omegaset, ...
           gfx, jgfx, xkforg, xfordgf, x0, xkexp, cvec, vregexp, ...
           wspars, pars )
    
	% check input variables
    if nargin < 14, pars = []; end;
    
    % start cpu.
    startcpu = cputime;
    
    % output variables.
    exitflag = 0; pinfo = []; dinfo = []; 
    
    % other options
    switch optimget( wspars, 'Display', defwsopt, 'fast' )
        case {'off','none'}, printlevel = 0;
        case 'notify',       printlevel = 1;
        case 'final',        printlevel = 2;
        case 'iter',         printlevel = 3;
        case 'testing',      printlevel = 4;
            otherwise,       printlevel = 2;
    end
    
    % only convex problem - quick exit.
    if isempty( gfx )
        disp_msg( 'only_convex', (printlevel > 0) );
        
        [ xout, dxout, xsol, fsol, dsol, exitflag, pinfo0 ] ...
         = convex_subprob( varexp, dualexp, objexp, omegaset, ...
           [], [], [], xfordgf, xkexp, [], [], wspars );
       
        xsol = xout;
        pinfo.results.fsol  = fsol;
        pinfo.results.xsol  = xsol;
        pinfo.results.dsol  = dsol;
        pinfo.status        = pinfo0;
        pinfo.cputime       = cputime - startcpu;
        pinfo.niter         = 1;
        pinfo.fncount       = 0;
        
        % display results
        disp_msg( 'result', (printlevel>0), pinfo );
    
        if strcmpi( pinfo0, 'Solved' ), exitflag = 0; 
        else exitflag = -1; end
        return;
    end
    
    tolFun       = wspars.TolF;
    tolCon       = wspars.TolCon;
    tolX         = wspars.TolX;
    isMuIncrease = 0; % +1 = increase, -1=decrease.
    maxIterMuInc = 20;
    scaleMuInc   = 10;
    maxIterMuDec = 20;
    lowerDPhiMax = 10e4;
    scaleMuDec   = 1e-1;
    maxiter      = wspars.MaxSCPIter;
    maxfncount   = wspars.MaxEvalFunc;
    regpar       = 0.5;
    
    isAutoDiff   = strcmpi( wspars.JacbCon, 'auto-diff' );
    isFiniteDiff = strcmpi( wspars.JacbCon, 'finite-diff' );
    
    if ~isempty( jgfx )
        constrflag = 2; % fun_then_jac
    elseif ~isFiniteDiff && ~isAutoDiff
        constrflag = 1; % funjac 
    else 
        constrflag = 0; % fun 
    end

    % check nonlinear constraint function.
    if ~isempty( gfx )
        [ funfcns, idandmsg ] = scp_fcncheck( gfx, length( pars ), ...
                                              constrflag );
    else
        error( 'The nonlinear constraints do not exist!' ); 
    end
    
    % check jacbian function.
    if ~isempty( jgfx )
         [ jacfcns, idandmsg ] = scp_fcncheck( jgfx, length( pars ), ...
                                               constrflag );
    else 
        jacfcns = [];
    end
    
    % initial assigment.
    iter = 0; 
    fncount = 0;
    stopping_criterion = false;
    status = 'starting';
        
    % number of variables.
    nx  = length( x0 ); 
    
    % make expression of variables
    dforlnz  = 'dLnz';
    xgkexp   = strcat( '[', strrep( xkforg, ',', ';' ), ']' );
    reguexp  = strcat( num2str( regpar ), '*', vregexp );
    
    if isempty( pars )
        funexpk  = strcat( 'funfcns{3}(', xkforg, ')' );
    else
        funexpk  = strcat( 'funfcns{3}(', xkforg, ', pars{:} )' );
    end
    if isempty( pars )
        jacexpk  = strcat( 'jacfcns{3}(', xkforg, ')' );
    else
        jacexpk  = strcat( 'jacfcns{3}(', xkforg, ', pars{:} )' );
    end
    
    % compute the current pointsxsolk =  x0val; 
    cvec = cvec(:);
    xsolk = x0(:);
    xgk   = eval( xgkexp );
	dxk = ones( nx, 1 );
    
    % calculate objective value function
    fk = cvec'*xsolk;
    optimalError     = inf;
    feasError        = inf;
    bestfk           = inf;
    bestxsol         = xsolk;
    bestdsol         = [];
    bestdsol.dLnz    = [];
    bestOptimalError = optimalError;
	bestFeasError    = feasError;
                                          
    % calculate function values and their gradients
    switch( funfcns{1} )
        case 'fun',
            if isAutoDiff
                [ gvalk, jacgk ] = auto_diff( funfcns{2}, xsolk, ...
                                              xkforg, pars );
            elseif isFiniteDiff
                [ gvalk, jacgk ] = finite_diff( funfcns{2}, xsolk, ...
                                               xkforg, pars );
            else
                error( '[SCP] Unknown Jacobian function!' );
            end
            
        case 'funjac',
            [ gvalk, jacgk ] = eval( funexpk );
            
        case 'fun_then_jac',
            gvalk = eval( funexpk );
            jacgk = eval( jacexpk );
            
        otherwise
            error( '[SCP] Nonlinear constraints are not provided!' );
    end
    fncount    = fncount + 1;
    
    % number of nonlinear constraints
    ncstr = length( gvalk );

    % some variables for printing results
    formatstrFirstIter = '%5.0f  %5.0f   %12.6g  %12.6g   %s';
    formatstr = '%5.0f  %5.0f   %12.4g  %12.4g %12.3g    %12.3g      %s';
    disp_msg( 'info', (printlevel > 0) );
    
    optimScal = 1; 
    feasScal = 1;
    
    % initial value for penalty function.
    oldmuk = sqrt( repmat( eps + cvec'*cvec, ncstr, 1) ...
                   ./ ( sum( (jacgk.*jacgk)' )' + eps ) ); 
    %oldmuk = 0.0*ones( ncstr, 1 );
                    
    % Check if is conic constraints or take along time.
    isNotConic = wspars.isNotConic;
    isNotTakeLongTime = false;
    
    % ----------------------------------------------------------
    % main loop - WHILE ...  
    % ----------------------------------------------------------
    while ~stopping_criterion
        
        % process the 0-iteration.
        if iter == 0
            if printlevel > 2
                disp_msg( 'header', (printlevel > 2) );
                ostr = sprintf( formatstrFirstIter, iter, fncount );
                disp( ostr );
            end
            
        % process the k-iteration ( k > 0 ).
        else
            
            % compute the KKT condition
            if isNotConic && isNotTakeLongTime
                
               optimalError = kktcomp( varexp, dualexp, reguexp, ...
                              omegaset, xgfexp, cvec, funfcns, jacfcns, ...
                              xkexp, xsolk, dlbdk, wspars, ...
                              isAutoDiff, isFiniteDiff, pars );
            else 
               optimalError = norm( dxk );
            end
            
            % feasible gap.
            feasError = norm( gvalk );
            
            % print the k - iteration
            if printlevel > 2
                ostr = sprintf( formatstr, iter, fncount,...
                       feasError, optimalError, alphak, dphik, statusk );
                disp( ostr );
            end
            
            % test convergence
            if optimalError < tolX*optimScal && feasError < tolCon*feasScal
                outMsg = disp_msg( 'done', (printlevel > 0) ); 
                exitflag = 1; 
                stopping_criterion = true;
                status = 'done!';
            else
                % exceed the number of maximum function evaluations
                if fncount > maxfncount
                    outMsg = disp_msg( 'maxfncount', (printlevel>0) ); 
                    exitflag = 0; 
                    stopping_criterion = true;
                    status = 'maxfncount';
                end
                
                % exceed of the number of maximum iterations
                if iter >= maxiter
                    outMsg = disp_msg( 'maxiter', (printlevel>0) ); 
                    exitflag = 0; 
                    stopping_criterion = true;
                    status = 'maxiter';
                end
            end
            
        end % of if
        
        % starting compute the search direction 
        if ~stopping_criterion
            iter = iter + 1;
            status = 'running';
            
            % -----------------------------------------------------------
            % solve the subproblem to get the search direction.
            % -----------------------------------------------------------
            [ dxk, dlbdk, rxk, fk, rdk, exitflagk, pinfok ] ...
              = convex_subprob0( varexp, dualexp, objexp, omegaset, ...
                gvalk, jacgk, xgk, xfordgf, xkexp, dforlnz, ...
                [], wspars );

            % compute search direction
            dxk     = dxk - xsolk;
            % derivative of objective function.
            derivfk = cvec'*dxk; 
            statusk = pinfok;
            
            % keep the best value
            if fk < bestfk && max( abs( gvalk ) ) < tolFun
                bestfk        = fk;
                bestxsol      = xsolk;
                bestdsol      = rdk;
                bestdsol.dLnz = dlbdk; 
                bestOptimalError = optimalError;
                bestFeasError    = feasError;
            end
            
            % update penalty parameter.
            [ oldmuk, dphik ] = penupd( dlbdk, oldmuk, derivfk, gvalk, ...
                                        wspars, false );
                        
            % compute the derivative of the merit function
            sgvalk = sum( oldmuk.*abs( gvalk ) );
            phik = fk + sgvalk;
                        
            % call the globalization strategy.
            switch( wspars.GlobalStrategy )

            % do full-step
            case 'full-step',
                alphak = 1; 

            % do line-search    
            case 'line-search', 
                % check the directional derivative - if "dxk" is not a
                % descent direction, do regularization to compute a new
                % step "dxk".
                if dphik >= 0,
                    [ dxk, dlbdk, rxk, fk, rdk, exitflagk, pinfok ] ...
                    = convex_subprob0( varexp, dualexp, objexp, omegaset, ...
                      gvalk, jacgk, xgk, xfordgf, xkexp, dforlnz, ...
                      reguexp, wspars );

                    % compute search direction
                    dxk = dxk - xsolk;
                    derivfk = cvec'*dxk; % derivative of objective function.
                    statusk = strcat( pinfok,'/Regu.');
                    
                    % keep the best value
                    if fk < bestfk && max(abs( gvalk )) < tolCon
                        bestfk        = fk;
                        bestxsol      = xsolk;
                        bestdsol      = rdk;
                        bestdsol.dLnz = dlbdk; 
                        bestOptimalError = optimalError;
                        bestFeasError    = feasError;
                    end
                    
                    % update penalty parameter.
                    [ oldmuk, dphik ] = penupd( dlbdk, oldmuk, derivfk, ...
                                                gvalk, wspars, false );
                    % make sure that if "dphik >= 0", try to find muk such
                    % that "dphik < 0".
                    if dphik >= 0 && isMuIncrease == +1
                        itertmp = 0; 
                        while( dphik >= 0 ) && ( itertmp < maxIterMuInc )
                            oldmuk = scaleMuInc*oldmuk;
                            dphik = derivfk - sum( oldmuk.*abs( gvalk ) );
                            itertmp = itertmp + 1;
                        end
                    end
                    
                    % if dphik is to small increase it 
                    if dphik < -lowerDPhiMax && isMuIncrease == -1
                        itertmp = 0;
                        while( dphik < -lowerDPhiMax ) && ( itertmp < maxIterMuDec )
                            oldmuk = scaleMuDec*oldmuk;
                            dphik = derivfk - sum( oldmuk.*abs( gvalk ) );
                            itertmp = itertmp + 1;
                        end
                    end
                    
                    % compute the derivative of the merit function
                    sgvalk = sum( oldmuk.*abs( gvalk ) );
                    phik = fk + sgvalk;
                    % do line search.
                    [ alphak,  phivalk, exitflagk, infok ] = scp_lsproc( ...
                    funfcns, xkforg, cvec, oldmuk, xsolk, dxk, phik, ...
                    dphik, wspars, pars );

                    fncount = fncount + infok.fncount;
          
                % if "dphik < 0", then "dxk" is a descent direction, do 
                % line search.
                else
                    [ alphak,  phivalk, exitflagk, infok ] = scp_lsproc( ...
                        funfcns, xkforg, cvec, oldmuk, xsolk, dxk, phik, ...
                        dphik, wspars, pars );

                    fncount = fncount + infok.fncount;
                end
                statusk = strcat( statusk, '/', infok.status );
                
            % otherwise do full-step.
            otherwise 
                alphak = 1;
            end
        end
        
        % -----------------------------------------------------------
        % update new iteration
        % -----------------------------------------------------------
        xsolk = xsolk + alphak*dxk;
        xgk   = eval( xgkexp );
                
        % -----------------------------------------------------------
        % compute value and jacobian of the equality constraints.
        % -----------------------------------------------------------
        if ~stopping_criterion
            
            % compute the value and jacobian of nonlinear constraints
            switch( funfcns{1} )
                case 'fun',
                    if isAutoDiff
                        [ gvalk, jacgk ] = auto_diff( funfcns{2}, xsolk, ...
                                               xkforg, pars );
                    elseif isFiniteDiff
                        [ gvalk, jacgk ] = finite_diff( funfcns{2}, ...
                                           xsolk, xkforg, pars );
                    else
                        error( '[SCP] Unknown jacobian function!' );
                    end
                    
                case 'funjac',
                    [ gvalk, jacgk ] = eval( funexpk );
                    
                case 'fun_then_jac',
                    gvalk = eval( funexpk );
                    jacgk = eval( jacexpk );
                    
                otherwise
                    error( '[SCP] Nonlinear function is not provided!' );
            end
            
            fncount = fncount + 1;
        end
        
    end % end while.
    % ----------------------------------------------------------
    % end of the main loop - END OF WHILE.
    % ----------------------------------------------------------
    
    % keep the best one
    if fk > bestfk
        fsol = bestfk;
        xsol = bestxsol;
        dsol = bestdsol;
        dsol.dLnz = bestdsol.dLnz;
        optimalError = bestOptimalError;
        feasError    = bestFeasError;
    else
        % get solution and its optimal value.
        fsol      = fk;
        xsol      = xsolk; 
        dsol      = rdk;
        dsol.dLnz = dlbdk;
    end
            
    % return the results.
    pinfo.results.fsol  = fsol;
    pinfo.results.xsol  = xsol;
    pinfo.results.dsol  = dsol;
    pinfo.niter         = iter;
    pinfo.fncount       = fncount;
    pinfo.optimalError  = optimalError;
    pinfo.feasError     = feasError;    
    pinfo.status        = status;
    pinfo.outMsg        = outMsg;
    pinfo.fcnsCheck     = idandmsg;
    pinfo.cputime       = cputime - startcpu;
    
    % display results
    disp_msg( 'result', (printlevel>0), pinfo );
    
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++