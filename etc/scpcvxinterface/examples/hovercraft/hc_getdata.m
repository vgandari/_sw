% ########################################################################
% Function: [ ... ] = hc_getdata
% Purpose: Get data from user.
%          Apply the SCP algorithm based on CVX solver.   
% Created by: Quoc Tran Dinh, ESAT/SCD-OPTEC, KULeuven, Belgium
% Date: 22-06-2009
%
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ########################################################################
function [ Q, R, Sf, x0, Tf, Hp ] = hc_getdata( choose )


if( choose <= 2 )
    
    % This data takes from paper: Nonlinear receding horizon control of
    % an underactuated hovercraft. In this case
    %                 Hp = 15, xref = 0, Tf = 1, alpha = 1.
    %                 x0 = [-0.83; 0; 0; 0; 0; 0; 0]
    %            or   x0 = [-0.38; 0.30; 0.052; 0.0092; -0.0053; 0.002];
    
    %+ Coefficient of objective function.
    Q  = [5; 10; 0.1; 1; 1; 0.01]; 
    R  = [0.01; 0.01];
    Sf = [5; 15; 0.05; 1; 1; 0.01];
    
else
    
    % This data takes from paper: Realtime algorithm by Shimazu, Ohtsuka 
    % and M. Diehl. In this case
    %             Hp = 10, 20, 30 and Tf = 1, 2, 3, respectively
    %             x0 = x0 = [-0.3; 0.4; 0; 0; 0; 0];   
    
    % Coefficient of objective function.
    Q  = [20; 25; 0.1; 1; 1; 0.01]; 
    R  = [0.1; 0.1];
    Sf = [20; 25; 0.1; 1; 1; 0.01];
end;
    
switch( choose )
    
    case 1 % Case 1.1.
    % initial point: the first case.
    x0 = [ -0.83; 0; 0; 0; 0; 0 ];
     
    % size of horizon moving and horizon time.
    Tf = 1; Hp  = 15;
    
    case 2 % Case 1.2.
    % Initial point: the second case.
    x0 = [-0.38; 0.30; 0.052; 0.0092; -0.0053; 0.002];
    
    % Size of horizon moving and horizon time.
    Tf = 1; Hp  = 15;
    
    case 3 % Case 2.1.
    % Initial points.
    x0 = [-0.3; 0.4; 0; 0; 0; 0];

    % Size of horizon moving and horizon time.
    Tf = 1; Hp  = 10; 
    
    case 4 % Case 2.2
    % Initial points.
    x0 = [-0.3; 0.4; 0; 0; 0; 0];
    Tf = 2; Hp = 20;
    
    otherwise
    % Initial points.
    x0 = [-0.3; 0.4; 0; 0; 0; 0];
    Tf = 3; Hp = 20;
    
end
% ########################################################################
% End
% ########################################################################