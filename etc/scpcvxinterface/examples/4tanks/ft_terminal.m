% ------------------------------------------------------------------------
% Function: ft_terminal -This function constructs the terminal constraint:
%                     (x - xref)'*Sf*(x-xref) <= rhof.
%
% Created by: Quoc Tran Dinh, ESAT/SCD-OPTEC, KULeuven, Belgium
% Date: 22-06-2009
%
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% ------------------------------------------------------------------------
function [Sf, rhof ] = ft_terminal( xref, uref, h, Q, R,  lbx, ...
                       ubx, lbu, ubu, A1, A2, A3, A4, a1, a2, a3, a4, ...
                       gamma1, gamma2, k1, k2, g )

% Compute A = Dfx and B = Dfu for linear dynamic system: x' = Ax+Bu
[ Dfx, Dfu ] = ft_dfxu( xref, uref, A1, A2, A3, A4, a1, a2, a3, a4, g, ...
                              gamma1, gamma2, k1, k2 );           

% Recalculate the discrete matrix.
Ex = eye(4);
Ae = ( Ex + h*Dfx );
Be = h*Dfu;

% Compute Sf and feedback control K: u = -Kx.
[ K ,Sf, E ] = dlqr( Ae, Be, Q, R );

% Compute maximum of rhof such that: terminal set belongs to constrained
% set
invSf = inv( Sf );
n = length( ubx );

p = -K(1,:)'; s11 = p'*invSf*p;
q = -K(2,:)'; s22 = q'*invSf*q;
r1 = (ubu(1)-p'*xref)*(ubu(1)-p'*xref)/s11;
r2 = (-lbu(1)+p'*xref)*(-lbu(1)+p'*xref)/s11;
r3 = (ubu(2)-p'*xref)*(ubu(2)-p'*xref)/s22;
r4 = (-lbu(2)+p'*xref)*(-lbu(2)+p'*xref)/s22;

for k=1:n
    rho1(k,1) = (ubx(k)-xref(k))*(ubx(k)-xref(k)) / invSf(k,k);
    rho2(k,1) = (xref(k)-lbx(k))*(xref(k)-lbx(k)) / invSf(k,k);
end

rhof = min([rho1; rho2; r1; r2; r3; r4]);

% ------------------------------------------------------------------------
% End.
% ------------------------------------------------------------------------