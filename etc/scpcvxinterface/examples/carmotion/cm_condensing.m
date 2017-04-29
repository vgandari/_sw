%**************************************************************************
% Purpose: Compute all matrices and vectors to carry out condensing 
% -------  phase. This technique can reduce the size of large scale 
%          optimization problem.
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
function [ Mmat, Nmat, Pmat, Q1mat, Q2mat, Rmat, Smat, vqe, vru, eb, ef ] ...
         = cm_condensing( n, delta )

% compute matrices R and S
Smat = eye(n);
Rmat = [ zeros(n,1), Smat ];

% compute matries M, Q, N, P and vector q
Mmat = [ ones(n, 1), delta*tril( ones(n), -1 ) ];
Q1mat = [ delta*tril(ones(n-1)), zeros(n-1,1) ];
Q2mat = [ 0.5*delta*delta*tril(ones(n-1)), zeros(n-1,1) ];
Nmat = Q1mat*Mmat + Q2mat*Rmat;
Pmat = [ 2*delta*tril( ones(n-1) ), zeros(n-1,1)];

% create some vector
eb = ones( n-1, 1 );
ef = ones( n-1, 1 );

% compute vector r.
vru = delta*Mmat'*ones(n,1) + 0.5*delta*delta*Rmat'*ones(n,1);

% compute vector q.
vqe = 2*delta*ones(n,1);

%**************************************************************************
% End of this function.
%**************************************************************************