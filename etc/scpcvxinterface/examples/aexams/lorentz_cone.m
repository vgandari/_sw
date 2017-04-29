% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Example 3: Lorentz cone problem
% Date: 20-06-2009
% Created by: Quoc Tran Dinh, ESAT/SCD and OPTECT, KULeuven, Belgium.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function lorentz_cone

% declare the data.
n = 5;
A = [1, 1, 1, 1, 1; -1, -1, -1, -1, -1];
b = [5; -5];
c = [2; 1; -4; 3; -2];
lbx = -10*ones(n, 1);
ubx = 10*ones(n, 1);
x0 = ones(n, 1);

% define equality constraint and its jacobian
gfx  = @(x)( x(1)*x(2) - x(3)*x(4) + 2*x(5) - 5 );
Jgfx = @(x)( [ x(2), x(1), -x(4), -x(3), 2 ] );

% call the solver.
scp_begin quiet
    scp_variables x(n) y;
    scp_initvar_set( x, x0 );
    scp_objective_set( x, c );
    convex_begin_declare
         x >= lbx;
         x <= ubx;
         A*x <= b;
         { x(1:n-1), x(n) } == scp_lorentz(n-1);
         x(n) >= y; y <= 4; y >= -4;
    convex_end_declare
    nonconvex_variable( x );
    nonconvex_declare( gfx, Jgfx );
scp_end;

%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%  Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
%  See the file COPYING.txt for full copyright information.
%  The command 'scp_where' will show where this file is located.
%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++