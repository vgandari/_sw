% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: scp_cloput ...
% Purpose: This function clear variables, duals, problem structure ...
% at the end.
% Date: 20-06-2009
% Created by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function scp_cloput( clearopt )

global scp_cvx___;

switch( clearopt )
    
    % clear all scp object before start new performmance.
    case 'init',
    tmp = evalin( 'caller', 'whos' );
    for k=1:length( tmp )
        tt = tmp(k);
        if strcmp( tt.class, 'scpexp' ) || strcmp( tt.class, 'scpdual' ) ...
           || strcmp( tt.class, 'cvx' ) || strcmp( tt.class, 'cvxprob' ) ...    
           || strcmp( tt.class, 'cvxobj' ) 
           
            evalin( 'caller', ['clearvars ',  tt.name ] );
        end
    end
    
    % clear primal variables
    case 'variables',
    vstr = scp_cvx___.vstr;
    for k=1:length( vstr.vlist )
        nv = getattr( vstr.vlist{k}, 'name' );
        if ischar( nv ) && ~isempty( nv )
            evalin( 'caller', ['clearvars ', nv ] );
        end
    end
    
    % clear dual variables
    case 'dual', 
    dstr = scp_cvx___.dstr;
    for k=1:length( dstr.dlist )
        nd = getdattr( dstr.dlist{k}, 'name' );
        if ischar( nd ) && ~isempty( nd )
            evalin( 'caller', ['clearvars ', nd ] );
        end
    end
    
    % clear all variables
    case 'all-var', 
    tmp = evalin( 'caller', 'whos' );
    for k=1:length( tmp )
        tt = tmp(k);
        if strcmp( tt.class, 'scpexp' ) || strcmp( tt.class, 'scpdual' ) ...
        || strcmp( tt.class, 'cvxobj' ) || strcmp( tt.class, 'cvx' ) ...     
        || strcmp( tt.class, 'cvxprob' ) 
    
            evalin('caller', ['clearvars  ', tt.name] );
        end
    end
	evalin( 'caller', 'clearvars -global scp_cvx___' );
    
    % clear path
    case 'path',
        if isfield( scp_cvx___, 'path' ) 
            strpath = scp_cvx___.path;
            if ~isempty( strpath )
                nstr    = length( strpath );
                opath = matlabpath;
                ind = strfind( opath, strpath );
                if ~isempty( ind )
                    opath = strcat( opath(1:ind-1), opath(ind+nstr:end) );
                    matlabpath( opath );
                end
            end
        end
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++