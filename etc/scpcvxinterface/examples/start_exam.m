% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Starting Examples ...
% Date: 20-06-2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

% ------------------------------------------------------
%                   EXAMPLE 01 - convex case.
% Lyapunov stability of the system of a linear ODE
%                   x(t) = Ax(t).
% Lyapunov function: L(x(t)) = x(t)'Vx(t) < -alfa*||x(t)||^2
% -------------------------------------------------------
n  = 5;
En = eye(n);
A  = rand(n);
scp_begin
    scp_variable alfa;
    scp_variable V(n,n) symmetric;
    scp_minimize alfa;
    scp_subject to
        alfa*En - A'*V - V*A == scp_semidefinite(n);
        V - En == scp_semidefinite(n);
scp_end

disp( sprintf( '\n\n + Value of "alfa": %6.6f', alfa ) );
disp( ' + Value of "V":' ); disp(V);

% ------------------------------------------------------
%                   EXAMPLE 02 - convex case.
% Minimize the largest eigenvalue of a symmetric matrix
%                   lb* = min lb(X)
%                   subject to
%                         A(X) == b, X >= 0
% -------------------------------------------------------
n = 5;
En = eye(n);
A = 10*rand(n, n*n);
b = 10*rand(n,1);

% cvx - solver
cvx_begin sdp
    variable t;
    variable X(n,n) symmetric;
    minimize t;
    subject to
        A*vec(X) == b;
        t*En - X == semidefinite(n);
cvx_end
disp( sprintf( '\n\n + [CVX] Value of "t": %6.6f', t ) );
disp( ' + [CVX] Value of "X":' ); disp(X);

% scp-cvx based interface.
scp_begin sdp
    scp_variable t;
    scp_variable X(n,n) symmetric;
    scp_minimize t;
    scp_subject to
        A*vec(X) == b;
        t*En - X == scp_semidefinite(n);
scp_end

disp( sprintf( '\n\n + Value of "t": %6.6f', t ) );
disp( ' + Value of "X":' ); disp(X);

% ------------------------------------------------------
%               EXAMPLE 04 - nonconvex case.
%                    minimize c'*x
%                    subject to:
%                        g(x) == 0
%                        x  in Omega.
% where g: Rn -> Rm, nonlinear, Omega is convex in Rn
% -------------------------------------------------------

% declare the data.
n = 5;
m=2;
A = randn( m, n );
b = randn( m, 1 );
c = randn( n, 1 );
lb = -10*ones(n, 1);
ub = 10*ones(n, 1);
x0 = ones(n, 1);

% define equality constraint and its jacobian
nlgfx  = @(x)( exp(x(1))*x(2) - x(3)*x(4) + 2*x(5) - 10 );
nlJgfx = @(x)( [ exp(x(1))*x(2), exp(x(1)), -x(4), -x(3), 2 ] );

% call the scp-cvx interface.
scp_begin quiet
    % declare multivariable - use "scp_variables"
    % declare variable (with type) - use "scp_variable"
    scp_variables x(n) y;
    % declare dual variable  - use "scp_dual" or "scp_dual variables"
    scp_dual z u v{2};
    % set initial value to each variable - use "scp_initvar_set"
    % each variable goes in pair ( name, value ).
    scp_initvar_set( x, x0 );
    % set value to objective vector (corresponding to each variable )
    % goes in pair ( variable name, value of c ) - use "scp_objective_set".
    scp_objective_set( x, c );
    % start declearing convex set Omega - use "convex_begin_declare"
    convex_begin_declare
         x >= lb:z;
         u:x <= ub;
          { x, y } == scp_lorentz( n ); % for the LORENTZ cone
         v{1}:y <= 3; y >= -3:v{2};
    % finish declaring convex set omega - use "convex_end_declare"
    convex_end_declare;
    % declare variable corresponding to the nonlinear function g.
    % use "nonconvex_variable" command
    nonconvex_variable( x );
    % declare the function_handle indicates to function g and its jacobian
    % allow some parameters (this version does nto support for AD method).
    nonconvex_declare( nlgfx, nlJgfx );
% finsh scp-cvx interface.
scp_end;

%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%  Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
%  See the file COPYING.txt for full copyright information.
%  The command 'scp_where' will show where this file is located.
%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
