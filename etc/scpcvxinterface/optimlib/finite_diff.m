% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Function: finite_diff - finite difference - compute the jacobian of
% a function "func".
% Date: 20-06-2009
% Created by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function [ fx, Jfx ] = finite_diff( fcns, xcur, xforg, pars, f0, step )
                     
    if nargin < 6 || isempty( step )
        step = sqrt( eps ); 
    end
    
    xtmp = strrep( xforg, 'xsolk', 'newx' );
    
    if nargin < 4 || isempty( pars )
        funexp = strcat( 'fcns(', xtmp, ')' );
    else
        funexp = strcat( 'fcns(', xtmp, ', pars{:} )' );
    end
    
    if nargin < 5 || isempty( f0 )
        if isa( fcns, 'function_handle' )
            newx = xcur;
            f0 = eval( funexp );
        else
            error( '[SCP-finite-diff] Unknown function is provided!' );
        end
    end
    
    nx = length( xcur );
    E = eye( nx, nx );
    fx = f0; 
    
    for k=1:nx
        
        if isa( fcns, 'function_handle' )
            newx = xcur  + step*E(:, k );
            fnewx = eval( funexp );
        else
            error( '[SCP-finite-diff] Unknown function is provided!' );
        end
        
        jfx( :, k ) = ( fnewx - fx ) / step ;
        
    end;
    gtmp = strcat( '[', strrep( xtmp, 'newx(', 'jfx(:,' ), ']' );
    Jfx  = eval( gtmp );
    
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++