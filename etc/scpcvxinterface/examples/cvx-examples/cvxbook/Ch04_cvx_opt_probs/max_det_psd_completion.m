% Exercise 4.47: Maximum determinant PSD matrix completion
% Boyd & Vandenberghe "Convex Optimization"
% Almir Mutapcic - Jan 2006
%
% Given a symmetric matrix A in R^(n-by-n) with some entries unspecified
% we find its completion such that A is positive semidefinite and
% it has a maximum determinant out of all possible completions.
% This problem can be formulated as a log det (and det_rootn) problem.
%
% This is a numerical instance of the specified book exercise.

% problem size
n = 4;

% create and solve the problem
scp_begin sdp
  % A is a PSD symmetric matrix (n-by-n)
  scp_variable A(n,n) symmetric;
  % find the solution to the problem
  scp_maximize( log_det( A ) )
  convex_begin_declare
      A >= 0;

      % constrained matrix entries.
      A(1,1) == 3;
      A(2,2) == 2;
      A(3,3) == 1;
      A(4,4) == 5;
      % Note that because A is symmetric, these off-diagonal
      % constraints affect the corresponding element on the
      % opposite side of the diagonal.
      A(1,2) == .5;
      A(1,4) == .25;
      A(2,3) == .75;

  % maximize( det_rootn( A ) )
  convex_end_declare
scp_end

% display solution
disp(['Matrix A with maximum determinant (' num2str(det(A)) ') is:'])
A
disp(['Its eigenvalues are:'])
eigs = eig(A)
