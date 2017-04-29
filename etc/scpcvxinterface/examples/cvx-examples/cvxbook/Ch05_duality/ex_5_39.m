% Exercise 5.39: SDP relaxations of the two-way partitioning problem
% Boyd & Vandenberghe. "Convex Optimization"
% Jo�lle Skaf - 09/07/05
% (a figure is generated)
%
% Compares the optimal values of:
% 1) the Lagrange dual of the two-way partitioning problem
%               maximize    -sum(nu)
%                   s.t.    W + diag(nu) >= 0
% 2) the SDP relaxation of the two-way partitioning problem
%               minimize    trace(WX)
%                   s.t.    X >= 0
%                           X_ii = 1

% Input data
randn('state',0);
n = 10;
W = randn(n); W = 0.5*(W + W');

% Lagrange dual
fprintf(1,'Solving the dual of the two-way partitioning problem...');

scp_begin sdp
    scp_variable nu(n)
    scp_maximize ( -sum(nu) )
    convex_begin_declare
        W + diag(nu) >= 0;
	convex_end_declare
scp_end

fprintf(1,'Done! \n');
opt1 = scp_optval;

% SDP relaxation
fprintf(1,'Solving the SDP relaxation of the two-way partitioning problem...');

scp_begin sdp
    scp_variable X(n,n) symmetric
    scp_minimize ( trace(W*X) )
    convex_begin_declare
        diag(X) == 1;
        X >= 0;
	convex_end_declare
scp_end

fprintf(1,'Done! \n');
opt2 = scp_optval;

% Displaying results
disp('------------------------------------------------------------------------');
disp('The optimal value of the Lagrange dual and the SDP relaxation fo the    ');
disp('two-way partitioning problem are, respectively, ');
disp([opt1 opt2])
disp('They are equal as expected!');
