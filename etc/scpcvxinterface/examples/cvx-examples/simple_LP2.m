% Builds and solves a simple inequality-constrained linear program

echo on

n = 10;
A = randn(2*n,n);
b = randn(2*n,1);
c = randn(n,1);
d = randn;
scp_begin
   scp_variable x(n)
   scp_dual variables y z
   scp_minimize( c' * x + d )
   scp_subject to
      y : A * x <= b;
scp_end

echo off

