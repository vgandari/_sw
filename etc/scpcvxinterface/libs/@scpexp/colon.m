%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% OPERATOR: colon (:)- express the colon operator for the "scpexp" object.
% Date: 09-06-2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function z = colon( x, y )

% -------------------------------------------------------------
% if the left hand side is an "scpexp" object: A*u==x:y; (e.g.)
% -------------------------------------------------------------
if isa( x, 'scpexp' )

    if isa( y, 'scpdual' )
        
        expr  = strcat( x.expr,  ':', getdattr( y, 'expr' ),  '@' );
        vexpr = strcat( x.vexpr, ':', getdattr( y, 'dexpr' ), '@' );
        
    elseif isnumeric( y )
        
        tmp = mat2str(y);
        expr  = strcat( x.expr,  ':', tmp, '@' );
        vexpr = strcat( x.vexpr, ':', tmp, '@' );
        
    else
        error( '[SCP] Unknown right hand side variable ... ' );
    end
    
% -------------------------------------------------------------
% if the left hand side is numerical
% -------------------------------------------------------------
elseif isnumeric( x )
    
    if isa( y, 'scpdual' )
        
        tmp   = mat2str( x );
        expr  = strcat( tmp, ':', getdattr( y, 'expr' ),  '@' );
        vexpr = strcat( tmp, ':', getdattr( y, 'dexpr' ), '@' );

	% this expression for "end" operator.
    elseif isa( y, 'scpexp' )
        expr  = strcat( mat2str(x), ':', y.expr ); 
        vexpr = strcat( mat2str(x), ':', y.vexpr );
        
    else
        expr = []; vexpr = [];
        warning( '[SCP] This is not a constraint for the SCP-CVX!' );
    end
    
% -------------------------------------------------------------
% if the left hand side is a cell: lorentz(2) == {u, v} : y;
% -------------------------------------------------------------
elseif iscell( x )
    
    if isa( y, 'scpdual' ) || isnumeric( y ) 
        
        tmp1 = []; tmp2 = [];
        for k=1:length( x )
            
            if isa( x{k}, 'scpexp' )
                tmp1 = strcat( tmp1, getattr( x{k}, 'expr' ),  ',' );
                tmp2 = strcat( tmp2, getattr( x{k}, 'vexpr' ), ',' );    

            elseif isnumeric( x{k} )
                tmp = mat2str( x{k} );
                tmp1 = strcat( tmp1, tmp, ',' );
                tmp2 = strcat( tmp2, tmp, ',' );

            else
                error( '[SCP] Unknown right hand side variable!' );
            end
        end

        if ~isempty( tmp1 ), tmp1 = tmp1(1:end-1); end
        if ~isempty( tmp2 ), tmp2 = tmp2(1:end-1); end
        
        tmp1 = strcat( '{', tmp1, '}' );
        tmp2 = strcat( '{', tmp2, '}' );

        if isa( y, 'scpdual' )
            yexpr  = getdattr( y, 'expr' );
            ydexpr = getdattr( y, 'dexpr' );
            
        elseif isnumeric( y )
            yexpr  = mat2str( y );
            ydexpr = yexpr; 
            
        end
        
        expr  = strcat( tmp1, ':', yexpr,  '@' );
        vexpr = strcat( tmp2, ':', ydexpr, '@' );
        
    else
        error( '[SCP] Unknown right hand side variable! ' );
    end
    
% -------------------------------------------------------------
% otherwise.
% -------------------------------------------------------------
else
	error( '[SCP] Unknown left hand side variable!' );
end

% make the output.
if nargin > 1
    z = scpexp( 'z' ); 
    z = setattr( z, 'expr', expr ); 
    z = setattr( z, 'vexpr', vexpr ); 
end

% add constraint to scp_cvx___.
global scp_cvx___;
if ~isempty( scp_cvx___ )
    
    % the kind of the constraint is:  dualvar: lhs ==(>=, <=, ...) rhs
    if( isa( x, 'scpdual' ) || isa( y, 'scpdual' ) ) ...
      && ~isempty( expr ) && ~isempty( vexpr )
  
        nd = length( scp_cvx___.cstr.clist ) + 1;
        scp_cvx___.cstr.clist{nd} = expr;
        scp_cvx___.cstr.cltex{nd} = vexpr;
        
    end
else
    z = colon( x, y );
end 

%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%  Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
%  See the file COPYING.txt for full copyright information.
%  The command 'scp_where' will show where this file is located.
%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++