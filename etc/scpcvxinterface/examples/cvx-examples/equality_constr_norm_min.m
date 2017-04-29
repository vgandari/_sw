% Equality constrained norm minimization.
%
% This script constructs a random equality-constrained norm minimization
% problem and solves it using CVX. You can also change p to +2 or +Inf
% to produce different results. Alternatively, you an replace
%     norm( A * x - b, p )
% with
%     norm_largest( A * x - b, 'largest', p )
% for 1 <= p <= 2 * n.

% Generate data
p = 1;
n = 10; m = 2*n; q=0.5*n;
A = randn(m,n);
b = randn(m,1);
C = randn(q,n);
d = randn(q,1);

% Create and solve problem
scp_begin
   scp_variable x(n);
   scp_dual y;
   scp_minimize( norm( A * x - b, p ) )
   convex_begin_declare
        y : C * x == d;
   convex_end_declare
scp_end

% Display results
disp( sprintf( 'norm(A*x-b,%g):', p ) );
disp( [ '   ans   =   ', sprintf( '%7.4f', norm(A*x-b,p) ) ] );
disp( 'Optimal vector:' );
disp( [ '   x     = [ ', sprintf( '%7.4f ', x ), ']' ] );
disp( 'Residual vector:' );
disp( [ '   A*x-b = [ ', sprintf( '%7.4f ', A*x-b ), ']' ] );
disp( 'Equality constraints:' );
disp( [ '   C*x   = [ ', sprintf( '%7.4f ', C*x ), ']' ] );
disp( [ '   d     = [ ', sprintf( '%7.4f ', d   ), ']' ] );
disp( 'Lagrange multiplier for C*x==d:' );
disp( [ '   y     = [ ', sprintf( '%7.4f ', y ), ']' ] );
