%**************************************************************************
% Purpose: Compute velocity and acceleration
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
function [ vvc, vac ] = cm_vacomp( n, Mmat, Nmat, Rmat, delta, ...
                        vp0, vp1, vp2, ac, cc, dc, fc, b0 )

% create vector u.
uc = [cc(1,1); dc];

% create matrices tNmat
tNmat = [zeros(1,n+1); Nmat];

% initial a and v.
vac = []; vvc = [];

% compute matrix D
for k=1:n
    
     % intermediate variables
    p21 = 0.5*delta*vp1(1,k) + vp2(1,k);
    p22 = 0.5*delta*vp1(2,k) + vp2(2,k);
    
    p31 = 0.125*delta*delta*vp1(1,k) + 0.5*delta*vp2(1,k);
    p32 = 0.125*delta*delta*vp1(2,k) + 0.5*delta*vp2(2,k);
        
    % compute intermediate coefficients
    tp0k  = vp0(:,k) + b0*vp1(:,k);
        
    tp1k1 = vp1(1,k)*tNmat(k, :) + p21*Mmat(k, :) + p31*Rmat(k,:);
    tp1k2 = vp1(2,k)*tNmat(k, :) + p22*Mmat(k, :) + p32*Rmat(k,:);
      
    % compute function sigma(u)
    sigma1k = tp0k(1,1) + tp1k1*uc;
    sigma2k = tp0k(2,1) + tp1k2*uc;
    
    % square of rhok
    sqrtrhok = sqrt ( sigma1k*sigma1k + sigma2k*sigma2k );
    
    % compute matrix Dk
    Dmat = [sigma1k, sigma2k; sigma2k, -sigma1k]/sqrtrhok;
    
    % compute vector ak
    tak = ac(2*k-1:2*k,1);
    vac = [vac; Dmat'*tak];
    
    % compute velocity.
    tv1k = 0.5*sigma1k*sqrt(fc(k,1)+fc(k+1,1));
    tv2k = 0.5*sigma2k*sqrt(fc(k,1)+fc(k+1,1));
    vvc = [vvc; tv1k; tv2k];
end

%**************************************************************************
% End of this function.
%**************************************************************************