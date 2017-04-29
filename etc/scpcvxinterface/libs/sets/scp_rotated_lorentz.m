% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: scp_rotated_lorentz - Define a rotated_lorentz cone relation.
% Date: 09-06-2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function z = scp_rotated_lorentz( sx, dim, iscplx )

% check input variables
if nargin < 3, iscplx = false; end;

% make an expression for rotated_lorentz constraints.
if nargin < 2,
   expr =  strcat( 'rotated_lorentz(', mat2str( sx ), ')' );
else
   % if iscplx is true
   if iscplx 
        expr =  strcat( 'rotated_lorentz(', mat2str( sx ), ',', ...
                num2str( dim ), ', true )' );
   else % otherwise.
        expr =  strcat( 'rotated_lorentz(', mat2str( sx ), ',', ...
                num2str( dim ), ')');
   end
end

% create a 'scpexp' object with name 'rotated_lorentz'.
z = scpexp( 'rotated_lorentz' ); 
z = setattr( z, 'expr', expr );
z = setattr( z, 'vexpr', expr );

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++