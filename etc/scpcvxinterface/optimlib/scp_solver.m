% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: scp_solver - Call the scp_cvx solver from kernel of scp method.
% Date: 20-06-2009
% Created by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function [ xsol, fsol, dsol, exitflag, pinfo, dinfo, xoutexp, doutexp ] ...
           = scp_solver( prob )
 
if ~isempty( prob )
    
    % ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    % Process data 
    % ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    wspars = prob.options;
    fstr   = prob.fstr;
    vstr   = prob.vstr;
    dstr   = prob.dstr;
    cstr   = prob.cstr;
    nstr   = prob.nstr;
    % check options
    wspars = chkwsopt( wspars );
    
    % ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    % Process variables
    % ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    numOfVars = length( vstr.vlist );
    varexp    = [];   % for variable declaration expression
    vregexp   = [];   % for regularization term expression
    xkforg    = [];   % for g(x) function expression. g( x, y, z) ...
    xfordgf   = [];   % for gk + Jgk*(x-xk) expression [x; y; z]  ...
    xkexp     = [];   % for iterative expression: xk = [ x1k; x2k; ... ]
    xoutexp   = [];   % for output expression
    x0        = [];   % for initial point x0.
    index     = 1;    % index counter.
    
    for k=1:numOfVars
        
        item = vstr.vlist{k};
        
        if isa( item, 'scpexp' )
            
            % ----------------------------------------------------
            % get attributes and make variable expression
            % ----------------------------------------------------
            vexpstr = getattr( item, 'vexpr' );
            vtype   = getattr( item, 'type' );
            name    = getattr( item, 'name' );
            
            if isempty( vtype )
                varexp = [ varexp, 'variable ', vexpstr, ';' ];
            else
                varexp = [ varexp, 'variable ', vexpstr, ' ', vtype, ';' ];
            end
            
            % make expression for iterative variable
            xkexp = strcat( xkexp, 'reshape(', name, ', prod(size(', ...
                            name, ')), 1);' ); 
            
            % ----------------------------------------------------
            % get initial value
            % ----------------------------------------------------
            inval  = vstr.inval{k};
            szntmp = prod( size( inval ) );
            x0 = vertcat( x0, reshape( inval, szntmp, 1 ) );
            
            % ----------------------------------------------------
            % create variable expression for g(x).
            % ----------------------------------------------------
            sz = size( getattr( item, 'value' ) ); 
            cind1 = num2str( index ); 
            cind2 = num2str( index + prod(sz) - 1 );
            
            itemxk = strcat( '(', cind1, ':', cind2, ')' );
            xoutexp = strcat( xoutexp, name, '=reshape(xsol', itemxk, ...
                      ',', mat2str( sz ), ');' ); 
            
            if any( vstr.vacon{k} )
                xfordgf = strcat( xfordgf, 'reshape(', name, ...
                                  ', prod(size(', name, ')), 1);' ); 
                xkforg  = strcat( xkforg, 'xsolk', itemxk, ',' );
            end
            
            % compute index
            index = index + prod(sz);
            
            % ----------------------------------------------------
            % make the regularization term expression
            % ----------------------------------------------------
            tmp1 = strcat( 'transpose(reshape(', name,',', ...
                   num2str(szntmp), ',1)-xsolk', itemxk, ')', ...
                   '*(reshape(', name,',', num2str(szntmp), ...
                   ',1)-xsolk', itemxk, ')' );
            
            vregexp = strcat( vregexp, '+', tmp1 );
            
        end
        
    end
    
    % delete the ',' character.
    if ~isempty( xkforg )
        xkforg  = xkforg( 1:end-1 ); 
    end
    
    if ~isempty( vregexp )
        vregexp = strcat( '(', vregexp(2:end), ')' );
    end
    
    if ~isempty( xkexp )
        xkexp   = strcat( '[', xkexp( 1:end-1 ), ']' ); 
    end
    
    if ~isempty( xkexp )
        xfordgf = strcat( '[', xfordgf(1:end-1), ']' );
    end
        
    % ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    % Process dual variables
    % ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    numOfDuals = length( dstr.dlist );
    
    dualexp  = [];  % for dual variable declaration expression
    doutexp  = [];  % for output dual expression
        
    for k=1:numOfDuals
        item = dstr.dlist{k};
        
        if isa( item, 'scpdual' )
        
            % ----------------------------------------------------
            % express the dual variable declaration.
            % ----------------------------------------------------
            dexpstr = getdattr( item, 'dexpr' );
            dualexp = [dualexp, 'dual ', dexpstr, ';' ];
            
            % ----------------------------------------------------
            % express the output for dual variables
            % ----------------------------------------------------
            tmp = getdattr( item, 'name' );
            tmp = strcat( 'assignin(', char(39), 'caller', char(39), ...
                  ',', char(39), tmp, char(39), ', dsol.', tmp, ');' );
            doutexp = strcat( doutexp, tmp );
        end
    end
    
    % this variable for the linearization constraint.
    if ~isempty(  nstr.fpter )
        tmp = dstr.dname;
        tmp = strcat( 'assignin(', char(39), 'caller', char(39), ...
                      ',', char(39), tmp, char(39), ', dsol.', tmp, ');' );
        doutexp = strcat( doutexp, tmp );
    end
    
    % ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    % Process objective function
    % ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    if ~isempty( fstr.obfun ) && isa( fstr.obfun, 'scpexp' )
        
        %objexp = getattr( fstr.obfun, 'vexpr' );
        objexp = getattr( fstr.obfun, 'expr' );
        
        if fstr.obdir == -1,
            objexp = strcat( 'minimize(', objexp, ');' );
            
        elseif fstr.obdir == 1,
            objexp = strcat( 'maximize(', objexp, ');' );
            
        else
            objexp = [];
            
        end
    else
        objexp = []; 
    end;
    
    % get vector c from fstr
    cvec = fstr.grfun(:);
        
    % ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    % Process convex constraints.
    % ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    numOfConstr = length( cstr.clist );
    omegaset    = []; 
    isNotConic  = false; % 
    
    for k=1:numOfConstr
        
        if ischar( cstr.clist{k} )
            omegaset = strcat( omegaset, cstr.clist{k}, ';' );
        end
        
        if ~isempty( cstr.clknd{k} )
            isNotConic = true;
        end
    end
    
    wspars.isNotConic = isNotConic;
    
    % ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    % process nonlinear constraints
    % ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    gfx = nstr.fpter; 
    jgfx = nstr.dfptr; 
    pars = nstr.pars;
    
    % ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    % call solver
    % ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
       
    [ xsol, fsol, dsol, exitflag, pinfo, dinfo ] = scp_mainalg( ...
      varexp, dualexp, objexp, omegaset, gfx, jgfx, xkforg, xfordgf, ...
      x0, xkexp, cvec, vregexp, wspars, pars );
  
else
    error( '[SCP] SCP problem does not exist!' );
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++