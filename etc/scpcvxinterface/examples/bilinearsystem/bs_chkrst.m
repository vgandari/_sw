% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: [ ... ] = bs_chckrst( ... )
% This function checks the result which get from the SCP Algrithm runs.
%
% Created by: Quoc Tran Dinh, ESAT/SCD-OPTEC, KULeuven, Belgium
% Date: 22-06-2009
%
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function [retInfo] = bs_chkrst( w, x0, Hc, A, B, N, C, Gf, rhof, ...
                                  lbx, ubx, lbu, ubu, Q, R )

% data of problems.
nx  = 2*(Hc+1);
nu  = Hc;
nw  = nx + nu;

% state and Control variables.
x = w(1:nx);
u = w(nx+1:nw);


% check the dynamic system.
resx = 0;
for k=1:nu
    uk = u(k);
    xk1 = x(2*k+1:2*k+2);
    xk  = x(2*k-1:2*k);
    resx = norm( A*xk + uk*N*xk + u(k)*B - xk1);
    Cx(k) = C*xk;
end;

resx = resx + norm(x(1:2)-x0);
Cx(nu+1) = C*x(nx-1:nx);

% check violate the state constraints
violateState = sum([x > ubx]) + sum([x< lbx]);
vTerState = sum( [Gf*x(nx-1:nx) - rhof > 0 ] );

% check vaiolet the state constraints
violateContr = sum([u > ubu]) + sum([u< lbu]);

% get result.
retInfo.resx = resx;
retInfo.vState = violateState;
retInfo.vControl = violateContr;
retInfo.vTerState = vTerState;

% draw graphic.
tx = [0:nu];
tu = [0:nu-1];
bs_plot( tx, Cx, tu, u );

%  end of the function.
%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%  Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
%  See the file COPYING.txt for full copyright information.
%  The command 'scp_where' will show where this file is located.
%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++