% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: getcvxopt - get option of CVX solver.
% Date: 20-06-2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function getcvxopt( varargin )

% scp_cvx___ structure.
global scp_cvx___;
if isempty( scp_cvx___ )
    error( sprintf( '%s%s\n%s', '[SCP] This function only runs in ', ...
        'the SCP-CVX mode!', ...
        'You first call "scp_begin" to start ... ' ) );
end

% save the options for cvx solver.
optstr = scp_cvx___.options;

% scan all input variables
for k = 1 : length( varargin )
    mode = varargin{k};
    
    % quiet mode.
    if strcmp( mode, 'quiet' ), optstr.cvxQuiet = true; end
    
    % option for kinds of the problem.
    switch lower( mode )
        case 'quiet',
        case 'set',  % set feasible problem
            optstr.cvxProbType = [ optstr.cvxProbType, ' set' ];
        case 'sdp',  % semidefinite programming
            optstr.cvxProbType = [ optstr.cvxProbType, ' sdp' ];
        case 'gp',   % geometric programming
            optstr.cvxProbType = [ optstr.cvxProbType, ' gp' ];
        case 'separable', % separable problem
            optstr.cvxProbType = [ optstr.cvxProbType, ' separable' ];            
        otherwise,
            error( sprintf( 'Invalid SCP-CVX problem modifier: %s', mode ) );
    end
end

% Keep optional variables.
scp_cvx___.options = optstr;

% it replaces for "subject to" command
scp_cvx___.stkw = 1;

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++