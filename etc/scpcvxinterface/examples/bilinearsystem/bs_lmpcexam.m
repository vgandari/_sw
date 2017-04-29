% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Example 1: Nonlinear MPC problem of a bilinear system.
% Note: This problem is taken from the paper of C. E. T. Dorea. 
% Created by: Quoc Tran Dinh, ESAT/SCD-OPTEC, KULeuven, Belgium
% Date: 22-06-2009
% Problem description:
%        minimize(sum(||xk||^2_P, 0, N-1) + sum( ||uk||^2_Q, 0, N-1))
%        subject to
%               x(k+1) = A*xk + B*uk + kron( N*ak, uk), k=0,...,N-1
%               lbx <= xk <= ubx, k=0,..., N
%               lbu <= uk <= ubu, k=0,..., N-1
%               Gf*xN <= rhof (linear).
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function [ optsol, optval, exitflag, pinfo, dinfo ] = bs_lmpcexam( x0opt, Hc )
    
    % check input variable.
    if( nargin < 2 ), Hc = 20; end;
    if(nargin < 1), x0opt = 1; end;    
    if x0opt < 1 || x0opt > 4, 
        error('ERROR: The first variable is only from 1 to 4!' );
    end
    
    % the data of problem.
    A = [0.28, -0.78; -0.78, -0.59]; B = [0.71; 1.62]; 
    C = [-0.69, 0.04]; N = [0.34, 0.36; 0.41, -0.65];     
    Gf = [ 1.0000, 0; 0, 1.0000; -1.0000, 0; 0, -1.0000; -0.3549, ...
          -0.5648; 0.1549, -1.3521; 0.3549, 0.5648; -0.1549, 1.3521; ...
          -0.4433, -0.4202; 0.4433, 0.4202; 1.0616, -1.6538; -1.0616, 1.6538 ];
    rhof = [ 4.0000, 4.0000, 4.0000, 4.0000, 2.8207, 5.8271, 2.8207, ...
             5.8271, 2.7712, 2.7712, 10.5647, 10.5647]';
         
	lbx = -4; ubx = 4;
    lbu = -0.5; ubu = 0.5;
    Q = 1; R = 5;
    
    % initial state.
    x0mat = [2, -1.5; 3.0, 3.1; 3.9, -3.95; -3, -3.11; -0.43, 1.63];
    x0 = x0mat( x0opt, : )';
    
    % size of the variables.
    nx = 2*Hc; nu = Hc; nw = nx + nu;

    % define equality constraint and its jacobian function.
    gf = @(x, u)( nlgf( x, u, A, B, N, x0, nx, nu ) );
    Jgf = @(x, u)( nlJgf( x, u, A, B, N, x0, nx, nu ) );
    
    % initial point.
    wx0 = lbx+3.5*ones(nx,1); 
    wu0 = lbu+0.3*ones(nu, 1);
    
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
            Gf*wx(nx-1:nx) <= rhof;
        convex_end_declare
        nonconvex_variable( wx, wu );
        %nonconvex_declare( gf, Jgf );
        nonconvex_declare( @nlgf, @nlJgf, A, B, N, x0, nx, nu );
    scp_end

    % get result.
    optsol = [x0; wx; wu];
    optval = scp_optval + Q*x0'*x0;
    pinfo = scp_pinfo;
    dinfo = scp_dinfo;
    exitflag = scp_exitflag;

    % plot the graph.
    [ checkOut ] = bs_chkrst( optsol, x0, Hc, A, B, N, C, Gf, rhof, ...
                              lbx, ubx, lbu, ubu, Q, R );
    
    % assigment results.
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