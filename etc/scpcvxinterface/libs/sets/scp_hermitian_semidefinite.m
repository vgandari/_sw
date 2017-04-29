% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: scp_hermitian_semidefinite - Define a hermitian_semidefinite cone.
% Date: 09-06-2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function z = scp_hermitian_semidefinite( sx )

% make an expression for the hermitian_semidefinite constraints.
expr =  strcat( 'hermitian_semidefinite(', mat2str( sx ), ')' );

% create a 'scpexp' object with name 'hermitian_semidefinite'.
z = scpexp( 'hermitian_semidefinite' ); 
z = setattr( z, 'expr', expr );
z = setattr( z, 'vexpr', expr );

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++