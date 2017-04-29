% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% OPERATOR: vertcat - express the vertcat operator.
% Date: 09-06-2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function z = vertcat( varargin )

% check input variable.
if nargin < 1, error(' ERROR: At least one input is supplied!' ); end

% check the first variable
if isa( varargin{1}, 'scpexp' )
    z = varargin{1};  xexpr = z.expr; xvexpr = z.vexpr;
elseif isnumeric( varargin{1} )
    xexpr = mat2str( varargin{1} ); xvexpr = xexpr;
elseif iscell( varargin{1} )
    tmp = varargin{1};
    if isa( tmp{1}, 'scpexp' )
        xexpr  = tmp{1}.expr; 
        xvexpr = tmp{1}.vexpr; 
    elseif isnumeric( tmp{1} )
        xexpr  = mat2str( tmp{1} );
        xvexpr = xexpr;
    end
    
    for kk=2:length( tmp )
        if isa( tmp{kk}, 'scpexp' )
            xexpr  = strcat( xexpr, ',',  tmp{kk}.expr ); 
            xvexpr = strcat( xvexpr, ',', tmp{kk}.vexpr ); 
        elseif isnumeric( tmp{kk} )
            tmpval = mat2str( tmp{kk} );
            xexpr  = strcat( xexpr, ',',  tmpval );
            xvexpr = strcat( xvexpr,',',  tmpval );
        end
    end
end

% check the rest of variables.
for k=2:nargin
    if isa( varargin{k}, 'scpexp' )
        z = varargin{k};
        xexpr = strcat( xexpr, ',', z.expr );
        xvexpr = strcat( xvexpr, ',', z.vexpr );
    elseif isnumeric( varargin{k} )
        tmp = mat2str( varargin{k} );
        xexpr = strcat( xexpr, ',', tmp );
        xvexpr = strcat( xvexpr, ',', tmp );
    elseif iscell( varargin{k} )
        tmp = varargin{k};
            if isa( tmp{1}, 'scpexp' )
                xexpr  = tmp{1}.expr; 
                xvexpr = tmp{1}.vexpr; 
            elseif isnumeric( tmp{1} )
                xexpr  = mat2str( tmp{1} );
                xvexpr = xexpr;
            end

            for kk=2:length( tmp )
                if isa( tmp{kk}, 'scpexp' )
                    xexpr  = strcat( xexpr, ',',  tmp{kk}.expr ); 
                    xvexpr = strcat( xvexpr, ',', tmp{kk}.vexpr ); 
                elseif isnumeric( tmp{kk} )
                    tmpval = mat2str( tmp{kk} );
                    xexpr  = strcat( xexpr, ',',  tmpval );
                    xvexpr = strcat( xvexpr,',',  tmpval );
                end
            end
    end
end

% make a vertcat 
if ~isempty( xexpr )
    xexpr = strcat( 'vertcat(',  xexpr, ')' ); 
end
if ~isempty( xvexpr )
    xvexpr = strcat( 'vertcat(',  xvexpr, ')' ); 
end

% return result.
if isempty( z )
    z = vertcat( varargin{:} );
else
    z.expr = xexpr; z.vexpr = xvexpr;
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++