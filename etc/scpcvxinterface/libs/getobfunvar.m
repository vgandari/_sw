% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: getobfunvar - get variable from objective function
% Date: 09-06-2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function [ ovlist, nvlist ] = getobfunvar( objexp, vlist ) 

if ischar( objexp )
    nlsz = length( vlist ); onv = 0;
    for k=1:nlsz
        if findstr( vlist{k}, objexp )
            onv = onv + 1;
            nvlist{onv} = vlist{k};
            if exist( vlist{k}, 'var' )
                ovlist{onv} = eval( vlist{k} );
            end
        end
    end
else
    ovlist = []; nvlist = [];
end
    
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++