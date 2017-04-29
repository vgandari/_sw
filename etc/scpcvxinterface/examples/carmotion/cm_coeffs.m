%**************************************************************************
% Purpose: This function computes coefficients vector of discrete case. 
% -------  The optimal control problem is transformed to optimization problem.
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
function [ vs, sm, vx0, vy0, vp0, vp1, vp2, vq0, vq1, delta ] ...
           = cm_coeffs( n, s0, st, pars, t, y )

% discrete the path s = [0,1] 
delta = (st-s0)/n;
vs = [s0:delta:st];

% initialization
vp0 = []; vp1 = []; vp2 = []; 
vq0 = []; vq1 = []; 
vx0 = []; vy0 = []; 

% compute value of p0, p1, p2, q0, q1 and vD
for k=1:n+1
    % check for the last point
    if k <= n
        % midle point
        sm(k) = (vs(k) + vs(k+1))/2;  
        ts = sm(k); 
    else
        ts = vs(end); 
    end;
    
    % call the function to compute parameters.
    [tx0, ty0, tp0, tp1, tp2, tq0, tq1] = cm_pathpar( ts, ...
        @cm_pfunc, pars, t, y );

    % scatter to vectors
    vp0 = [ vp0, tp0 ]; 
    vp1 = [ vp1, tp1 ]; 
    vp2 = [ vp2, tp2 ];
    
    vq0 = [ vq0, tq0 ]; 
    vq1 = [ vq1, tq1 ];
    
    vx0 = [ vx0; tx0 ]; 
    vy0 = [ vy0; ty0 ];    
end

%**************************************************************************
% end of the function.
%**************************************************************************