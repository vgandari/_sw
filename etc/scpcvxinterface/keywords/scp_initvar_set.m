% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: scp_initvar_set - perform the keyword "scp_initvar_set".
% Purpose: initialize the value for the variable: {varname, varvalue}
% input: a set of variable name and their values (must go in pair).
%  Date: 18/06/2009
%  Created by: Quoc Tran Dinh - ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function scp_initvar_set( varargin )

if nargin < 2
    error( '[SCP] At least two inputs must be requried!' ); 
end

if mod( nargin, 2 )
    error( '[SCP] The inputs must go in pair (name, value)!' ); 
end;

% scp_cvx____ structure
global scp_cvx___;

if isempty( scp_cvx___ )
    error( sprintf( '%s%s\n%s', '[SCP] This function only runs ', ...
           'in the SCP-CVX mode!', ...
           'You first call "scp_begin" to start ... ' ) );
end

% if no variable is declared - exit...
if length( scp_cvx___.vstr.vlist ) == 0
    error( '[SCP] No variable is declared! Call "scp_variable(s)" function!' );
end

% initialize variables.
vstr = scp_cvx___.vstr;

for k=1:2:nargin

    ovar = varargin{k}; 
    val = varargin{k+1};
    
    if isa( ovar, 'scpexp' ) 
        
        ind = check_in_list( ovar, vstr.vlist );
        
        if isnumeric( val ) & getattr( ovar, 'size' ) == size( val ) & ind
            
            vstr.vlist{ind} = setattr( vstr.vlist{ind}, 'value', val );
            vstr.inval{ind} = val;
            
            assignin( 'caller', getattr( ovar, 'name' ), vstr.vlist{ind} );
            
        else
            error( '[SCP] The value must be numerical. It must go in pair.' ); 
        end
        
    else
        error( '[SCP] This variable does not exist. It must go in pair.' ); 
    end
end

% store again istr structure.
scp_cvx___.vstr = vstr;

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Function: check_in_list - check the existence of an object in a list
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function ind = check_in_list( ovar, olist )

nsz = length( olist ); 
ind = 0;

if nsz == 0
    return; 
end

for k=1:nsz
    if isequal( ovar, olist{k} )
        ind = k; return; 
    end
end
    
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++