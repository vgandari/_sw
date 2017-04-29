% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: scpvar - create a variable class for AUTOMATIC DIFFERENTIATION
% Date: 20-06-2009
% Created by: Quoc Tran Dinh, PhD student at ESAT/SCD and OPTEC, 
% KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function x = scpvar( nsz, val, diff )

% check inputs
if nargin < 3, diff = [];     end
if nargin < 2, val  = [];     end
if nargin < 1, nsz = [1, 0]; end
if isempty( nsz ), nsz = [1, 0]; 
else
    if ~isempty( val ) & size( val ) ~= nsz, nsz = size( val ); end
    if length( val ) == prod( nsz ) % this is a vector
        val  = val(:);            % make sure that this is a column vector.
        diff = eye( length( val ) );
    else
        diff = ones( nsz );
    end
end

% create a scpvar class
x = class( struct( 'size', nsz, 'val', val, 'diff', diff ), 'scpvar' );

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++