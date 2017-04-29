% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Example 2: Nonlinear MPC problem of a bilinear system.
% Note: This problem is taken from the paper of C. E. T. Dorea. 
% Created by: Quoc Tran Dinh, ESAT/SCD-OPTEC, KULeuven, Belgium
% Supervisor: Prof. Moritz Diehl.
% Date: 22-06-2009
% Problem description:
%        minimize(sum(||xk||^2_P, 0, N-1) + sum( ||uk||^2_Q, 0, N-1))
%        subject to
%               x(k+1) = A*xk + B*uk + kron( N*ak, uk), k=0,...,N-1
%               lbx <= xk <= ubx, k=0,..., N
%               lbu <= uk <= ubu, k=0,..., N-1
%               xN'*Gf*xN <= rhof (quadratic).
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function [ optsol, optval, exitflag, pinfo, dinfo ] = bs_nmpcexam( x0opt, Hc )

    % check input variable.
    if( nargin < 2 ), Hc = 20; end;
    if(nargin < 1), x0opt = 1; end;    
    if x0opt < 1 || x0opt > 6, 
        error('ERROR: The first variable is only from 1 to 4!' );
    end
    
    % The data of problem.
    A = [0.28, -0.78; -0.78, -0.59]; B = [0.71; 1.62]; 
    N = [0.34, 0.36; 0.41, -0.65];   C = [-0.69, 0.04];
    Gf = [0.062500, 0.000109; 0.000109, 0.062500]; rhof = 1;
	lbx = -4; ubx = 4; lbu = -0.5; ubu = 0.5;
    Q = 1; R = 5;
        
    % the initial points
    x0mat = [-0.43, 1.63; 2, -1.5; 3.0, 3.1; ...
             -2.5, -3; -3, -3.11; -0.43, 1.63];
    
    % size of variables.
    nx = 2*Hc;
    nu = Hc;
    x0 = x0mat( x0opt, :)';
    
    % initial point.
    wx0 = lbx+3.5*ones(nx,1);
    wu0 = lbu+0.3*ones(nu,1);

    % Call the scp-cvx inferface solver.
    scp_begin quiet
        scp_variables wx(nx) wu(nu) t;
        scp_initvar_set( wx, wx0, wu, wu0 );
        scp_objective_set( t, 1 );
        convex_begin_declare
            Q*wx'*wx + R*wu'*wu <= t;
            wx >= lbx;
            wx <= ubx;
            wu >= lbu;
            wu <= ubu;
            %wx(end-1:end)'*Gf*wx(end-1:end) <= rhof;
            { sqrt(Gf)*wx(nx-1:end), sqrt( rhof ) } == scp_lorentz(2);
        convex_end_declare
        nonconvex_variable( wx, wu );
        nonconvex_declare( @nlgf, @nlJgf, A, B, N, x0, nx, nu );
    scp_end
    
    % get results.
    optsol = [x0; wx; wu];
    optval = scp_optval + Q*x0'*x0;
    pinfo = scp_pinfo;
    dinfo = scp_dinfo;
    exitflag = scp_exitflag;
    
    % Plot the graph.
    [ checkOut ] = bs_chkrst( optsol, x0, Hc, A, B, N, C, Gf, rhof, ...
                                lbx, ubx, lbu, ubu, Q, R );
    
    % Assigment results.
    pinfo.checkDynSystem = checkOut.resx;
    pinfo.checkViolState = checkOut.vState;
    pinfo.checkViolContr = checkOut.vControl;
    pinfo.checkViolTerState = checkOut.vTerState;
    
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% end of this function.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Function: nlgf - define nonlinear equality constraints
function gval = nlgf( x, u, A, B, N, x0, nx, nu )

x = [x0; x];
for k=1:nu
    Nxu = u(k)*N*x(2*k-1:2*k);
    gval(2*k-1:2*k, 1) = A*x(2*k-1:2*k) + B*u(k) + Nxu - x(2*k+1:2*k+2);
end;

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Function: nlJgf - define Jacobian of equality constraints
function jgval = nlJgf( x, u, A, B, N, x0, nx, nu )
x = [x0; x];
for k=1:nu
    if k > 1, jgval(2*k-1:2*k, 2*k-3:2*k-2) = A + N*u(k); end
    jgval(2*k-1:2*k, 2*k-1:2*k) = - [1, 0; 0, 1];
    jgval(2*k-1:2*k, nx+k) = B + N*x(2*k-1:2*k);
end

%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%  Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
%  See the file COPYING.txt for full copyright information.
%  The command 'scp_where' will show where this file is located.
%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++