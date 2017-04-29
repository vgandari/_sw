% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: nonconvex_variable - declare list of variable for  the
% nonlinear constraint g(x) == 0.
% Date: 20-06-2009
% Created by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function nonconvex_variable( varargin )

error( nargchk(1, +Inf, nargin ) );
if nargin < 1
    error( '[SCP] At least one input must be provided!' ); 
end

% global variable scp_cvx___
global scp_cvx___;
if isempty( scp_cvx___ )
    error( sprintf( '%s%s\n%s', '[SCP] This function only runs ', ...
           'in SCP-CVX mode!', ...
           'You first call "scp_begin" to start ... ' ) );
end

% create the function handle 
nvargin = length( varargin ); 
vstr = scp_cvx___.vstr; 

% start store variables and parameters.
for k=1:nvargin
    
    vtmp = varargin{k};
    
    if isa( vtmp, 'scpexp' )
    
        % indicate that this variable is related to nonlinear constraints
        ind = check_in_list( vtmp, vstr.vlist );
        
        if ind > 0
            sz = getattr( vtmp, 'size' );
            vstr.vacon{ind} = ones( prod( sz ), 1 );
        else
            error( '[SCP] This variable is not declared!' ); 
        end
    else
        error( '[SCP] This variariable does not exist!' );
    end
    
end

% store again in scp_cvx____.
scp_cvx___.nstr.isvdc = true;
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