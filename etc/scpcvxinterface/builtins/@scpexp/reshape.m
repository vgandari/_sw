% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: reshape: Expression of the "reshape" function
% Date: 09-06-2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function x = reshape( x, varargin )

error( nargchk( 3, +inf, nargin ) );
if isa( x, 'scpexp' )
    tmp1 = varargin{1};
    tmp2 = varargin{2};
    if ~isnumeric( tmp1 ) || ~isnumeric( tmp2 )
        error( '[SCP] Unknown inputs!' );
    end
    stmp = strcat( mat2str( tmp1 ), ',', mat2str( tmp2 ) );
    for k=3:length( varargin )
        if isnumeric( varargin{k} )
            stmp = strcat( stmp, ',', mat2str( varargin{k} ) );
        end
    end
    x.expr  = strcat( 'reshape(', x.expr, ',', stmp, ')' );
    x.vexpr = strcat( 'reshape(', x.vexpr, ',', stmp, ')' );
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 by Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++