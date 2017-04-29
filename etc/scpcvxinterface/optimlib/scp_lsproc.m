% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++ LINE SEARCH PROCEDURE ++++++++++++++++++++++++++
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Purpose: Line-search strategy is a procedure to find the step size 
% "alpha" such that
%                      alpha = argmin_t{ phi( xk + t*dxk ) }
%  where "phi" is the merit function, "xk" is the current point and 
%  "dxk" is a search direction. 
%  In this case, we choose "phi" is l1-norm penalty function.
% ------------------------------------------------------------------------
% Created by: Quoc Tran Dinh, ESAT/SCD and OPTEC, K.U. Leuven, Belgium.
% Date: 18-06-2009
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function [ alpha,  phival, exitflag, info ] = scp_lsproc( ...
           funfcns, xkforg, cvec, mu, x0, dx, phi0, dphi0, wspars, pars )
           
    
    % parameters: c1par = 1e-4, gamma = 0.5, maxiter = 30;
    c1par      = wspars.ArmijoPar;
    maxiter    = wspars.MaxLSIter;
    gamma      = wspars.BackTrackingStep;
    alpha_max  = wspars.MaxStepSize;
    alpha_min  = wspars.MinStepSize;
       
    % the line search starts here.
    iterk   = 0; 
    fncount = 0;
    alpha   = alpha_max;
    
    % assigment for variables.
    exitflag = -1; info = [];
    status   = '[ls]done';
    message  = 'A step size is found!'; 

    % Make the corressponding variable.
    newxexp = strrep( xkforg, 'xsolk', 'newx' );
    if isempty( pars )
        funexp    = strcat( 'funfcns{2}(', newxexp, ')' );
    else
        funexp    = strcat( 'funfcns{2}(', newxexp, ', pars{:} )' );
    end
        
    % compute the trial point for "phi" function
    newx    = x0 + alpha*dx;
    gval    = eval( funexp );
    fncount = fncount + 1;
    if length( mu ) == length( gval )
        newphi = cvec'*newx + sum( mu.*abs( gval ) );
    elseif length( mu ) == 1
        newphi = cvec'*newx + mu*sum( abs( gval ) );
    else 
        error( '[SCP] Inconsistent dimension!' );
    end
    
    % the main loop to compute step size
    while( newphi > phi0 + c1par*alpha*dphi0 )
        
        % backtracking
        alpha = alpha*gamma;
        
        % if alpha is too small
        if alpha < alpha_min
            % restart with full step: alpha = 1.
            alpha = alpha_max; 
            fncount = 1;
            status   = '[ls]lbstep';
            exitflag = 2;
            break;
        end
        
        % compute a new trial point.
        newx    = x0 + alpha*dx;
        gval    = eval( funexp );
        fncount = fncount + 1;
        if length( mu ) == length( gval )
            newphi = cvec'*newx + sum( mu.*abs( gval ) );
        elseif length( mu ) == 1
            newphi = cvec'*newx + mu*sum( abs( gval ) );
        else 
            error( '[SCP] Inconsistent dimension!' );
        end
        
        % count the number of iterates
        iterk = iterk + 1;
        if iterk > maxiter, 
            exitflag = 3; % out of the maximum limit iterations.
            status = '[ls]exceed'; 
            message = 'exceed the number of maximum iterations';
            break;
        end;
    end
   
    % return the results.
    phival       = newphi;
    info.iter    = iterk;
    info.fncount = fncount;
    info.status  = status;
    info.message = message;

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++