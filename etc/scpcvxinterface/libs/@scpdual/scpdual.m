%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: scpdual - This file declares a "scpdual" class.
% Date: 09-06-2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function z =  scpdual( x, name, size, value, type, expr, dexpr, isdual )

% check inputs
error( nargchk( 1, 8, nargin ) );
if isa( x, 'scpdual' )
    z = x; return; 
end;

if nargin < 8, isdual= false;    end;
if nargin < 7, dexpr = '';       end;
if nargin < 6, expr  = '';       end;
if nargin < 5, type  = 'double'; end;
if nargin < 4, value = 0;        end;
if nargin < 3, size  = 0;        end;
if nargin < 2, 
    name = 'scp_unknown_dual_name';  
    expr = name; dexpr = name; 
end

% if the first input is a string, set it as a name.
if ischar( x ) && nargin == 1
    name = x; expr = x; dexpr = x; 
end;

if isnumeric( x ), 
    expr = mat2str( x ); dexpr = expr;
    size = size( x ); value = x; type = class( x );
end

if ~ischar( name ) || ~isvarname( name )
    error( '[SCP] Name must be a string!' ); 
end

% "size" must be numerical
if ~isnumeric( size )
    error( '[SCP] Size must be numerical!' );      
end

% value must be numerical.
if ~isnumeric( value ) 
    error( '[SCP] Value must be numerical!' );     
end

% type must be a string.
if ~ischar( type ),     
    error( '[SCP] Type must be a string!' );       
end

% expression must be a string.
if ~ischar( expr )
    error( '[SCP] Expression must be a string!' ); 
end

% dual expression must be a string
if ~ischar( dexpr )
    error( '[SCP] DEXPR must be a string!' );      
end

% "isdual" must be a logical - express this is a dual variable or not 
if ~islogical( isdual )
    error( '[SCP] IsDual must be logical!' );      
end

% create class "scpdual".
z = class( struct( 'name', name, 'value', value, 'size', size, 'type', ...
    type, 'expr', expr, 'dexpr', dexpr, 'isdual', isdual ), 'scpdual' );

%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%  Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
%  See the file COPYING.txt for full copyright information.
%  The command 'scp_where' will show where this file is located.
%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++