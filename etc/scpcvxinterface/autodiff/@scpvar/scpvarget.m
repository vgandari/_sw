% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: scpvarget - get attributes from "scpvar" class
% Date: 20-06-2009
% Created by: Quoc Tran Dinh, a PhD student at ESAT/SCD and OPTEC,
% KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function attr = scpvarget( x, opt )

if isa( x, 'scpvar' )
    if nargin < 2, attr = x.val; end
    switch( opt )
        case 'val',  attr = x.val;
        case 'size', attr = x.size;
        case 'diff', attr = x.diff;
    end
else
    attr = [];
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

