% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Function: HUBER_CIRC - Circularly symmetric version of the Huber penalty
% Date: 18/06/2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function x = huber_circ( x, DIM, varargin )

error( nargchk( 1, 4, nargin ) );

if isa( x, 'scpexp' )
    if nargin < 2 | isempty( DIM ), 
        sdim = ''; 
    else
        sdim = strcat( ',', mat2str( DIM ) ); 
    end
    
    if nargin < 3
        x.expr  = strcat( 'huber_circ(', x.expr,  sdim, ')' );
        x.vexpr = strcat( 'huber_circ(', x.vexpr, sdim, ')' );
    else
        
        stmp1 = [];
        stmp2 = [];
        
        if isnumeric( varargin{1} )
            stmp1 = strcat( ',', mat2str( varargin{1} ) );
        else
            error( '[SCP] Unknown input 3!' );
        end
        
        if length( varargin ) > 1
            if isnumeric( varargin{2} )
            	stmp2 = strcat( ',', mat2str( varargin{2} ) );
            else
                error( '[SCP] Unknown input 3!' );
            end
        end
        
        x.expr  = strcat( 'huber_circ(', x.expr,  sdim, stmp1, stmp2, ')' );
        x.vexpr = strcat( 'huber_circ(', x.vexpr, sdim, stmp1, stmp2, ')' );
    end
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 by Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++