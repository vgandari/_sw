% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: GEO_MEAN - Geometric mean
% Date: 18/06/2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function x = geo_mean( x, dim, w, ismap, cmode )

error( nargchk( 1, 5, nargin ) );

if isa( x, 'scpexp' )
    if nargin < 5, cmode = ''; end
    if nargin < 2 | isempty( dim )
        sdim  = strcat( 'cvx_default_dimension(size(', x.expr,  '))' );
        svdim = strcat( 'cvx_default_dimension(size(', x.vexpr, '))' );
    elseif isnumeric( dim )
        sdim  = mat2str( dim );
        svdim = sdim;
    else
        error( '[SCP] Unknown input 2!' );
    end
    
    if nargin < 3 || isempty( w )
        sw = [];
    elseif isnumeric( w )
        sw = mat2str( w );
    else
        error( '[SCP] Unknown input 2!' );
    end
    
    if ismap, cismap = 'true'; else cismap = 'false'; end

    x.expr  = strcat( 'geo_mean(', x.expr,  ',', sdim,  ',', sw, ',', ...
                     cismap, ',', char(39), cmode, char(39) );
                 
    x.vexpr = strcat( 'geo_mean(', x.vexpr, ',', svdim, ',', sw, ',', ...
                     cismap, ',', char(39), cmode, char(39) );
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 by Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++