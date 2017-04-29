% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: scp_objective_set - set the objective vector.
%
% Purpose: For the objective function F(x) = c1'*x + c2'*y + ...,
%          this function set the value to c1, c2, ... with respect to the
%          variables x, y which are indicated. 
% input: the list of pair variable and c vector value { name, c-value }
%
% Date: 18/06/2009
% Created by: Quoc Tran Dinh - ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function scp_objective_set( varargin )

% scp_cvx____ structure
global scp_cvx___;

if isempty( scp_cvx___ )
    error( '[SCP] This keyword only runs in the SCP-CVX mode.' );
end

if nargin < 2
    error( '[SCP] At least two input must be requried!' ); 
end

if mod( nargin, 2 )
    error( '[SCP] The inputs must go in pair (name, c-value)!' ); 
end;

if length( scp_cvx___.vstr.vlist ) == 0,
    error( '[SCP] No variable is declared! Call "scp_variable(s)" function!' );
end

fstr = scp_cvx___.fstr;
if ~isempty( fstr.obfun )
    warning( '[SCP] Objective function has defined!' );
end

% for the first pair ( name(1), c-value(1))
vstr = scp_cvx___.vstr;

var = varargin{1}; 
val = varargin{2};
if isa( var, 'scpexp' )
    
    if isnumeric( val )
    
        % indicate that this variable is related to objective function
        ind = check_in_list( var, vstr.vlist );
        
        if ind > 0
            ofun = transpose(val)*var; 
            vstr.vaobj{ind} = val;
        else
            error( 'This variable is not declared!' ); 
        end
        
    else
        error( '[SCP] The value must be numerical. It must go in pair.' ); 
    end
    
else
    error( '[SCP] Does not exist this variable. It must go in pair.' ); 
end    

% from the second pair (name(2), c-value(2)) to the end.
for k=3:2:nargin
    
    var = varargin{k}; 
    val = varargin{k+1};
    
    if isa( var, 'scpexp' ),
        if isnumeric( val ),
    
            % indicate that this variable is related to objective function
            ind = check_in_list( var, vstr.vlist );
            
            if ind > 0, 
                ofun = ofun + transpose(val)*var; 
                vstr.vaobj{ind} = val;
            else
                error( 'This variable is not declared!' ); 
            end
            
        end
        
    else
        error( '[SCP] This variable does not exist. It must go in pair.' ); 
    end
end

% store again istr structure.
scp_cvx___.vstr = vstr;

% create objective vector for all variable.
cvec = [];
for k=1:length( vstr.vlist )
    
    c = vstr.vaobj{k};
    if isnumeric( c )
        cvec = vertcat( cvec, reshape( c, prod( size(c) ), 1 ) );
    end
    
end

% store again istr structure.
fstr.obfun = ofun; 
fstr.grfun = cvec; 
fstr.obdir = -1;
scp_cvx___.fstr = fstr;

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