%**************************************************************************
% Purpose: Compute coordinate of variables
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
function [ time, lbx, lby, ubx, uby, xpos, ypos ] = cm_coordinate( ...
           n, x0, y0, bt, ft, p2, bmin, bmax, delta, vs, s0, st )

% length of variables
nsz = length( x0 );
vs0 = vs(1:nsz);
ts = s0:0.005:st;

% compute the coordinate of the car
for k=1:nsz
    
    % lower bound of the road
    lbx(k,1)  = x0(k,1) + bmin*p2(1,k);
    lby(k,1)  = y0(k,1) + bmin*p2(2,k);
    
    % upper bound of the road
    ubx(k,1)  = x0(k,1) + bmax*p2(1,k);
    uby(k,1)  = y0(k,1) + bmax*p2(2,k);
    
    % reference path
    xpos(k,1) = x0(k,1) + bt(k,1)*p2(1,k);
    ypos(k,1) = y0(k,1) + bt(k,1)*p2(2,k);
end

% cubic spline for lbx, lby
pcoefs = spline( vs0, lbx );
lbx = ppval( pcoefs, ts );
pcoefs = spline( vs0, lby );
lby = ppval( pcoefs, ts );

% cubic spline for ubx, uby
pcoefs = spline( vs0, ubx );
ubx = ppval(pcoefs, ts );
pcoefs = spline( vs0, uby );
uby = ppval(pcoefs, ts );

% cubic spline for xpos, ypos
pcoefs = spline( vs0, xpos );
xpos = ppval( pcoefs, ts );
pcoefs = spline( vs0, ypos );
ypos = ppval( pcoefs, ts );

% compute time
time(1,1) = 0;
for k=1:nsz-1
    addtime = 2*delta/(sqrt( ft(k,1) ) + sqrt( ft(k+1,1)));
    time(k+1,1) = time(k,1) + addtime;
end;
%**************************************************************************
% End of this function.
%**************************************************************************