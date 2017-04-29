% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% FUNCTION: SPARSE - for "cvx" solver.
% Date: 09-06-2009
% Create by: Quoc Tran Dinh, ESAT/SCD and OPTEC, KULeuven, Belgium.
% Supervisor: Prof. Moritz Diehl.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function z = sparse( ik, jk, x, m, n, nz )

if nargin == 1 && isa( ik, 'scpexp' )
    ik.expr  = strcat( 'sparse(', ik.expr,  ')' );
    ik.vexpr = strcat( 'sparse(', ik.vexpr, ')' );
    z = ik;
    return;
end

snz = []; sn = []; sm = [];
if nargin > 5 && isnumeric( nz )
    snz = strcat( ',', num2str( nz ) );
end
if nargin > 4 && isnumeric( n )
    sn  = strcat( ',', num2str( n ) );
end
if nargin > 3 && isnumeric( m )
    sm  = strcat( ',', num2str( m ) );
end
    
if isa( ik, 'scpexp' )
    ikexpr  = ik.expr; ikvexpr = ik.vexpr;
    z      = ik;
elseif isnumeric( ik )
    ikexpr  = mat2str( ik ); ikvexpr = ikexpr;
else
    error( '[SCP] Unknown inputs!' );
end

if isa( jk, 'scpexp' )
    jkexpr  = jk.expr; jkvexpr = jk.vexpr;
    z       = jk;
elseif isnumeric( jk )
    jkexpr  = mat2str( jk ); jkvexpr = jkexpr;
else
    error( '[SCP] Unknown inputs!' );
end

if isa( x, 'scpexp' )
    xexpr  = x.expr; xvexpr = x.vexpr;
    z      = x;
elseif isnumeric( x )
    xexpr  = mat2str( x ); xvexpr = xexpr;
else
    error( '[SCP] Unknown inputs!' );
end

if isa( x, 'scpexp' ) || isa( ik, 'scpexp' ) || isa( jk, 'scpexp' )
    z.expr  = strcat( 'sparse(', ikexpr,  ',', jkexpr, ',', ...
                      xexpr, sm, sn, snz, ')' );
                  
    z.vexpr = strcat( 'sparse(', ikvexpr,  ',', jkvexpr, ',', ...
                      xvexpr, sm, sn, snz, ')' );
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2009 by Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++