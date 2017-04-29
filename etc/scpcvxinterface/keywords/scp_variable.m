% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: scp_variable - perform the keyword "scp_variable".
%
% Purpose: get variable: name, size, type and generate the corresponding
% scpexp object have the same name with variable name.
%
% Date: 20-06-2009
% Created by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function varargout = scp_variable( name, varargin )

% scp_cvx___ variable.
global scp_cvx___;

if isempty( scp_cvx___ )
    error( sprintf( '%s%s \n%s', '[SCP] This function only runs ', ...
           'in SCP-CVX mode!', ...
           'You first call "scp_begin" to start ... ' ) );
end

% ------------------------------------------------------------------------
% Step 1: sparate the name from the parenthetical.
% ------------------------------------------------------------------------
xname = find( name == '(' );

% check xname if it is empty or contained ')' ...
if isempty( xname )
    x.name = name; 
    x.size = [1, 1];
    
elseif name( end ) ~= ')',
    error( sprintf( '[SCP] Invalid variable specification: %s', name ) );
    
else 
    x.name = name( 1 : xname( 1 ) - 1 );
    x.size = name( xname( 1 ) + 1 : end - 1 );
    
end

% check if x.name is a variable name or contained the special symbols.
if ~isvarname( x.name ),
    error( sprintf( '[SCP] Invalid variable specification: %s', name ) );
    
elseif x.name( end ) == '_',
    error( sprintf( ['[SCP] Invalid variable specification: %s\n', ....
    'Variables ending in underscores are reserved for internal use.'], ...
    name ) );

elseif exist( [ 'scp_', x.name ], 'file' ) == 2,
    error( sprintf( [ '[SCP] Invalid variable specification: %s\n', ...
        ' The name "%s" is reserved as a matrix structure modifier,\n', ...
        ' which can be used only with the VARIABLE keyword.' ], ...
        name, x.name ) );
    
end

% check the existence of this variable
tmp = evalin( 'caller', x.name, '[]' );
if isa( tmp, 'scpexp' )
    error( '[SCP] Name already used for another SCP-CVX object!' );
end

% check if the same default name
if strcmp( scp_cvx___.vstr.vname, x.name )
    error( '[SCP] This name is default name in SCP-CVX!' );
end

% get the size of variable.
if ischar( x.size ),
    x.size = evalin( 'caller', [ '[', x.size, '];' ], 'NaN' );
end

% if length( x.size ) == 1, make it with two dimensions
if length( x.size ) == 1, x.size = [x.size, 1]; end;

% ------------------------------------------------
% Step 2: check keywords for variables
% ------------------------------------------------
listOfKeywords = { 'banded'; 'complex'; 'diagonal'; 'hankel'; ...
          'hermitian'; 'lower_bidiagonal'; 'lower_hessenberg';
          'lower_triangular'; 'scaled_identity'; 'skew_symmetric'; ...
          'symmetric'; 'toeplitz'; 'tridiagonal'; 'upper_bidiagonal'; ...
          'upper_hankel'; 'upper_hessenberg'; 'upper_triangular' };
      
% type of the variable
ntp = length( varargin );
varType = '';
for k=1:ntp
    
    strtmp = varargin{k};
    
    % process the keywords for type of the variables
    if any( strcmp( listOfKeywords, strtmp ) )
    
        varType = [ varType, ' ', strtmp ];
    
	% process the "banded" keyword
    elseif strncmp( strtmp, 'banded', 6 )
        
        indx = find( strtmp == '(' );
        if isempty( indx )
           typetmp = strtmp;
        elseif strtmp( end ) ~= ')',
           typetmp = '';
           warning( '[SCP] Invalid keyword for variable!' );
        else
            typetmp = strtmp( 1 : indx(1) - 1 );
            typeszn =  evalin( 'caller', [ '{', ...
                       strtmp(indx(1)+1:end-1), '}' ], 'NaN' );
            if ~iscell( typeszn )
                typetmp = '';
                warning( '[SCP] Invalid keyword for variable!' );
            end
            
            tmp1 = [];
            for k = 1:length(typeszn)
                tmp1 = strcat( tmp1, mat2str( typeszn{k} ), ',' );
            end
            
            if ~isempty( tmp1 ), 
                tmp1 = tmp1(1:end-1);
            end
            
            typetmp = strcat( typetmp, '(', tmp1, ')' );
            
        end

        varType = [ varType, ' ', typetmp ];

    else
        warning( '[SCP] A wrong keyword is provided! Automatically skip!' );
    end
    
end

% -----------------------------------------------------
% Step 3: create an "scpexp" object for this variable.
% -----------------------------------------------------
if x.size ~= 0 & ~isnan( x.size ) & ~isinf( x.size )
    zermat = zeros( x.size );
else
    zermat = [];
end
varobj = scpexp( x.name );
varobj = setattr( varobj, 'type',  varType );
varobj = setattr( varobj, 'size',  x.size );
varobj = setattr( varobj, 'value', zermat );

csize  = strrep(  mat2str(x.size), ' ', ',' );
csize  = strrep(  strrep( csize,   '[', '' ), ']', '' );
vexpr  = strcat(  x.name, '(', csize , ')' );
varobj = setattr( varobj, 'vexpr', vexpr  );

% -----------------------------------------------------
% Step 4: store the variable into scp_cvx___ structure
% -----------------------------------------------------
vstr = scp_cvx___.vstr;

nvar             = length( vstr.vlist ) + 1;
vstr.vlist{nvar} = varobj;
vstr.inval{nvar} = zermat;
vstr.vaobj{nvar} = zermat;
vstr.vacon{nvar} = zermat;

scp_cvx___.vstr = vstr;

% assign the scpexp object to x.name.
if nargout > 0,
    varargout{1} = varobj;
else
    assignin( 'caller', x.name, varobj );
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++