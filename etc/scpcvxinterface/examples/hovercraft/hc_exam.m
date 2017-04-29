% ########################################################################
% Function: [ ... ] = hc_exam - An example 
% Purpose: Determine the trajectory of a hover craft motion 
%          Apply the SCP algorithm based on CVX solver.   
% Created by: Quoc Tran Dinh, ESAT/SCD-OPTEC, KULeuven, Belgium
% Date: 22-06-2009
% Supervisor: Prof. Moritz Diehl.
%
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ########################################################################
function [ optsol, optval, exitflag, info ] = hc_exam( choose )

% check input parameters
if nargin < 1, choose = 0; end;

% data of problems.
M = 0.894;  % mass of object ( kg ).
I = 0.0125; % moment of inertia (kg*m2).
r = 0.0485; % mistance to the center (m).

% step size of time.
hstep = 0.1;

% lower bound and uper bound of states and controlers.
MAX_BOUND = 2;
lbx = -MAX_BOUND;   % lower bound of state x.
ubx =  MAX_BOUND;   % upper bound of state x.
lbu = -0.121;       % lower bound of control u.
ubu = 0.342;        % upper bound of control u.

% Call init function to get information
[ Q, R, Sf, x0, Tf, Hp ] = hc_getdata( choose );

% ----------------------
% Initialization phase.
% ----------------------
% size of variables w = ( x4, x5, u1, u2 ): nw = 4*n.
n = Hp; nx = 2*Hp; nu = 2*Hp; nw = nx + nu; 

% Lower and upper bound of x4, x5, u1, u2.
lbx4 = lbx*ones( n, 1); ubx4 = ubx*ones( n, 1); 
lbx5 = lbx*ones( n, 1); ubx5 = ubx*ones( n, 1); 
lbu1 = lbu*ones( n, 1); ubu1 = ubu*ones( n, 1); 
lbu2 = lbu*ones( n, 1); ubu2 = ubu*ones( n, 1); 

% Initial point for algorithm.
x04 = lbx + 0.5*( ubx4 - lbx4 );
x05 = lbx + 0.5*( ubx5 - lbx5 );
u01 = lbu + 0.5*( ubu1 - lbu1 );
u02 = lbu + 0.5*( ubu2 - lbu2 );

% define the equality constraints
gfw  = @(x4, x5, u1, u2 )( hc_eqcon( x4, x5, u1, u2, n, x0, hstep, M, I, r ) );
Jgfw = @(x4, x5, u1, u2 )( hc_jaceq( x4, x5, u1, u2, n, x0, hstep, M, I, r ) );

% compute matrix related to objective function
const = r/I;
Mn = hstep*tril( ones( n ), -1 );
en = ones( n, 1 );

% Make the diagonal matrices
dQ1 = sparse( diag( [ Q(1)*ones(n-1,1); Sf(1) ] ) );
dQ2 = sparse( diag( [ Q(2)*ones(n-1,1); Sf(2) ] ) );
dQ3 = sparse( diag( [ Q(3)*ones(n-1,1); Sf(3) ] ) );
dQ4 = sparse( diag( [ Q(4)*ones(n-1,1); Sf(4) ] ) );
dQ5 = sparse( diag( [ Q(5)*ones(n-1,1); Sf(5) ] ) );
dQ6 = sparse( diag( [ Q(6)*ones(n-1,1); Sf(6) ] ) );


% Create the matrices for the objective function (after condensing).
Qx4 = Mn'*dQ1*Mn + dQ4;
qx4 = 2*x0(1)*en'*dQ1*Mn;
q04 = x0(1)*x0(1)*en'*dQ1*en;

Qx5 = Mn'*dQ2*Mn + dQ5;
qx5 = 2*x0(2)*en'*dQ2*Mn;
q05 = x0(2)*x0(2)*en'*dQ2*en;

p03 = x0(3)*en + x0(6)*Mn*en;
Px3 = const*Mn*Mn;

Qu12 = Px3'*dQ3*Px3 + const*const*Mn'*dQ6*Mn;
qu12 = 2*p03'*dQ3*Px3 + 2*x0(6)*const*en'*dQ6*Mn;
q012 = p03'*dQ3*p03 + x0(6)*x0(6)*en'*dQ6*en;
 
% ---------------------------------
% starting solver: SCP_BEGIN.
% ---------------------------------
scp_begin quiet;
    % declare all variables
    scp_variables x4(n) x5(n) u1(n) u2(n) t;
    % set initial values to some related variables
    scp_initvar_set( x4, x04, x5, x05, u1, u01, u2, u02 );
    % set objective function vector.
    scp_objective_set( t, 1 );
    % start declaring convex constraints (omega set )
    convex_begin_declare
        x4'*Qx4*x4 + qx4*x4 + q04 + x5'*Qx5*x5 + qx5*x5 + q05 + ...
        (u1-u2)'*Qu12*(u1-u2) + qu12*(u1-u2) + q012 + ...
        R(1)*u1'*u1 + R(2)*u2'*u2 <= t;
        x4 >= lbx4; x4 <= ubx4;
        x5 >= lbx5; x5 <= ubx5;
        u1 >= lbu1; u1 <= ubu1;
        u2 >= lbu2; u2 <= ubu2;
    convex_end_declare;
    % indicate variables raleated to nonlinear constraints
    nonconvex_variable( x4, x5, u1, u2 );
    % call the function and its jacobian handles.
    nonconvex_declare( gfw, Jgfw );
scp_end;    
% ---------------------------------
% end solver: SCP_END.
% ---------------------------------

% get results.
optsol = [ x4; x5; u1; u2 ];
optval = scp_optval;
info = scp_pinfo.status;
exitflag = scp_exitflag;

% #######################################################################
% End of this file.
% #######################################################################                     