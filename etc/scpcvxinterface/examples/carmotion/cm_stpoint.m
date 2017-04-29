%**************************************************************************
% Purpose: Compute starting point for SCP solver
% -------  
% 
% Date: 27/01/2008
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
function [ asol, esol, usol, info ] = cm_stpoint( n, vlba, vuba, ...
           ds0, dst, vp0, vq0, delta, Pmat, Smat, vqe, ef, optpars ) 

%----------------------
% compute matrix Dk
%----------------------
tPmat = [zeros(1,n); Pmat; vqe'];
Dmat = []; 
dvec = [];
for k=1:n
    % norm of vector p0.
    nvp0 = sqrt( vp0(1,k)*vp0(1,k) + vp0(2,k)*vp0(2,k) ); 
    
    % compute matrix D0k
    D0k = [vp0(1,k), vp0(2,k); vp0(2,k), -vp0(1,k)]/nvp0;
    
    % compute the first component
    tp1 = vp0(1,k)*Smat(k,:) + 0.5*vq0(1,k)*(tPmat(k,:)+tPmat(k+1,:));
    tp2 = vp0(2,k)*Smat(k,:) + 0.5*vq0(2,k)*(tPmat(k,:)+tPmat(k+1,:));
    
    % combine.
    dk = D0k*[tp1; tp2];
    
    dvec = [dvec; ds0*ds0*D0k*vq0(:,k)];
    Dmat = [Dmat; dk];
end;

% make vector for the objective function
cvec_v = 2*delta*ones(n,1);

% ---------------------------------
% start scp_cvx here : SCP_BEGIN
% ---------------------------------
scp_begin quiet;
    % declare variables
    scp_variables ec(n) u(n-1) v(n);
    % set objective function vector
    scp_objective_set( v, cvec_v );
    % start the convex set
    convex_begin_declare
        % linear constraints
        vqe'*ec == dst*dst-ds0*ds0;
        Pmat*ec + ds0*ds0*ef >= 0;
        Dmat*ec + dvec <= vuba;
        Dmat*ec + dvec >= vlba;
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
    convex_end_declare;
    % stop the convex set
scp_end
% ---------------------------------
% stop scp_cvx here : SCP_END
% ---------------------------------

% Get solution and optimal value
info = scp_pinfo;

%----------------------
% cover all variables
%----------------------
esol = ec;
% compute asol
asol = Dmat*esol + dvec;
% compute usol.
usol = zeros( n+1, 1);

%**************************************************************************
% End of this function
%**************************************************************************