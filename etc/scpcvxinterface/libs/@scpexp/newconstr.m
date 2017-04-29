% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: newconstr - Create a new constraints for SCP-CVX mode.
% Date: 09-06-2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function z = newconstr( x, y, op )

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%               PROCESS THE LEFT HAND SIDE: "x"
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% -------------------------------------------------------------------
% when "x" is an "scpexp" object
% -------------------------------------------------------------------
if isa( x, 'scpexp' )
    
    xexpr  = x.expr;
    xvexpr = x.vexpr;
    xctype = x.type;
    
% -------------------------------------------------------------------
% when "x" is numerical
% -------------------------------------------------------------------
elseif isnumeric( x )
    
    xexpr  = mat2str( x );
    xvexpr = xexpr;
    xctype = '';
    
% -------------------------------------------------------------------
% when "x" is the cells
% -------------------------------------------------------------------
elseif iscell( x ) 
    
    % -------------------------------------------------------------------
    % this is normal expression
    % -------------------------------------------------------------------
    if length( x ) == 1
        
        if isa( x{1}, 'scpexp' )
            
            xexpr  = strcat( '{', x{1}.expr,  '}' );
            xvexpr = strcat( '{', x{1}.vexpr, '}' );
            xctype = x{1}.type;
            
        elseif isnumeric( x{1} )
            
            xexpr  = strcat( '{', mat2str( x{1} ), '}' );
            xvexpr = xexpr;
            xctype = '';    
            
        else
            error( '[SCP] Unknown left hand side variable!' );
        end
        
	% -------------------------------------------------------------------
    % for the "lorentz" or "complex_lorentz" cone - x is a cell.
    % { a, b } == lorentz(n) and y must be a lorentz cone.
    % -------------------------------------------------------------------
    elseif length( x ) == 2
        if op(1) == '=' && isa( y, 'scpexp' ) && ...
           any( strcmpi( getattr( y, 'name' ), ...
                {'lorentz', 'complex_lorentz'} ) )
            
            % process the first cell "x{1}" 
            if isa( x{1}, 'scpexp' )
                
                x1expr  = x{1}.expr;
                x1vexpr = x{1}.vexpr;
                x1ctype = x{1}.type;
                
            elseif isnumeric( x{1} )
                
                x1expr  = mat2str( x{1} ); 
                x1vexpr = x1expr;
                x1ctype = '';
                
            else
                error('[SCP] Unknown first input!'); 
            end
            
            % process the second cell "x{2}".
            if isa( x{2}, 'scpexp' )
                
                x2expr  = x{2}.expr;
                x2vexpr = x{2}.vexpr;
                x2ctype = x{2}.type;
                
            elseif isnumeric( x{2} )
                
                x2expr  = mat2str( x{2} ); 
                x2vexpr = x2expr;
                x2ctype = '';
                
            else
                error('[SCP] Unknown first input!'); 
            end

            % combine "x{1}" and "x{2}" together { x{1}, x{2} }.
            xexpr  = strcat( '{', x1expr,  ',', x2expr ,  '}' );
            xvexpr = strcat( '{', x1vexpr, ',', x2vexpr , '}' );
            
            % get the type of the constraint
            xctype = strcat( x1ctype, ',', x2ctype );
            
        else
            error( '[SCP] Unknown kind of constraints!' );
        end
        
	% -------------------------------------------------------------------
    % for the "rotated_lorentz" or "rotated_complex_lorentz" cone
    % { x{1}, x{2}, x{3} } == rotated_lorent(n).
    % -------------------------------------------------------------------
    elseif length( x ) == 3
        if op(1) == '=' && isa( y, 'scpexp' ) ...
            && any( strcmpi( getattr( y, 'name' ), ...
                    {'rotated_lorentz', 'rotated_complex_lorentz'} ) )

            % process the first cell "x{1}"
            if isa( x{1}, 'scpexp' )
                
                x1expr  = x{1}.expr;
                x1vexpr = x{1}.vexpr;
                x1ctype = x{1}.type;
                
            elseif isnumeric( x{1} )
                
                x1expr  = mat2str( x{1} ); 
                x1vexpr = x1expr;
                x1ctype = '';
                
            else
                error('[SCP] Unknown first input!'); 
            end

            % process the second cell "x{2}"
            if isa( x{2}, 'scpexp' )
                
                x2expr  = x{2}.expr;
                x2vexpr = x{2}.vexpr;
                x2ctype = x{2}.type;                
                
            elseif isnumeric( x{2} )
                
                x2expr  = mat2str( x{2} ); 
                x2vexpr = x2expr;
                x2ctype = '';
                
            else
                error('[SCP] Unknown first input!'); 
            end

            % process the third cell "x{3}"
            if isa( x{3}, 'scpexp' )
                
                x3expr  = x{3}.expr;
                x3vexpr = x{3}.vexpr;
                x3ctype = x{3}.type;
                
            elseif isnumeric( x{3} ), 
                
                x3expr  = mat2str( x{3} ); 
                x3vexpr =  x3expr;
                x3ctype = '';
                
            else
                error('[SCP] Unknown first input!'); 
            end

            % combine x{1}, x{2} and x{3} together.
            xexpr  = strcat( '{', x1expr,  ',', x2expr ,  ',', x3expr,  '}' );
            xvexpr = strcat( '{', x1vexpr, ',', x2vexpr , ',', x3vexpr, '}' );

            % get the type of the constraint
            xctype = strcat( x1ctype, ',', x2ctype, ',', x3ctype );
            
        else
           error( '[SCP] Unknown kind of constraints!' );
        end
        
	% -------------------------------------------------------------------
    % the length of the left hand side too long
    % -------------------------------------------------------------------
    else
        error( '[SCP] The length of the left hand side is too long!' );
    end

% -------------------------------------------------------------------
% when "x" is not an "scpexp" object, number or cells
% -------------------------------------------------------------------
else
    error( '[SCP] Unknown kind of the left hand side input!' );
end
    
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%               PROCESS THE RIGHT HAND SIDE: "y"
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

% -------------------------------------------------------------------
% when "x" is an "scpexp" object.
% -------------------------------------------------------------------
if isa( y, 'scpexp' )
    
    yexpr  = y.expr;
    yvexpr = y.vexpr;
    yctype = y.type;
    
% -------------------------------------------------------------------
% when "x" is numerical
% -------------------------------------------------------------------
elseif isnumeric( y )
    
    yexpr  = mat2str( y );
    yvexpr = yexpr;
    yctype = '';
    
% -------------------------------------------------------------------
% when "x" is not an "scpexp" object, number or cells
% -------------------------------------------------------------------
elseif iscell( y )
    
    % -------------------------------------------------------------------
    % this is normal expression
    % -------------------------------------------------------------------
    if length( y ) == 1
        if isa( y{1}, 'scpexp' )
            
            yexpr  = y{1}.expr;
            yvexpr = y{1}.vexpr;
            yctype = y{1}.type;
            
        elseif isnumeric( y{1} )
            
            yexpr  = mat2str( y{1} );
            yvexpr = yexpr;
            yctype = '';
            
        else
            error('[SCP] Unknown second input!'); 
        end
    % -------------------------------------------------------------------
    % for the "lorentz" or "complex_lorentz" cone - y is a cell.
    % { a, b } == lorentz(n) and x must be a lorentz cone.
    % -------------------------------------------------------------------
    elseif length( y ) == 2
        if op(1) == '=' && isa( x, 'scpexp' ) && ...
           any( strcmpi( getattr( x, 'name' ), ...
                {'lorentz', 'complex_lorentz'} ) )
            
            % process the first cell "y{1}" 
            if isa( y{1}, 'scpexp' )
                
                y1expr  = y{1}.expr;
                y1vexpr = y{1}.vexpr;
                y1ctype = y{1}.type;
                
            elseif isnumeric( x{1} )
                
                y1expr  = mat2str( y{1} ); 
                y1vexpr = y1expr;
                y1ctype = '';
                
            else
                error('[SCP] Unknown first input!'); 
            end
            
            % process the second cell "y{2}".
            if isa( y{2}, 'scpexp' )
                
                y2expr  = y{2}.expr;
                y2vexpr = y{2}.vexpr;
                y2ctype = y{2}.type;
                
            elseif isnumeric( y{2} )
                
                y2expr  = mat2str( y{2} ); 
                y2vexpr = y2expr;
                y2ctype = '';
                
            else
                error('[SCP] Unknown first input!'); 
            end

            % combine "y{1}" and "y{2}" together { y{1}, y{2} }.
            yexpr  = strcat( '{', y1expr,  ',', y2expr ,  '}' );
            yvexpr = strcat( '{', y1vexpr, ',', y2vexpr , '}' );
            
            % get the type of the constraint
            yctype = strcat( y1ctype, ',', y2ctype );
            
        else
            error( '[SCP] Unknown kind of constraints!' );
        end
    % -------------------------------------------------------------------
    % for the "rotated_lorentz" or "rotated_complex_lorentz" cone
    % { y{1}, y{2}, y{3} } == rotated_lorent(n).
    % -------------------------------------------------------------------
    elseif length( y ) == 3
        if op(1) == '=' && isa( x, 'scpexp' ) ...
            && any( strcmpi( getattr( x, 'name' ), ...
                    {'rotated_lorentz', 'rotated_complex_lorentz'} ) )

            % process the first cell "y{1}"
            if isa( y{1}, 'scpexp' )
                
                y1expr  = y{1}.expr;
                y1vexpr = y{1}.vexpr;
                y1ctype = y{1}.type;
                
            elseif isnumeric( y{1} )
                
                y1expr  = mat2str( y{1} ); 
                y1vexpr = y1expr;
                y1ctype = '';
                
            else
                error('[SCP] Unknown first input!'); 
            end

            % process the second cell "y{2}"
            if isa( y{2}, 'scpexp' )
                
                y2expr  = y{2}.expr;
                y2vexpr = y{2}.vexpr;
                y2ctype = y{2}.type;                
                
            elseif isnumeric( y{2} )
                
                y2expr  = mat2str( y{2} ); 
                y2vexpr = y2expr;
                y2ctype = '';
                
            else
                error('[SCP] Unknown first input!'); 
            end

            % process the third cell "y{3}"
            if isa( y{3}, 'scpexp' )
                
                y3expr  = y{3}.expr;
                y3vexpr = y{3}.vexpr;
                y3ctype = y{3}.type;
                
            elseif isnumeric( y{3} ), 
                
                y3expr  = mat2str( y{3} ); 
                y3vexpr =  y3expr;
                y3ctype = '';
                
            else
                error('[SCP] Unknown first input!'); 
            end

            % combine y{1}, y{2} and y{3} together.
            yexpr  = strcat( '{', y1expr,  ',', y2expr ,  ',', y3expr,  '}' );
            yvexpr = strcat( '{', y1vexpr, ',', y2vexpr , ',', y3vexpr, '}' );

            % get the type of the constraint
            yctype = strcat( y1ctype, ',', y2ctype, ',', y3ctype );
            
        else
           error( '[SCP] Unknown kind of constraints!' );
        end
        
	% -------------------------------------------------------------------
    % the length of the left hand side too long
    % -------------------------------------------------------------------
    else
        error( '[SCP] Unknown kind of this constraint!' );
    end
% -------------------------------------------------------------------
% when "x" is not an "scpexp" object, number or cells
% -------------------------------------------------------------------
else
    error( '[SCP] Unknown kind of this constraints!' );
end

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%               PROCESS THE RIGHT HAND SIDE: "y"
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

% -------------------------------------------------------------------
% save the contraint to the global variable "scp_cvx___"
% -------------------------------------------------------------------
global scp_cvx___;

if ~isempty( scp_cvx___ ) 
    
    cstr = scp_cvx___.cstr;
    nc = length( cstr.clist );
    if nc > 0, 
        oexpr = cstr.clist{nc};
        
        % if "@" belongs to the constraints, it means that this constraint
        % has the corresponding dual variable.
        if find( oexpr == '@' ) 
            if xexpr(end) == '@', 
                xexpr = xexpr(1:end-1); xvexpr = xvexpr(1:end-1);
            end;
            if yexpr(end) == '@', 
                yexpr = yexpr(1:end-1); yvexpr = yvexpr(1:end-1); 
            end;
            
        % otherwise, increase the number of constraint by one.    
        else
            nc = nc + 1;  
        end
        
    % no equality constraint exists.    
    else 
        nc = nc + 1;  
    end
    
    % store the expression in the intermediate structure: cstr.
    cstr.clist{nc} = strcat( '(', xexpr, op,  yexpr, ')' );
    cstr.cltex{nc} = strcat( '(', xvexpr, op,  yvexpr, ')' );
    cstr.oplst{nc} = op(1);
    cstr.clknd{nc} = strcat( xctype, ',', yctype );

end % end of if ~isempty ...

% store to scp_cvx___
scp_cvx___.cstr = cstr;

% -------------------------------------------------------------------
% if number of output > 0 then return z.
% -------------------------------------------------------------------
if nargout > 0, 
    z = scpexp( 'z' ); 
    z = setattr( z, 'expr', ['(', xexpr, op,  yexpr, ')' ] ); 
    z = setattr( z, 'vexpr', ['(', xvexpr, op,  yvexpr, ')' ] ); 
end

% -------------------------------------------------------------------
% This command makes sure that the constraint declaration after the 
% keyword 'subject to' is called.
% -------------------------------------------------------------------
if scp_cvx___.stkw ~= 1 && scp_cvx___.stkw ~= 2
    error( ['[SCP] A "subject to" or "convex_begin_declare" ', ...
            'keyword is required!'] );
end
    
%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%  Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
%  See the file COPYING.txt for full copyright information.
%  The command 'scp_where' will show where this file is located.
%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++