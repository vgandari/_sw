% Builds and solves a simple least-squares problem using cvx

echo on

n = 100;
A = randn(2*n,n);
b = randn(2*n,1);
scp_begin
   scp_variable x(n)
   scp_minimize( norm( A*x-b ) )
scp_end

echo off
