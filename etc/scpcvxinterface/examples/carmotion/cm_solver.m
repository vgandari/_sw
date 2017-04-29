%**************************************************************************
% FUNCTION: [ ... ] = scp_cvx_solver( ... )
% Purpose: Call scp_cvx solver to solve the problem.
% -------  
% Date: 21-06-2009.
% Quoc Tran Dinh, OPTEC-SCD, ESAT, KULeuven, Belgium.
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%**************************************************************************
function [ asol, usol, esol, optval, info ] = cm_solver( ...
           n, na, nu, ne, amin, amax, bmin, bmax, ...
           s0, st, ds0, dst, b0, bn, ...
           vs0, vx0, vy0, vp0, vp1, vp2, vq0, vq1, delta, ...
           Mmat, Nmat, Pmat, Rmat, Smat, vqe, vru, eb, ef, ...
           Qa, Qu, Qe, rpara, rparu, rpare, opts ) 

% check input variables
if nargin < 39, opts = defopt(); end;
    
% compute right hand sides
rhsq = dst*dst - ds0*ds0;
rhsr = bn - b0;
rhsp = -ds0*ds0*ef;

% compute lower bound and upper bound of constraints.
vlba = repmat( amin, n, 1 );
vuba = repmat( amax, n, 1 );
vlbb = repmat( bmin, n-1, 1 ) - b0;
vubb = repmat( bmax, n-1, 1 ) - b0;

% find starting point
if ~strcmp( opts.isprint, 'off' )
    fprintf('-> compute initial guess point ... \n' );
end
[ a0, e0, u0 ] = cm_stpoint( n, vlba, vuba, ...
           ds0, dst, vp0, vq0, delta, Pmat, Smat, vqe, ef, opts ); 

% initialization.
if ~strcmp( opts.isprint, 'off' )
    fprintf('-> initialize for the SCP solver ... \n');
end

% size of the 'wx' variable.
nw = na+nu+ne;

% define equality constraints - output ([ gvalx, Jgax, Jgux, Jgex ])
gfw  =  @( ac, uc, ec )( cm_geq( n, ac, uc, ec, ...
        vp0, vp1, vp2, vq0, vq1, Mmat, Nmat, Pmat, Rmat, Smat, ...
        vqe, ds0, b0, delta ) );

% define the objective vector
cvec_v = 2*delta*ones(n,1);

% call solver
if ~strcmp( opts.isprint, 'off' )
    fprintf('-> start SCP solver ... \n');
end

%--------------------------------
% solver starts here: SCP_BEGIN
%--------------------------------
scp_begin quiet;
    % declare variables
    scp_variables ac(na) uc(nu) ec(ne) u(n-1) v(n); 
    % initialize variables
    scp_initvar_set( ac, a0, uc, u0, ec, e0 );
    % set objective vector to scp_solver.
    scp_objective_set( v, cvec_v );
    % declare the convex set 'Omega'.
    convex_begin_declare
        % linear constraints.
        vqe'*ec == rhsq; vru'*uc == rhsr; Pmat*ec >= rhsp;
        % boundary of ux
        Nmat*uc <= vubb; Nmat*uc >= vlbb;
        % boundary of ax
        ac <= vuba; ac >= vlba; 
        % the second order cone 
        for k=1:n-1
            {[ 2*u(k); Pmat(k,:)*ec + ds0*ds0 - 1 ], ...
               Pmat(k,:)*ec + ds0*ds0 + 1 } == scp_lorentz(2);
        end
        % the first row
        {[2; u(1) - v(1) + ds0 ], u(1) + v(1) + ds0 }  == scp_lorentz(2);
        % the row 2 to n-2
        for k=1:n-2
            { [ 2; u(k) + u(k+1) - v(k+1)], u(k) + u(k+1) + v(k+1) } ...
                == scp_lorentz(2);
        end
        % the last row.
        { [ 2; u(n-1) - v(n) + dst ], u(n-1) + v(n) + dst } == scp_lorentz(2);
    convex_end_declare
    % indicate variables ralated to non-convex constraints
    nonconvex_variable( ac, uc, ec );
    % call the non-convex constraints: g(x) == 0.
    nonconvex_declare( gfw );
scp_end
%---------------------------------
% solver stops here: SCP_END
%---------------------------------
    
% finish iterative loop
if ~strcmp( opts.isprint, 'off' )
    fprintf('%s\n', repmat('=', 1, 105 ) );
end

% Get solution and optimal value
optval = scp_optval;
pinfo = scp_pinfo;
dinfo = scp_dinfo;
exitflag = scp_exitflag;

% asign to outputs.
asol = ac;
usol = uc;
esol = ec;

% keep information of method
info.iter = pinfo.niter;
info.exitflag = exitflag;

% keep optimality condition
info.LagDerivative = pinfo.optimalError;
info.EqConViol = pinfo.feasError;
info.InEqConViol = [];

%**************************************************************************
% End of this function
%**************************************************************************