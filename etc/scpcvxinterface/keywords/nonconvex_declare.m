% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: nonconvex_declare - perform the keyword "nonconvex_declare".
% Date: 20-06-2009
% Created by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function nonconvex_declare( funfcn, varargin )

error( nargchk(1, +Inf, nargin ) );
if nargin < 1 
    error( '[SCP] At least one input is provided!' ); 
end

% global variable scp_cvx___
global scp_cvx___;

if isempty( scp_cvx___ )
    error( sprintf( '%s%s\n%s', '[SCP] This function only runs ', ...
           'in SCP-CVX mode!', ...
           'You first call "scp_begin" to start ... ' ) );
end

nstr = scp_cvx___.nstr;
if ~nstr.isvdc
    error( '[SCP] No variable related to NL constraints is declared!' );
end

% check function handle
if isa( funfcn, 'function_handle' )
    nstr.fpter = funfcn;
    
elseif ischar( funfcn )
    nstr.fpter = funfcn;
    
elseif isempty( funfcn ) 
    nstr.fpter = [];
    
else
    error( ['[SCP] Nonlinear function must be a function handle/', ...
            'string expression / empty'] );
end

% check for jacobian function and the rest is parameters.
if nargin > 1
    
    jacbfun = varargin{1}; 
   
    if length( varargin ) > 1, 
        nstr.pars = varargin(2:end);
        
    else
        nstr.pars = []; 
    end
    
    if isa( jacbfun, 'function_handle' )
        nstr.dfptr = jacbfun; 
        
    elseif ischar( jacbfun )
        nstr.dfptr = jacbfun;
        
    elseif isempty( jacbfun )
        nstr.dfptr = []; 
        
    else
        nstr.pars = varargin;
    end
end

% store again structure.
scp_cvx___.nstr = nstr;

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 by Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++