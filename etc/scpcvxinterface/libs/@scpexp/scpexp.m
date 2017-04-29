%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: scpexp - This file declares a 'scpexp' class.
% Date: 09-06-2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function z =  scpexp( x, name, expr, size, value, type, isvar, vexpr )

% check inputs
error( nargchk( 1, 8, nargin ) );
if isa( x, 'scpexp' )
    z = x; return; 
end;

if nargin < 7, vexpr = '';      end
if nargin < 7, isvar = false;   end
if nargin < 6, type = 'double'; end
if nargin < 5, value = 0;       end;
if nargin < 4, size = 0;        end;
if nargin < 3, expr = '';       end;
if nargin < 2
    name = 'scp_unknown_variable_name'; 
    expr = name; vexpr = expr; 
end;

% if the first input is a string, set it as a name.
if ischar( x ) && nargin == 1
    name = x; expr = x; vexpr = x; 
end;

% if "x" is numerical, expression became its value.
if isnumeric( x ), 
    expr = mat2str( x ); size = size( x ); 
    value = x; type = class( x ); vexpr = expr;
end

if ~ischar( name ) || ~isvarname( name )
    error( '[SCP] Name must be a string!' ); 
end

if ~ischar( expr )
    error( '[SCP] Expression must be a string!' ); 
end

if ~isnumeric( size )
    error( '[SCP] Size must be numerical!' );      
end

if ~isnumeric( value )
    error( '[SCP] Value must be numerical!' );     
end

if ~ischar( type )
    error( '[SCP] Type must be a string!' );       
end

if ~islogical( isvar )
    error( '[SCP] IsVar must be logical!' );       
end

if ~ischar( vexpr )
    error( '[SCP] VarExpr must be a string!' );    
end

% create "scpexp" class
z = class( struct( 'name', name, 'expr', expr, 'value', value, ...
  'size', size, 'type', type, 'isvar', isvar, 'vexpr', vexpr ), 'scpexp' );

%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%  Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
%  See the file COPYING.txt for full copyright information.
%  The command 'scp_where' will show where this file is located.
%  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++