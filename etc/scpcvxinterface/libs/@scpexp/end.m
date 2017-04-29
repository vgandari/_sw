% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: end: Expression of the "end" function
% Date: 09-06-2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function y = end( x, k, n )

if isa( x, 'scpexp' )
    if isreal( k ) && isreal( n )
        sz = getattr( x, 'size' );
        nz = length( sz );
        if k > nz
            y = 1;
        elseif k < n || nz <= n
            y = sz( k );
        else
            y = prod( sz( k : end ) );
        end
    else 
        error( '[SCP] Unknown second and last inputs!' );
    end
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++