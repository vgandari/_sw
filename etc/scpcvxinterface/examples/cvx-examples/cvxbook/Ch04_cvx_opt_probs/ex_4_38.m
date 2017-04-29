% Exercise 4.38(b): Linear matrix inequalities with one variable
% From Boyd & Vandenberghe, "Convex Optimization"
% Joëlle Skaf - 09/26/05
%
% Finds the optimal t that would maximize c*t while still having A - t*B
% positive semidefinite by solving the following SDP:
%           minimize    c*t
%               s.t.    t*B <= A
% c can either be a positive or negative real number

% Generate input data
randn('state',0);
n = 4;
A = randn(n); A = 0.5*(A'+A); %A = A'*A;
B = randn(n); B = B'*B;
% can modify the value of c (>0 or <0)
c = -1;

% Create and solve the model
scp_begin sdp
    scp_variable t
    scp_minimize ( c*t )
    convex_begin_declare
        A >= t * B;
    convex_end_declare
scp_end

% Display results
disp('------------------------------------------------------------------------');
disp('The optimal t obtained is');
disp(t);
