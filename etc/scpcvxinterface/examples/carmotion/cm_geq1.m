%**************************************************************************
% Purpose: Compute value of nonlinear equality constraints and its 
% -------  jacobian matrix.
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
function varargout = cm_geq1( n, ...
           ac, uc, ec, ...                   % current value of variables
           vp0, vp1, vp2, vq0, vq1, ...      % value of coefficients
           Mmat, Nmat, Pmat, Rmat, Smat, ... % condensing matrices
           vqe, ds0, b0, delta )             % initial value 

% added the vector to matricies
tPmat = [zeros(1,n); Pmat; vqe'];
tNmat = [zeros(1,n+1); Nmat];

% initialization
gval   = [];
Jgaval = []; Jguval = []; Jgeval = [];

% compute value of equality constraints
for k=1:n
    
    % intermediate variables
    p21 = 0.5*delta*vp1(1,k) + vp2(1,k);
    p22 = 0.5*delta*vp1(2,k) + vp2(2,k);
    
    p31 = 0.125*delta*delta*vp1(1,k) + 0.5*delta*vp2(1,k);
    p32 = 0.125*delta*delta*vp1(2,k) + 0.5*delta*vp2(2,k);
    
    q21 = 0.5*delta*vq1(1,k) + 2*vp1(1,k);
    q22 = 0.5*delta*vq1(2,k) + 2*vp1(2,k);
    
    q31 = 0.125*delta*delta*vq1(1,k) + delta*vp1(1,k) + vp2(1,k);
    q32 = 0.125*delta*delta*vq1(2,k) + delta*vp1(2,k) + vp2(2,k);
    
    % compute intermediate coefficients
    tp0k  = vp0(:,k) + b0*vp1(:,k);
        
    tp1k1 = vp1(1,k)*tNmat(k, :) + p21*Mmat(k, :) + p31*Rmat(k,:);
    tp1k2 = vp1(2,k)*tNmat(k, :) + p22*Mmat(k, :) + p32*Rmat(k,:);
    
    tq0k  = vq0(:,k) + b0*vq1(:,1);
    
    tq1k1 = vq1(1,k)*tNmat(k,:) + q21*Mmat(k,:) + q31*Rmat(k,:);
    tq1k2 = vq1(2,k)*tNmat(k,:) + q22*Mmat(k,:) + q32*Rmat(k,:);
    
    % free coefficient
    h0k1    = ds0*ds0*tq0k(1,1);
    h0k2    = ds0*ds0*tq0k(2,1);
    
    % coefficient of e
    h1k1 = tp0k(1,1)*Smat(k,:) + 0.5*tq0k(1,1)*(tPmat(k,:) + tPmat(k+1,:));
    h1k2 = tp0k(2,1)*Smat(k,:) + 0.5*tq0k(2,1)*(tPmat(k,:) + tPmat(k+1,:));
    
    % coefficient of u
    h2k1 = ds0*ds0*tq1k1;
    h2k2 = ds0*ds0*tq1k2;
    
    % coefficient of u'He
    Hk1    = tp1k1'*Smat(k,:) + 0.5*tq1k1'*(tPmat(k,:) + tPmat(k+1,:));
    Hk2    = tp1k2'*Smat(k,:) + 0.5*tq1k2'*(tPmat(k,:) + tPmat(k+1,:));
    
    % compute function rho(u)
    rho1k = tp0k(1,1) + tp1k1*uc;
    rho2k = tp0k(2,1) + tp1k2*uc;
    
    % square of rhok
    sqrtrhok = sqrt ( rho1k*rho1k + rho2k*rho2k );
    
    % compute function sigmak(u, e) 
    sigma1k = h0k1 + h1k1*ec + h2k1*uc + uc'*Hk1*ec;
    sigma2k = h0k2 + h1k2*ec + h2k2*uc + uc'*Hk2*ec;
    
    % values of function gk at the current points
    gk1 = rho1k*sigma1k + rho2k*sigma2k - ac(2*k-1)*sqrtrhok;
    gk2 = rho2k*sigma1k - rho1k*sigma2k - ac(2*k  )*sqrtrhok;
    
    % combine in vector.
    gval = [ gval; gk1; gk2 ];
    
    % value of jacobian
    Jrho1u    = tp1k1;
    Jrho2u    = tp1k2;
    Jsigma1uk = h2k1 + (Hk1*ec)';
    Jsigma2uk = h2k2 + (Hk2*ec)';
    Jsigma1ek = h1k1 + uc'*Hk1;
    Jsigma2ek = h1k2 + uc'*Hk2;

    % compute Jacobian of g1
    Jg1uk = sigma1k*Jrho1u + rho1k*Jsigma1uk ...
          + sigma2k*Jrho2u + rho2k*Jsigma2uk ...
          - ac(2*k-1)*( rho1k*Jrho1u + rho2k*Jrho2u ) / sqrtrhok;

    Jg1ek = rho1k*Jsigma1ek + rho2k*Jsigma2ek;  

    % compute Jacobian of g2
    Jg2uk = sigma1k*Jrho2u + rho2k*Jsigma1uk ...
          - sigma2k*Jrho1u - rho1k*Jsigma2uk ...
          - ac(2*k)*( rho1k*Jrho1u + rho2k*Jrho2u ) / sqrtrhok;

    Jg2ek = rho2k*Jsigma1ek - rho1k*Jsigma2ek;  

    % combine in matrix
    Jgaval = [Jgaval; -sqrtrhok; -sqrtrhok ];
    Jguval = [ Jguval; Jg1uk; Jg2uk ];
    Jgeval = [ Jgeval; Jg1ek; Jg2ek ];

end

varargout{1} = gval;
varargout{2} = sparse( [ diag( Jgaval), Jguval, Jgeval, zeros( 2*n, 2*n-1 ) ] );    

%**************************************************************************
% End of this function.
%**************************************************************************