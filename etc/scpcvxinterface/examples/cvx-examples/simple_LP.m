% Builds and solves a simple linear program

echo on

n = 100;
A = randn(0.5*n,n);
b = randn(0.5*n,1);
c = randn(n,1);
d = randn;
scp_begin
   scp_variable x(n)
   scp_dual variables y z
   scp_minimize( c' * x + d )
   scp_subject to
      y : A * x == b;
      z : x >= 0;
scp_end

echo off

