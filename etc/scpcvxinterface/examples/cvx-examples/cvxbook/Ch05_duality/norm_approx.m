% Examples 5.6,5.8: An l_p norm approximation problem
% Boyd & Vandenberghe "Convex Optimization"
% Joëlle Skaf - 08/23/05
%
% The goal is to show the following problem formulations give all the same
% optimal residual norm ||Ax - b||:
% 1)        minimize    ||Ax - b||
% 2)        minimize    ||y||
%               s.t.    Ax - b = y
% 3)        maximize    b'v
%               s.t.    ||v||* <= 1  , A'v = 0
% 4)        minimize    1/2 ||y||^2
%               s.t.    Ax - b = y
% 5)        maximize    -1/2||v||*^2 + b'v
%               s.t.    A'v = 0
% where ||.||* denotes the dual norm of ||.||

scp_set_ws( 'cvxQuiet', true );
% Input data
randn('state',0);
n = 4;
m = 2*n;
A = randn(m,n);
b = randn(m,1);
p = 2;
q = p/(p-1);

% Original problem
fprintf(1,'Computing the optimal solution of problem 1... ');

scp_begin
    scp_variable x(n)
    scp_minimize ( norm ( A*x - b , p) )
scp_end

fprintf(1,'Done! \n');
opt1 = scp_optval;

% Reformulation 1
fprintf(1,'Computing the optimal solution of problem 2... ');

scp_begin
    scp_variables x(n) y(m)
    scp_minimize ( norm ( y , p ) )
    convex_begin_declare
        A*x - b == y;
    convex_end_declare    
scp_end

fprintf(1,'Done! \n');
opt2 = scp_optval;

% Dual of reformulation 1
fprintf(1,'Computing the optimal solution of problem 3... ');

scp_begin
    scp_variable nu(m)
    scp_maximize ( b'*nu )
    convex_begin_declare
    norm( nu , q ) <= 1;
    A'*nu == 0;
    convex_end_declare
scp_end

fprintf(1,'Done! \n');
opt3 = scp_optval;

% Reformulation 2
fprintf(1,'Computing the optimal solution of problem 4... ');

scp_begin
    scp_variables x(n) y(m)
    scp_minimize ( 0.5 * square_pos ( norm ( y , p ) ) )
    convex_begin_declare
        A*x - b == y;
	convex_end_declare
scp_end

fprintf(1,'Done! \n');
opt4 = (2*scp_optval).^(.5);

% Dual of reformulation 2
fprintf(1,'Computing the optimal solution of problem 5... ');

scp_begin
    scp_variable nu(m)
    scp_maximize ( -0.5 * square_pos ( norm ( nu , q ) ) + b'*nu )
    convex_begin_declare
        A'*nu == 0;
	convex_end_declare
scp_end

fprintf(1,'Done! \n');
opt5 = (2*scp_optval).^(0.5);

% Displaying results
disp('------------------------------------------------------------------------');
disp('The optimal residual values for problems 1,2,3,4 and 5 are respectively:');
[ opt1 opt2 opt3 opt4 opt5 ]'
disp('They are equal as expected!');
