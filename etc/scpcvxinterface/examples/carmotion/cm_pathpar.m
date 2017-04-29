%**************************************************************************
% Purpose: This function computes coefficients of dynamic system in 
% -------  the optimal control problem for car motion problem.
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
function [ x0, y0, p0, p1, p2, q0, q1 ] = cm_pathpar( s, pfunc, pars, t, y  )

% compute value of function
[ x0, y0, dx, dy, d2x, d2y, d3x, d3y ] = feval( pfunc, s, pars, t, y );

% norm of dx*dx + dy*dy
square = dx*dx + dy*dy;
normns = sqrt( square );

% the angle theta
costheta = dx/normns;
sintheta = dy/normns;

% compute derivative of theta
dtheta  = (dx*d2y - d2x*dy)/square;
d2theta = (dx*d3y - d3x*dy)/square ...
        - 2*(dx*d2y-d2x*dy)*(dx*d2x+dy*d2y)/(square*square);

% compute parameters p0, p1, p2.
p0 = [dx; dy];
p1 = dtheta*[costheta; sintheta];
p2 = [sintheta; -costheta];

% compute parameter q0, q1.
q0 = [d2x; d2y];
q1 = dtheta*dtheta*[-sintheta; costheta] + d2theta*[costheta; sintheta];

%**************************************************************************
% End of the function.
%**************************************************************************