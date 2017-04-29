% ########################################################################
% Function: [ ... ] = ft_exam(.) - apply SCP to four-rupe tank problem.
%
% Created by: Quoc Tran Dinh, ESAT/SCD-OPTEC, KULeuven, Belgium
% Date: 22-06-2009
%
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% Supervisor: Prof. Moritz Diehl.
% ########################################################################
function [ optsol, optval, exitflag, pinfo, dinfo ] = ft_exam( x0opt )

% Check input parameters
if nargin < 1, x0opt = 1; end;
if x0opt < 1 || x0opt > 2, error( 'ERROR: Input is 1 or 2!' ); end;

% Data for problem from Johasson model.
A1 = 28; A3 = 28; A2 = 32; A4 = 32; % cm2
a1 = 0.071; a3= 0.071; a2 = 0.057; a4= 0.057; %cm2
kc = 0.5; g  = 981;
% Output matrix
C = kc*[1, 0, 0, 0; 0, 1, 0, 0];

% Lower bound and uper bound of states and controlers.
lbxk = [0; 0; 0; 0];       % lower bound of state x.
ubxk = [20; 20; 20; 20];   % upper bound of state x.
lbuk = [0; 0] ;            % lower bound of control u.
ubuk = 6*[1; 1];           % upper bound of control u.

% Case 1: P- 
if( x0opt == 1 )
    h0 = [ 12.4; 12.7; 1.8; 1.4]; u0 = [ 3; 3];
    k1 = 3.33; k2 = 3.35;
    gamma1 = 0.7; gamma2 = 0.6;
    % Sample time and Horizon 
    Hp = 15;  timestep = 5;
%Case 2: P+    
else
    h0 = [ 12.6; 13.0; 4.8; 4.9 ]; u0 = [ 3.15; 3.15];
    k1 = 3.14; k2 = 3.29;
    gamma1 = 0.43; gamma2 = 0.34;
    % Sample time and Horizon 
    Hp = 10; timestep = 5;
end;

% Compute some temporary parameters.
sqg = sqrt(2*g);
c11 = -a1*sqg/A1; c13 = a3*sqg/A1; c15 = gamma1*k1/A1;
c22 = -a2*sqg/A2; c24 = a4*sqg/A2; c26 = gamma2*k2/A2;
c33 = -a3*sqg/A3; c36 = (1-gamma2)*k2/A3; 
c44 = -a4*sqg/A4; c45 = (1-gamma1)*k1/A4;

% Weight matrix.
lambdaQ = 0.001; lambdaR = 1;
% Compute matrices Q, R, Sf.
Q = lambdaQ*C'*C; R = lambdaR*[1, 0; 0, 1];

% Target
uref  = u0; xref = h0;
% xref = ft_eqpoint( uref, c11, c13, c15, c22, c24, c26, ...
%                    c33, c36, c44, c45 );

% Size of variables w = ( x1, x2, x3, x4, u1, u2 ): nw = 6*n.
nx = 4*Hp; nu = 2*Hp; nw = nx + nu;

% Lower and upper bound of w.
lbx = repmat(lbxk, Hp, 1); ubx = repmat(ubxk, Hp, 1);
lbu = repmat(lbuk, Hp, 1); ubu = repmat(ubuk, Hp, 1);

% Compute Sf and rhof.
[ Sf, rhof ] = ft_terminal( xref, uref, timestep, Q, R,  lbxk, ubxk, ...
                        lbuk, ubuk, A1, A2, A3, A4, a1, a2, a3, a4, ...
                        gamma1, gamma2, k1, k2, g );

% Initial point for system
x0 = [6; 6; 1; 1];

% define the equality constraints
gf4t = @(wx, wu)( ft_eqcon( wx, wu, Hp, x0, timestep, A1, A2, A3, A4, ...
              a1, a2, a3, a4, gamma1, gamma2, g, c11, c13, c15, c22, ...
              c24, c26, c33, c36, c44, c45 ) );
          
% define the jacobian of the equality constraints	
Jgf4t = @(wx, wu)( ft_eqjac( wx, wu, Hp, x0, timestep, A1, A2, A3, A4, ...
                a1, a2, a3, a4, g, gamma1, gamma2, k1, k2 ) );
    
% compute Qw, Rw, wxref and wuref
wxref = repmat( xref, Hp, 1 ); wuref = repmat( uref, Hp, 1 );
Qwt = []; Rwt = []; Cw = [];
for k=1:Hp
    Qwt = blkdiag( Qwt, Q ); Rwt = blkdiag( Rwt, R ); Cw = blkdiag( Cw, C );
end 
Qwt = sparse( Qwt );

% compute the initial point for wt.
wx0 = [x0;  repmat( h0 - 1.0 , Hp-1, 1)];
wu0 = repmat( u0 - 0.5*ones(2,1) , Hp, 1);

% scaling the radius of the terminal constraint.
rhof0 = 1e+2*rhof;

% --------------------------
% Call solver: SCP_BEGIN
% --------------------------
scp_begin quiet;
    % declare variables
    scp_variables wx(nx) wu(nu) t;
    % initial value for variables
    scp_initvar_set( wx, wx0, wu, wu0 );
    % set objective vector with repsect to variables.
    scp_objective_set( t, 1 );
    % declare the convex set 'Omega'.
    convex_begin_declare
        % objective constraint.
        (wx - wxref)'*Qwt*(wx - wxref ) + (wu - wuref)'*Rwt*(wu-wuref) <= t;
        % boundary constraints
        wx >= lbx;  wx <= ubx;
        wu >= lbu;  wu <= ubu;
        % quadratic constraint
        wx(nx-3:nx)'*Sf*wx(nx-3:nx) <= rhof0;
    convex_end_declare;
    % declare the equality constraints
    nonconvex_variable( wx, wu );
    nonconvex_declare( gf4t, Jgf4t );
scp_end
% ---------------------------
% end scp solver: SCP_END
% ---------------------------

% get results.
optsol = [wx; wu];
optval = scp_optval;
pinfo = scp_pinfo;
dinfo = scp_dinfo;
exitflag = scp_exitflag;

% compute output and separate the controls
pinfo.xk = optsol(1:nx);
uk = optsol(nx+1:nw); pinfo.uk = [uk(1:2:end), uk(2:2:end)];
yk = Cw*optsol(1:nx); pinfo.yk = [yk(1:2:end), yk(2:2:end)];

% plot graph.
if isfield( pinfo, 'uk' ) && isfield( pinfo, 'yk' )
    ft_plot( pinfo, timestep );
end

% End of this function
% #######################################################################
% End of this file.
% #######################################################################                     