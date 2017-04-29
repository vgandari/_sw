% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: set_path - set the path to the solver.
% Date: 20-06-2009
% Created by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function strpath = scp_paths

% MATLAB path
global scp_cvx___;
mpath = matlabpath;
scppath = which( 'scp_begin' );
cvxpath = which( 'cvx_begin' );
if isempty( scppath )
    clear scp_cvx___;
    error( '[SCP] The SCP solver has not been installed yet! ' );
end
if isempty( cvxpath )
    clear scp_cvx___;
    error( strcat( '[SCP] The CVX solver has not been installed yet!', ...
          'Please download and run "cvx_setup" file!' ) ); 
end

% find the root folder of scp solver.
if ispc
    fs = '\'; ps = ';';  exts = ';';
else
    fs = '/'; ps = ':';  exts = ':';
end
tmp = strfind( scppath, fs );
scppath( tmp(end-1):end ) = [];
subdir = { 'builtins', 'commands', 'functions', 'keywords', ...
           'libs', 'libs/sets', 'optimlib', 'autodiff' };

% update the folders of scp solver.
strpath = '';
for k=1:length( subdir )
    tst = subdir{k};
    tid = ( tst == '/');
    if any( tid ), tst(tid) = fs; end
    tmp = strcat( scppath, fs, tst );
    if exist( tmp, 'dir' )
        tmp2 = strcat( tmp, exts );
        ndxs = strfind( mpath, tmp2 );
        if isempty( ndxs )
            strpath = strcat( strpath, tmp, ';');
        end
    else
        error( '[SCP] The folder does not exist!' ); 
    end
end   

% set again to matlab
if ~isempty( strpath )
    mpath = strcat( strpath, mpath );
    matlabpath( mpath );  
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 by Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++