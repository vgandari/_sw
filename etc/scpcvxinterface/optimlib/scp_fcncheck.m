% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: scp_fcncheck - this function check the nonlinear part for 
% optimization problems.
% This function is designed based on Matlab part: optimlib.
% Date: 20-06-2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function [ funcells, msgf ] = scp_fcncheck( gfx, szpars, constrflag )

if nargin < 3, constrflag = 0; end;
jacerrmsg = 'Jacobian function expected (WSPARS.JacbCon=''on'') but not found.';
warnstr = ...
    sprintf('%s\n%s\n%s\n','Jacobian function provided but WSPARS.JacbCon=''off'';', ...
    '  ignoring gradient function and using finite-differencing.', ...
    '  Rerun with WSPARS.JacbCon=''on'' to use jacobian function.');

if constrflag == 1,     calltype = 'funjac'; 
elseif constrflag == 2, calltype = 'fun_then_jac'; 
else                    calltype = 'fun'; end
funcells = {}; funfcn = []; jacbfcn = [];

% check gfx is cell or not and only function is provided {fun}.
if isa( gfx, 'cell' ) && length( gfx ) == 1
    if constrflag, error( jacerrmsg );  end
    [funfcn, msgf] = scp_fcnchk( gfx{1}, szpars );
    if ~isempty( msgf ), error( msgf );  end
    
% gfx is a cell, function and empty jacobian is provided ({fun, []}).
elseif isa( gfx, 'cell') && length(gfx) == 2 && isempty( gfx{2} )
    if constrflag, error( jacerrmsg ); end
    [funfcn, msgf] = scp_fcnchk( gfx{1}, szpars );
    if ~isempty( msgf ), error( msgf ); end

% gfx is a cell, function and jacobian are provided {fun, jacb}
elseif isa(gfx, 'cell') && length(gfx) == 2 
    [funfcn, msgf] = scp_fcnchk( gfx{1}, szpars );
    if ~isempty(  msgf ) error( msgf ); end
    [ jacbfcn, msgf ] = scp_fcnchk( gfx{2}, szpars );
    if ~isempty( msgf ), error( msgf ); end
    calltype = 'fun_then_jac';
    if ~constrflag, warning( warnid, warnstr ); calltype = 'fun'; end

% gfx is not a cell - may be a function_handle/str/object.
elseif ~isa(gfx, 'cell') 
    [funfcn, msgf] = scp_fcnchk( gfx, szpars );
    if ~isempty( msgf ), error( msgf ); end
    if constrflag, jacbfcn = funfcn; end;
    
% otherwise - error.    
else
    errmsg = sprintf('%s\n%s', ...
        '[SCP] FUNCTION must be a function or FUNCTION may be a cell', ...
        ' array that contains these type of objects.');
    error( errmsg );
end

% store function to funcells - for output.
funcells{1} = calltype;
funcells{2} = funfcn;
funcells{3} = jacbfcn;

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Function: fcnchk - This function check FUNCTION 
% It is created based on OPTIMIZATION Matlab lib: optimlib.
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function [ f, msg ] = scp_fcnchk( fun, varargin )

message = ''; msgident = '';
if nargin > 1 && strcmp( varargin{end}, 'vectorized' ), vectorizing = true; 
else vectorizing = false; end

% function is a string.
if ischar( fun )
    fun = remove_blank( fun );
    if ~vectorizing && isidentifier_local_function( fun )
        f = str2func( fun ); 
        if isequal( 'x', fun )
            warning( ['Ambiguous expression or function input.', ...
                '\n The string ''x'' will be interpreted as the name', ...
                ' of a function called ''x''', ...
                '\n (e.g., x.m) and not as the mathematical expression', ...
                '''x'' (i.e., f(x)=x).', ...
                '\n Use the anonymous function:  @(x)x  ',...
                'if you meant the mathematical expression ''x''.']);
        end
    end
% function is a function handle.
elseif isa( fun,'function_handle' ) 
    f = fun; 
% function is an object
elseif isobject( fun )
    [ meths, cellInfo ] = methods( class(fun), '-full' );
    if ~isempty( cellInfo ), meths = cellInfo{:,3}; end
    if any( strmatch( 'feval',meths ) )
       if vectorizing && any( strmatch( 'vectorize', meths ) )
          f = vectorize( fun );
       else f = fun; end
    else
        f = '';
        message = 'If FUNCTION is a MATLAB object, it must have an feval method.';
        msgident = 'MATLAB:fcnchk:objectMissingFevalMethod';
    end
else
    f = '';
    message = ['FUN must be a function, a valid string expression, ', ...
            sprintf('\n'),'or an inline function object.'];
    msgident = 'MATLAB:fcnchk:invalidFunctionSpecifier';
end
if nargout < 2 && isempty( message ), return; end

% compute MSG
if isempty( message ), 
    msg.message = ''; msg.identifier = ''; msg = msg(zeros(0,1)); 
else
    msg.message = message; msg.identifier = msgident;
end
if nargout < 2, error(msg); end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Function: remove_blank - remove the space in the function
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function s1 = remove_blank( s )

if isempty(s), s1 = s; 
else 
    c = find(s ~= ' ' & s ~= 0); s1 = s(min(c):max(c));
end
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Function: isidentifier_local_function( str )
% Note that we avoid collision with line 45: f = str2func('isidentifier')
% by uglifying the local function's name
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function tf = isidentifier_local_function(str)

tf = false;
if ~isempty(str)
    first = str(1);
    if (isletter(first))
        letters = isletter(str);
        numerals = (48 <= str) & (str <= 57);
        underscore = (95 == str);
        tf = all(letters | numerals | underscore);
    end
end
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++