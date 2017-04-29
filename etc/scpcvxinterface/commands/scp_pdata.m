% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: scp_pdata ...
% Purpose: declare the global variables which are used in this package.
% Date: 20-06-2009
% Created by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

% recall the global variable.
global scp_cvx___;

% path to the solver.
strpath___ = scp_paths();

% if this variable is declared, clear it
if ~isempty( scp_cvx___ ) && isfield( scp_cvx___, 'options' )
    defopt___ = scp_cvx___.options;
    defopt___ = chkwsopt( defopt___ );
    % clear global variable scp_cvx___ before creating it.
    evalin( 'caller', 'clearvars -global scp_cvx___' );
    scp_cloput( 'init' );
    global scp_cvx___;
else
    defopt___ = defwsopt( );
end

% asign default values for scp_cvx___.
if isempty( scp_cvx___ )
    
    % structure for objective function
    fstr = struct(  ...
        'obfun', [], ...        % object for objective function.
        'obdir', -1, ...        % = -1 -> minimize, = +1 -> maximize
        'obexp', '', ...        % expression of the objective function.
        'grfun', [], ...        % gradient object of objective function
        'grexp', '');           % gradient expresion.
    
    % structure for variable
    vstr = struct(  ...
        'vname', 'xsolk', ...   % default name using in scp-solver      
        'vlist', [], ...        % list of variable objects
        'inval', [], ...        % initial varlue
        'vaobj', [], ...        % related to the objective function.
        'vacon', [] );          % related to nonlinear equality constraints
    
    % structure for dual variables
    dstr = struct( ...
        'dname', 'dLnz', ...    % default dual name using in scp-solver.
        'dlist', [], ...        % list of dual variable objects
        'dlsnm', [] );          % list of dual variable names.
    
    % structure for convex constraints
    cstr = struct(   ...
        'colst', [], ...        % constraint object list
        'clist', [], ...        % list of constraints
        'oplst', [], ...        % relation operation
        'cltex', [], ...        % extended list of constraints
        'clknd', [] );          % list of constraint kind.
        
    
    % structure for the nonlinear constraints. 
    nstr = struct(   ...  
        'isvdc', false, ... % does variables declare?
        'order',  [],   ... % order of the index variables
        'pars',  [],    ... % list of variable object ralated to nonlinear eq.
        'fpter', [],    ... % pointer to the equality function
        'dfptr', []);       % pointer to the jacobian

    
    % scp_cvx___ data structure
    % note that: stkw = 1 - "subject to", stkw = 2 -convex_begin_declare
    % stkw = 3, convex_end_declare
    scp_cvx___  = struct( ...
        'options', defopt___,  ...  % workspace options
        'fstr', fstr, ...           % for objective function
        'vstr', vstr, ...           % for variabls
        'dstr', dstr, ...           % for dual variables
        'cstr', cstr, ...           % convex constraints
        'nstr', nstr, ...           % non-convex constraints.
        'stkw', 0, ...              % subject to keword call.
        'path', strpath___, ...     % path to the solver. 
        'info', [] );               % extra information.
    
    % clear intermediate structures.
    clearvars fstr vstr dstr cstr nstr;
end

% clear temparatory variables
clearvars defopt___ strpath___;

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 by Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++