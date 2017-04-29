% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Example 2: Large scale example
% Date: 20-06-2009
% Created by: Quoc Tran Dinh, ESAT/SCD and OPTECT, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function largescale_exam

% declare the data.
n = 10; m=3;
density = 0.3;
lb = -10; ub = 10;
A = sprandn(m, n, density );
b = sprandn( m, 1, density );
c = sprandn( n, 1, density );
lbx = lb*ones(n, 1);
ubx = ub*ones(n, 1);
x0 = ones(n, 1);

% call the solver.
scp_begin quiet
    scp_variables x(n);
    scp_initvar_set( x, x0 );
    scp_objective_set( x, c );
    convex_begin_declare
         x >= lbx;
         x <= ubx;
    convex_end_declare;
    nonconvex_variable( x );
    nonconvex_declare( @ls_gf, @ls_Jgf );
scp_end;

%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%  define the equality constraints
%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function gval = ls_gf( x )
    n = length( x );  n2 = round( n/2 ); n3 = n - n2;
    Q1 = sparse( diag( [1:n2] ) );  Q2 = sparse( diag( [1:n3] ) );
    gval(1,1) = x(1:n2)'*Q1*x(1:n2) + ones(1,n3)*x(n2+1:n) - 100;
    gval(2,1) = x(n2+1:n)'*Q2*x(n2+1:n) - 10*ones(1,n2)*x(1:n2) + 5;
  
%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%  define the jacobian of the equality constraints
%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function Jgval = ls_Jgf( x )
    n = length( x );  n2 = round( n/2 ); n3 = n - n2;
    Q1 = sparse( diag( [1:n2] ) );  Q2 = sparse( diag( [1:n3] ) );
    Jgval(1, 1:n) = [ 2*x(1:n2)'*Q1,  ones(1,n3) ];
    Jgval(2, 1:n) = [ -10*ones(1,n2), 2*x(n2+1:n)'*Q2 ];

%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%  Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
%  See the file COPYING.txt for full copyright information.
%  The command 'scp_where' will show where this file is located.
%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++