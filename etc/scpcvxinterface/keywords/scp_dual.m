% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: scp_dual - perform the keyword "scp_dual".
% Purpose: get dual variable and generate the corresponding
% "scpdual" object have the same name with the dual variable name.
% Date: 20-06-2009
% Created by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function varargout = scp_dual( varargin )

% check scp_cvx___ structure.
global scp_cvx___;
if isempty( scp_cvx___ )
    error( '[SCP] The command "scp_begin" needs to run first!' );
end

% check inputs
if ~iscellstr( varargin ),
    error( '[SCP] All inputs must be strings.' );
    
elseif strcmp( varargin{1}, 'variable' ),
    error( nargchk( 2, 2, nargin ) );
    varargin(1) = [];
    
elseif strcmp( varargin{1}, 'variables' ),
    error( nargchk( 2, Inf, nargin ) );
    varargin(1) = [];
end

% check outputs.
nargs = length( varargin );
if nargout > 0,
    error( nargoutchk( nargs, nargs, nargout ) );
end

% create and store dual variables.
dstr = scp_cvx___.dstr;
nd   = length( dstr.dlist );

for k = 1 : nargs
    
    dname  = varargin{k};
    xtmp   = find( dname  == '{' );
    
    if isempty( xtmp ),
        x.name = dname ;
        x.size = 1;
        
    elseif dname (end) ~= '}',
        error( sprintf( '%s%s%s', '[SCP] Invalid dual variable ', ...
               'specification: ', dname  ) );
           
    else
        x.name = dname( 1 : xtmp( 1 ) - 1 );
        x.size = dname( xtmp( 1 ) + 1 : end - 1 );
    end
    
    if ~isvarname( x.name ),
        error( sprintf( '%s%s%s', '[SCP] Invalid dual variable ', ...
                        'specification: ', dname  ) );
                    
    elseif x.name( end ) == '_',
        error( sprintf( ['[SCP] Invalid dual variable specification:', ...
               '%s\n Variables ending in underscores are reserved', ...
               ' for internal use.'], dname  ) );
    end
    
    if ischar( x.size ),
        x.size = evalin( 'caller', [ '[', x.size, '];' ], 'NaN' );
    end
    
    % check the existence of this dual variable
    tmp = evalin( 'caller', x.name, '[]' );
    if isa( tmp, 'scpdual' )
        error( '[SCP] Name already used for another SCP-CVX object!' );
    end

    % check if the same default name
    if strcmp( scp_cvx___.dstr.dname, x.name )
        error( '[SCP] This name is default name in SCP-CVX!' );
    end

    % create new dual variable 
    dvob = scpdual( x.name );
    dvob = setdattr( dvob, 'size', x.size );
    
    if prod( x.size ) == 1
        dexpr = x.name;
    else
        csize = strrep( mat2str(x.size), ' ', ',' );
        csize = strrep( strrep( csize, '[', '' ), ']', '' );
        dexpr = strcat( x.name, '{', csize, '}' );
    end
    
    dvob = setdattr( dvob, 'dexpr', dexpr );
    
    if nargout > 0
        varargout{k} = dvob; 
    end
    assignin( 'caller', x.name, dvob );
    
    % store dual variable in the temperatory list.
    nd = nd + 1;
    dstr.dlist{nd} = dvob;
    
end

% store the dual variable to scp_cvx___.
scp_cvx___.dstr = dstr;

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++