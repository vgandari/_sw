% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: scp_rotated_complex_lorentz - Define a rotated_complex_lorentz
% cone.
% Date: 09-06-2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function z = scp_rotated_complex_lorentz( sx, dim  )

% make an expression for rotated_complex_lorentz constraints.
if nargin < 2,
   expr =  strcat( 'rotated_complex_lorentz(', mat2str( sx ), ')' );
else
   expr =  strcat( 'rotated_complex_lorentz(', mat2str( sx ), ',', ...
            num2str( dim ), ')');
end

% create a 'scpexp' object with name 'rotated_complex_lorentz'.
z = scpexp( 'rotated_complex_lorentz'); 
z = setattr( z, 'expr', expr );
z = setattr( z, 'vexpr', expr );

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++