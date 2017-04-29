%**************************************************************************
% Purpose: This function performs car motion modelling
% -------  

% Date: 27/01/2008
% Created by: Quoc Tran Dinh, OPTEC-SCD, ESAT, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
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
%  Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
%  See the file COPYING.txt for full copyright information.
%  The command 'scp_where' will show where this file is located.
%**************************************************************************

% environment setting
%clc;
warning off;
%clear all;
close all;
format short;

% call info procedure to start program
cm_info; 
fprintf('Start algorithm ... \n');
startcpu = cputime;

% get default parameters
fprintf('-> check parameters ... \n');
if ~exist('options','var'), options = cm_defopt(); end;

% check parameters
options = cm_checkopt( options );

%*****************************************
% input parameters
%*****************************************
nsz = options.nsize;
prob = options.prob;  
xsp = []; ysp = [];
if prob == 7, drawpath; end;
bmin = options.bmin; bmax = options.bmax;
amin = options.amin; amax = options.amax;
s0  = 0;  st  = 1;
ds0 = 0;  dst = 0;
b0  = 0;  bn  = 0;
%*****************************************
% end of input parameters
%*****************************************

% compute size of variables
na = 2*nsz;
nu = nsz + 1;
ne = nsz;

% compute the coeficients
fprintf('-> compute coefficients of nonlinear equality constraints ... \n');
[vs0, vsm0, vx0, vy0, vp0, vp1, vp2, vq0, vq1, delta] = cm_coeffs( ...
                                             nsz, s0, st, prob, xsp, ysp );

% compute transform matrices for condensing phase
fprintf('-> condensing dynamic system ... \n');
[ Mmat, Nmat, Pmat, Q1mat, Q2mat, Rmat, Smat, vqe, vru, eb, ef ] ...
= cm_condensing( nsz, delta );

% compute matrices for regularization term
Qa = eye( na );
Qu = eye( nu );
Qe = eye( ne );
rpara = options.rhoa;
rparu = options.rhou;
rpare = options.rhoe;

% call solver.
fprintf('-> start solver ... \n' );
[ asol, usol, esol, optval, output ] = cm_solver( ...
           nsz, na, nu, ne, amin, amax, bmin, bmax, ...
           s0, st, ds0, dst, b0, bn, ...
           vs0, vx0, vy0, vp0, vp1, vp2, vq0, vq1, delta, ...
           Mmat, Nmat, Pmat, Rmat, Smat, vqe, vru, eb, ef, ...
           Qa, Qu, Qe, rpara, rparu, rpare, options ); 
                     
% compute dependent solutions.
bsol  = [b0; b0*eb + Nmat*usol; bn];
csol  = Mmat*usol;
dsol  = usol(2:nsz+1,1);
fsol  = [ds0*ds0; ds0*ds0*ef + Pmat*esol; dst*dst];
a1sol = asol(1:2:end,1);
a2sol = asol(2:2:end,1);

% keep infomation of problem
output.size = [ 4*nsz+1, 2*nsz+1, 7*nsz ];

% cpu time
cputimeused = cputime - startcpu;

% print results
fprintf(' + Size of problem: psize = [%d, %d, %d]\n', output.size );
fprintf(' + Optimal value: optval = %-5.6d\n', optval );
fprintf(' + Number of iterations: iter = %d\n', output.iter );
fprintf(' + CPU Time: cputime = %5.6f s\n', cputimeused );
if output.exitflag  >= 0, fprintf(' +++++ SUCESS! +++++ \n'); 
else fprintf(' +++++ UNSUCESS! +++++ \n'); end;

% compute the coordinate and plot position of the car
fprintf('-> compute coordinate for trajectory ... \n');
[ timet, lbx, lby, ubx, uby, xpos, ypos ] = cm_coordinate( ...
  nsz, vx0, vy0, bsol, fsol, vp2, bmin, bmax, delta, vs0, s0, st );

% compute acceleration and velocity
[ vv, va ] = cm_vacomp( nsz, Mmat, Nmat, Rmat, delta, vp0, vp1, vp2, ...
                            asol, csol, dsol, fsol, s0 );

% create pictures.
cm_plot( lbx, lby, ubx, uby, xpos, ypos, timet, ...
                  vs0, vsm0, a1sol, a2sol, bsol, csol, dsol, esol, fsol, ...
                  delta, vv, va, options );
fprintf('Finish!\n');          
%**************************************************************************
% End of this module.
%**************************************************************************