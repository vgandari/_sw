% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% OPERATOR: colon (:) - express the colon operator of the "scpdual" class.
% This case express x : y, where x is an "scpdual" object, y is arbitrary.
% Date: 09-06-2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function z = colon( x, y )

% ------------------------------------------------------
% the left hand side "x" is a dual variable
% ------------------------------------------------------
if isa( x, 'scpdual' )
    
    if isnumeric( y )

        tmp   = mat2str( y );
        expr  = strcat( x.expr,  ':', tmp , '@' );
        vexpr = strcat( x.dexpr, ':', tmp , '@' );
        
    elseif isa( y, 'scpexp' )
        
        expr  = strcat( x.expr,  ':', getattr( y, 'expr'),  '@' );
        vexpr = strcat( x.dexpr, ':', getattr( y, 'vexpr'), '@' );
        
    elseif iscell( y )
        
        tmp1 = []; tmp2 = [];
        
        for k=1:length( y )
            
            if isa( y{k}, 'scpexp' )
                tmp1 = strcat( tmp1, gatattr( y{k}, 'expr' ),  ',' );
                tmp2 = strcat( tmp2, getattr( y{k}, 'vexpr' ), ',' );    
                
            elseif isnumeric( y{k} )
                tmp = mat2str( y{k} );
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
        
        expr  = strcat( x.expr,  ':', tmp1, '@' );
        vexpr = strcat( x.vexpr, ':', tmp2, '@' );
        
    else
        error( '[SCP] Unknown right hand side variable ... ' );
    end

% ------------------------------------------------------
% the left hand side "x" is numerical.
% ------------------------------------------------------
elseif isnumeric( x )
    
    % the right hand side "y" is a dual variable and the left hand side 
    % is numerical.
    if isa( y, 'scpdual' )
        
        tmp   = mat2str( x );
        expr  = strcat( tmp, ':', getdattr( y, 'expr' ),  '@' );
        vexpr = strcat( tmp, ':', getdattr( y, 'dexpr' ), '@' );
        
    else
        warning( '[SCP] This is not a constraint for the SCPCVX!' );
        expr = []; vexpr = [];
    end

% ------------------------------------------------------
% when the left hand size is a cell.
% ------------------------------------------------------
elseif iscell( x )
    
    % only process if the right hand side is a dual variable.
    if isa( y, 'scpdual' )
        
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

        expr  = strcat( tmp1, ':', getdattr( y, 'expr' ),  '@' );
        vexpr = strcat( tmp2, ':', getdattr( y, 'dexpr' ), '@' );
        
    else
        error( '[SCP] Unknown right hand side variable ... ' );
    end
else
	error( '[SCP] Unknown left hand side variable ... ' );
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
    if ( isa( x, 'scpdual' ) || isa( y, 'scpdual' ) ) ...
        && ~isempty( expr ) && ~isempty( vexpr )
        
        nd = length( scp_cvx___.cstr.clist ) + 1;
        scp_cvx___.cstr.clist{nd} = expr;
        scp_cvx___.cstr.cltex{nd} = vexpr;
    
    end
else
    z = colon( x, y );
end 

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++