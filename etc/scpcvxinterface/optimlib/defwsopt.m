% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Function: getdefopt - get default options
% Date: 18/06/2009
% Create by: Quoc Tran Dinh - ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function defws = defwsopt( )

defws = struct( ...
    'MaxSCPIter', 50, ...      % the maximum number of iterations
    'MaxDIRIter', 30, ...
    'MaxLSIter', 30,  ...
    'MaxTRIter', 30,  ...
    'MaxFTIter', 30,  ...
    'MaxLSDIRIter', 30, ...
    'MaxEvalFunc', 1500,  ...    % the maximum number of evaluate functions
    'TolF', eps^0.25, ...            % tolerances
    'TolX', eps^0.25, ...
    'TolCon', eps^0.25, ...
    'TolDir', eps^0.5, ...          % tolerance for the search direction
    'TolLS', eps^0.5, ...           % tolerance for the line search
    'Algorithm', 'scp', ...    % algorithm
    'Solver', 'cvx', ...            % solver
    'DIRMethod', 'interior-point', ...     % method for solver sub-problem
    'GlobalStrategy', 'line-search', ...   % globalization strategy
    'Display', 'iter', ...          % display information optional 
    'RunningMode', 'debug', ...     % running mode ( quiet | debug )
    'GetInfoEachStep', 1, ...       % get the information at each step.
    'MaxStepSize', 1,  ...     % maximum and minimum of the step size
    'MinStepSize', 1e-4, ...      
    'BackTrackingStep', 0.5, ...    % bactracking step size in line-search
    'InitPenaltyPar', 1,  ...  % initial value of penalty parameter
    'ArmijoPar', 1e-4, ...     % Armijo parameter in line-search ( c1 )
    'WolfePar', 0.1, ...       % Wolfe parameter in line - search ( c2 )
    'LSInterpPar1', 0.1, ...   % Parameter for the interpolation in LS.
    'LSInterpPar2', 0.5, ...
    'InitTRRadius', 1, ...     % initial radius of the trust region
    'PenaltyIncrease', 0.5, ...      % increasing penalty parameter.
    'cvxQuiet', false, ...           % running mode for cvx solver
    'cvxPrecision', 'default', ...   % precision of cvx solver
    'cvxProbType', '', ...     % cvx problem type: gp, sdp, set, ...
    'cvxVarType', '', ...      % type of variables in cvx solver
    'cvxSolver', 'sdpt3', ...  % the solver is used for cvx.
    'cvxExpert', false, ...    % cvx expert option.
    'GradObj', 'off', ...      % compute the gradient or not
    'JacbCon', 'fun_then_jac' );     % compute the gradient or not
   
% end of this function
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++