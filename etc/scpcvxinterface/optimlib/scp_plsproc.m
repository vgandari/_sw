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
function [ alpha,  phival, exitflag, info ] = scp_plsproc( ...
           cvec, varname, funfcns, xgfexp, mu, xcur, dx, ...
           phi0, dphi0, wspars )
    
    % parameters: c1par = 1e-4, gamma = 0.5, maxiter = 30;
    c1par      = wspars.ArmijoPar;
    maxiter    = wspars.MaxLSIter;
    %gamma      = wspars.BackTrackingStep;
    alpha_max  = wspars.MaxStepSize;
    alpha_min  = wspars.MinStepSize;
    %lalpha = alpha_min; ualpha = alpha_max;
       
    % the line search starts here.
    iterk = 0; fncount = 0;
    alpha = alpha_max;
    
    % assigment for variables.
    exitflag = -1; info = [];
    status = 'done';
    message = 'A step size is found!'; 
    
    % check the descent direction.
    if( dphi0 >= 0 )
        %error('ERROR: This direction is not descent! ');
        warning( '[SCP] This direction is not descent!' );
    end;

    % Make the corressponding variable.
    newxexp = strrep( xgfexp, varname, 'newx' );
    funexp    = strcat( 'funfcns{3}(', newxexp, ')' );
    fncount = fncount + 1;
    
    % compute the trial point for "phi" function
    newx = xcur + alpha*dx;
    gval = eval( funexp );
    if length( mu ) == length( gval )
        newphi = transpose( cvec )*newx + sum( mu.*abs( gval ) );
    elseif length( mu ) == 1
        newphi = transpose( cvec )*newx + mu*sum( abs( gval ) );
    else 
        error( '[SCP] Inconsistent dimension!' );
    end
    
    % intialize for the line search procedure
    curphi = newphi; curalpha = alpha;
    
    % the main loop to compute step size
    while( newphi > phi0 + c1par*curalpha*dphi0 )
        if iterk == 0,
            alpha = interp2or3points( phi0, dphi0, curalpha, curphi, wspars );
        else
            alpha = interp2or3points( phi0, dphi0, curalpha, curphi, ...
                                   wspars, alphamax, phimax );
        end
        
        % if alpha is too small
        if alpha < alpha_min, alpha = alpha_min; end
        
        % update for next iteration
        phimax = curphi; alphamax = curalpha; curalpha = alpha;
        
        % compute a new trial point.
        newx = xcur + curalpha*dx;
        gval     = eval( funexp );
        fncount = fncount + 1;
        if length( mu ) == length( gval )
            newphi = transpose( cvec )*newx + sum( mu.*abs( gval ) );
        elseif length( mu ) == 1
            newphi = transpose( cvec )*newx + mu*sum( abs( gval ) );
        else 
            error( '[SCP] Inconsistent dimension !' );
        end
        
        % update the current value of "phi" function.
        curphi = newphi;

        % count the number of iterates
        iterk = iterk + 1;
        if iterk > maxiter, 
            exitflag = 3; % out of the maximum limit iterations.
            status = 'max_iter'; 
            message = 'exceed the number of maximum iterations';
            break;
        end;
    end
    
    % return the results.
    phival = curphi;
    info.iter = iterk;
    info.fncount = fncount;
    info.status = status;
    info.message = message;

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Function: [ ... ] = interp2or3points( ... ).
% This function makes interpolation polynomial with two or three points.
% It applies three-point safeguarded parabolic model for a line search.
% Parameters:
%      sigma0 = 0.1, sigma1 = 0.5, safeguarding bounds for the linesearch
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function  alpha_plus  = interp2or3points( phi0, dphi0, curalpha, curphi, ...
                     wspars, alphamax, phimax )

sigma0     = wspars.LSInterpPar1;
sigma1     = wspars.LSInterpPar2;
lalpha = curalpha*sigma0;
ualpha = curalpha*sigma1;

if nargin <= 5
    alpha_plus = -0.5*dphi0 / ( curalpha*( curphi - phi0 - dphi0 ) );
    if alpha_plus < lalpha
        alpha_plus = lalpha;
    end
    if alpha_plus > ualpha
        alpha_plus = ualpha;
    end
else
    matA = [ curalpha*curalpha, curalpha*curalpha*curalpha; ...
            alphamax*alphamax, alphamax*alphamax*alphamax ];
	if alphamax == 1, matA(2,2) = matA(2,2) + 1e-5; end
    
    rhs = [ curphi - phi0 - dphi0*curalpha; ...
            phimax - phi0 - dphi0*alphamax ];
    c = matA\rhs;
    delta = max( c(1)*c(1) - 3*c(2)*dphi0, 0);
    alpha_plus = ( -c(1) + sqrt(delta))/(3*c(2) );
    if alpha_plus < lalpha
        alpha_plus = lalpha;
    end
    if alpha_plus > ualpha
        alpha_plus = ualpha;
    end
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++