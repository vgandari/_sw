% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: scp_semidefinite - Define a semidefinite cone relation.
% Date: 09-06-2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function z = scp_semidefinite( sx, iscplx )

% check input variables
if nargin < 2, iscplx = false; end;

% make an expression for the semidefinite constraints.
if iscplx, expr =  strcat( 'semidefinite(', mat2str( sx ), ', true )' );
else expr =  strcat( 'semidefinite(', mat2str( sx ), ')' ); end

% create a 'scpexp' object with name 'semidefinite'.
z = scpexp( 'semidefinite' ); 
z = setattr( z, 'expr', expr );
z = setattr( z, 'vexpr', expr );

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++