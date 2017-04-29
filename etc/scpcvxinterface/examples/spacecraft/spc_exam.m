%*************************************************************************
% Example: Rigid Asymmetric Spacecraft.
%
%*************************************************************************
function [xsol, usol, optval, exitflag, pinfo, dinfo ] = spc_exam( ...
          Hc, caseopt )

% option for case 1 or 2.
if nargin < 2, caseopt = 1; end
if nargin < 1, Hc = 100; end;

% control variables

%--------------------------------------------------
% parameter for problem.
%--------------------------------------------------
% inertia moments
I1 = 86.24; I2 = 85.07; I3 = 113.59;
% initial point
x0 = [0.01; 0.005; 0.001];
% Time horizon
T = 100;
% Number of descrete nodes
n = Hc;
% Sample time
h = T/n;

%--------------------------------------------------
% parameter for solver
%--------------------------------------------------
nx = 3*n;
nu = 3*n;
nw = 6*n;

%--------------------------------------------------
% parameter for terminal constraint
%--------------------------------------------------
if caseopt == 1
   [ Sf, rhof ] = terminal_matrix( I1, I2, I3, h );
   rhof = 1e-6*rhof;
end;

%--------------------------------------------------
% initial point
%--------------------------------------------------
xv0 = repmat( [0.01; 0.005; 0.001], n, 1);
uv0 = repmat( [0; 0; 0], n, 1 );

% compute vector vak
tk = 0;
for k=1:n
	tk = tk + h;
    vak(k, 1) = 5*1e-6*tk*tk - 5*1e-4*tk + 0.016;
end
           
%--------------------------------------------------
% call the SCP-solver
%--------------------------------------------------
scp_set_ws( 'TolX',   1e-7 );
scp_set_ws( 'TolF',   1e-7 );
scp_set_ws( 'TolCon', 1e-7 );
scp_set_ws( 'JacbCon', 'finite-diff' );
%scp_set_ws( 'cvxSolver', 'sedumi' );

scp_begin quiet
        scp_variables wx(nx) wu(nu) s;
        scp_initvar_set( wx, xv0, wu, uv0 );
        scp_objective_set( s, 1 );
        convex_begin_declare
            % quadratic objective function is removed here using slack
            % variable s.
            0.5*wu'*wu <= s;   
            % additional constraint
            for k=1:n
                wx(3*k-2) <= vak(k);
            end
            % terminal constraint.
            if caseopt == 1
                wx(end-2:end)'*Sf*wx(end-2:end) <= rhof;
            else
                wx(end-2:end) == 0;
            end
        convex_end_declare
        % nonconvex constraints: g(wx, wu) == 0.
        nonconvex_variable( wx, wu );
        %nonconvex_declare( @eval_g, @eval_jacg, n, h, x0, I1, I2, I3 );
        nonconvex_declare( @eval_g, n, h, x0, I1, I2, I3 );
scp_end

%--------------------------------------------------
% separate the results
%--------------------------------------------------
xsol     = wx;
usol     = wu;
optval   = scp_optval;
pinfo    = scp_pinfo;
dinfo    = scp_dinfo;
exitflag = scp_exitflag;

%--------------------------------------------------
% create the figure
%--------------------------------------------------
createfigureForOutput( xsol, usol, x0, 0, T, n ); 
        
%*************************************************************************
% Define descrete dynamic system of the rigid asymmetric spacecraft.
% Function: [...] = eval_g(...)
%*************************************************************************
function gval = eval_g( x, u, n, h, x0, I1, I2, I3 )

% temporary values
c11  = h*(I3-I2)/I1; c12 = h/I1;
c21  = h*(I1-I3)/I2; c22 = h/I2;
c31  = h*(I2-I1)/I3; c32 = h/I3;

% compute value of the functions
gval(1, 1) = x(1) - x0(1) + c11*x0(2)*x0(3) - c12*u(1);
gval(2, 1) = x(2) - x0(2) + c21*x0(1)*x0(3) - c22*u(2);
gval(3, 1) = x(3) - x0(3) + c31*x0(1)*x0(2) - c32*u(3);

for k=1:n-1
    gval(3*k+1, 1) = x(3*k+1) - x(3*k-2) + c11*x(3*k-1)*x(3*k)   - c12*u(3*k+1);
    gval(3*k+2, 1) = x(3*k+2) - x(3*k-1) + c21*x(3*k-2)*x(3*k)   - c22*u(3*k+2);
    gval(3*k+3, 1) = x(3*k+3) - x(3*k)   + c31*x(3*k-2)*x(3*k-1) - c32*u(3*k+3);
end

% end of this function
%*************************************************************************
% Function: [...] = eval_jacg(...) compute jacobian of g funciton
%*************************************************************************
function Jgval = eval_jacg( x, u, n, h, x0, I1, I2, I3 )

% temporary values
c11  = h*(I3-I2)/I1; c12 = h/I1;
c21  = h*(I1-I3)/I2; c22 = h/I2;
c31  = h*(I2-I1)/I3; c32 = h/I3;

% compute its jacobian.
Jgx  = zeros( 3*n, 3*n ); % with respect to w
Jgu  = Jgx;               % with respect to u.

% the first line
Jgx(1,1) = 1; Jgu(1,1) = -c12;
Jgx(2,2) = 1; Jgu(2,2) = -c22;
Jgx(3,3) = 1; Jgu(3,3) = -c32;

% the remainder
for k=1:n-1
   % the first line of Jgx
   Jgx(3*k+1, 3*k+1) =  1;           Jgx(3*k+1, 3*k-2) = -1; 
   Jgx(3*k+1, 3*k-1) = c11*x(3*k);   Jgx(3*k+1, 3*k) = c11*x(3*k-1);

   % the second line of Jgx
   Jgx(3*k+2, 3*k+2) =  1;           Jgx(3*k+2, 3*k-1) = -1; 
   Jgx(3*k+2, 3*k-2) = c21*x(3*k);   Jgx(3*k+2, 3*k) = c21*x(3*k-2);

   % the third line of Jgx
   Jgx(3*k+3, 3*k+3) =  1;           Jgx(3*k+3, 3*k) = -1; 
   Jgx(3*k+3, 3*k-1) = c31*x(3*k-2); Jgx(3*k+3, 3*k-2) = c31*x(3*k-1);

   % with respect to u.
   Jgu(3*k+1, 3*k+1) = -c12;
   Jgu(3*k+2, 3*k+2) = -c22;
   Jgu(3*k+3, 3*k+3) = -c32;
end

% combine together.
Jgval = [ Jgx, Jgu ];

%*************************************************************************
% Function: terminal_matrix - compute terminal constraints.
%*************************************************************************
function [ Sf, rhof ] = terminal_matrix( I1, I2, I3, h )

% temporary variables
c11 = -(I3-I2)/I1; c12 = 1/I1;
c21 = -(I1-I3)/I2; c22 = 1/I2;
c31 = -(I2-I1)/I3; c32 = 1/I3;

% the right hand side function of: x' = f(x, u)
funf = @( wu )( [ c11*wu(2)*wu(3) + c12*wu(4); ...
                  c21*wu(1)*wu(3) + c22*wu(5); ...
                  c31*wu(1)*wu(2) + c32*wu(6) ] );

% derivative of f with respect to w.
dfw  = @(wu)( [ 0, c11*wu(3), c11*wu(2); c21*wu(3), 0, c21*wu(1); ...
                c31*wu(2), c31*wu(1), 0 ] );
            
% derivative of f with respect to u.
dfu  = @(wu)( [c12, 0, 0; 0, c22, 0; 0, 0, c32 ] );

% compute equilibrium point (solve f(x,u) = 0).
w0 = [0.01; 0.005; 0.001; 0; 0; 0];
wuf = fsolve( funf, w0 );

% values of derivatives at the equilibrium point.
Dfx = dfw(wuf);
Dfu = dfu(wuf);

% Recalculate the discrete matrix.
Ex = eye(3);
Ae = ( Ex + h*Dfx );
Be = h*Dfu;

% Compute Sf and feedback control K: u = -Kx.
%[ K, Sf, E ] = dlqr( Ae, Be, zeros(3, 3), eye(3, 3) );
[ K, Sf, E ] = dlqr( Ae, Be, 0.5*eye(3, 3), eye(3, 3) );

% compute rho by getting maximum eigenvalue of Sf then multilying by 1e-6.
rhof = max(eig(Sf));

%**************************************************************************
% Function: Plot graphics of problem.
%**************************************************************************
function createfigureForOutput( xsol, usol, x0, t0, T, n )

%---------------------
% compute soltions
%---------------------
% verlocities x1, x2 and x3. 
x1sol = [x0(1); xsol(1:3:end)];
x2sol = [x0(2); xsol(2:3:end)];
x3sol = [x0(3); xsol(3:3:end)];
nx = min( [ length(x1sol), length(x2sol), length(x3sol) ] );

% controlers
u1sol = usol(1:3:end);
u2sol = usol(2:3:end);
u3sol = usol(3:3:end);
nu = min( [ length(u1sol), length(u2sol), length(u3sol) ] );

% compute t0, t1, ..., t_f.
h = (T-t0)/n;
tstep = [t0:h:T];

% using spline to make curvature smooth.
mint = min(tstep); maxt = max(tstep);
small_step = 0.005;
splt = mint:small_step: maxt;

% plot the verlocities.
% x1 cordinate
px1coeff = spline( tstep(1:nx), x1sol );
splx1  = ppval( px1coeff, splt );
% x2 cordinate
px2coeff = spline( tstep(1:nx), x2sol );
splx2  = ppval( px2coeff, splt );
% x3 cordinate
px3coeff = spline( tstep(1:nx), x3sol );
splx3  = ppval( px3coeff, splt );

% plot figure for verlocities
figure(1);
grid on;
plot( splt, splx1, 'r' );
hold on;
plot( splt, splx2, 'b' );
hold on;
plot( splt, splx3, 'm' );
% set cordinate label
xlabel('time[s]'); ylabel('velocities');
axis tight; as = axis; axis([as(1) as(2) as(3) as(4)*1.05]);

% plot the controlers.
% u1 cordinate
pu1coeff = spline( tstep(1:nu), u1sol );
splu1  = ppval( pu1coeff, splt );
% u2 cordinate
pu2coeff = spline( tstep(1:nu), u2sol );
splu2  = ppval( pu2coeff, splt );
% u3 cordinate
pu3coeff = spline( tstep(1:nu), u3sol );
splu3  = ppval( pu3coeff, splt );

% plot the for x1.
nt = 300;
lbt = 10; ubt = 90;

for k=1:nt
    tk(k,1) = lbt + k*(ubt-lbt)/nt;
    ak(k,1) = 5*1e-6*tk(k)*tk(k) - 5*1e-4*tk(k) + 0.016;
end

hold on;
plot(tk , ak, 'k--' ); 
    
% plot figure for controlers
figure(2);
grid on;
plot( splt, splu1, 'r' );
hold on;
plot( splt, splu2, 'b' );
hold on;
plot( splt, splu3, 'm' );
% set cordinate label
xlabel('time[s]'); ylabel('controlers');
axis tight; as = axis; axis([as(1) as(2) as(3) as(4)*1.05]);

%*************************************************************************
% End of this file.
%%*************************************************************************