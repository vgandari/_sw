% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: kktcomp - check the first order optimality condition
% Date: 18/06/2009
% Create by: Quoc Tran Dinh - ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
%
% Method:
%   Consider the KKT condition:    0 in c + Jg(xk)'*lbdk +N_Omega(xk)
%                              and 0 = g(xk) 
%   We denote by: pi(xk) is projection of xk on Omega, then, we have
%   (xk, lbdk) is KKT point iff: c + Jg(pi(xk))*lbdk = 0, g(pi(xk)) = 0.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function optimalError = kktcomp( varexp, dualexp, reguexp, omegaset, ...
                                 xgfexp, cvec, funfcns, jacfcns, ...
                                 xkexp, xsolk, lbdLnz, wspars, ...
                                 isAutoDiff, isFiniteDiff, pars )

% create the expression for "cvx" solver to compute the projection point.
probType = wspars.probType;
cmdline = [ 'cvx_quiet( ', char(39), 'quiet', char(39), ');' ];

if isempty( probType )
    cmdline = [ cmdline, 'cvx_begin;', char(39), 'quiet', char(39), ';' ];
else 
    cmdline = [ cmdline, 'cvx_begin ', probtype, ';' ];
end

cmdline = [ cmdline, varexp, dualexp ];
cmdline = [ cmdline, 'minimize(', reguexp, ');' ];
cmdline = [ cmdline, 'subject to;', omegaset, 'cvx_end;' ];

% call "cvx" solver
evalin( 'caller', cmdline );

% get solution
xsolk  = evalin( 'caller', xkexp );

% make expression to get values.
if isempty( pars )
    parexp = ''; 
else
    parexp = ', pars{:}'; 
end

funexpk = strcat( 'funfcns{3}(', xgfexp, parexp, ')' );
jacexpk = strcat( 'jacfcns{3}(', xgfexp, parexp, ')' );
cvecexp = strcat( '[', strrep( strrep( xgfexp, ',', ';' ), ...
                  'xsolk', 'cvec' ), ']' );

% calculate vector c - corresponding to Jacgk.
cvecg = eval( cvecexp );

% calculate function values and their gradients
switch( funfcns{1} )
    case 'fun',
        if isAutoDiff
            [ gvalk, jacgk ] = auto_diff( funfcns{3}, xsolk, ...
                                          xkforg, pars );
        elseif isFiniteDiff
            [ gvalk, jacgk ] = finite_diff( funfcns{3}, xsolk, ...
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

% compute the residual (error).
primalk = cvecg + jacgk'*lbdLnz; 
optimalError = norm( [primalk; gvalk ], 2 );

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++