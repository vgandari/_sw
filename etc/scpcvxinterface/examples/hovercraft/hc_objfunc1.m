% #######################################################################
%% Function: [ ... ] = hc_objfunc1( ... )
%+
%+ This function computes value of objective function F(w).
%+ Date: October 28, 2008.
%+ By: Quoc Tran Dinh, SCD/ESAT & OPTEC, KULeuven, Belgium.
%+
% #######################################################################
function  objfval  = hc_objfunc1( wx, nw, x0, hstep, Q, R, Sf, I, r )


% Length of variables: w = ( x4, x5, u1, u2).
n  = nw / 4;

% compute matrix related to objective function
const = r/I;
Mn = hstep*tril( ones( n ), -1 );
en = ones( n, 1 );

% Make the diagonal matrices
dQ1 = diag( [ Q(1)*ones(n-1,1); Sf(1) ] );
dQ2 = diag( [ Q(2)*ones(n-1,1); Sf(2) ] );
dQ3 = diag( [ Q(3)*ones(n-1,1); Sf(3) ] );
dQ4 = diag( [ Q(4)*ones(n-1,1); Sf(4) ] );
dQ5 = diag( [ Q(5)*ones(n-1,1); Sf(5) ] );
dQ6 = diag( [ Q(6)*ones(n-1,1); Sf(6) ] );


% For the last line.
Qx4 = Mn'*dQ1*Mn + dQ4;
qx4 = 2*x0(1)*en'*dQ1*Mn;
q04 = x0(1)*x0(1)*en'*dQ1*en;

Qx5 = Mn'*dQ2*Mn + dQ5;
qx5 = 2*x0(2)*en'*dQ2*Mn;
q05 = x0(2)*x0(2)*en'*dQ2*en;

p03 = x0(3)*en + x0(6)*Mn*en;
Px3 = const*Mn*Mn;

Qu12 = Px3'*dQ3*Px3 + const*const*Mn'*dQ6*Mn;
qu12 = 2*p03'*dQ3*Px3 + 2*x0(6)*const*en'*dQ6*Mn;
q012 = p03'*dQ3*p03 + x0(6)*x0(6)*en'*dQ6*en;

% Compute the objective value
objfval = wx(1:n)'*Qx4*wx(1:n) + qx4*wx(1:n) + q04 ...
          + wx(n+1:2*n)'*Qx5*wx(n+1:2*n) + qx5*wx(n+1:2*n) + q05 ...
          + (wx(2*n+1:3*n) - wx(3*n+1:4*n))'*Qu12*(wx(2*n+1:3*n) - wx(3*n+1:4*n)) ...
          + qu12*(wx(2*n+1:3*n) - wx(3*n+1:4*n)) + q012 ...
          + R(1)*wx(2*n+1:3*n)'*wx(2*n+1:3*n) + R(2)*wx(3*n+1:4*n)'*wx(3*n+1:4*n);
      

objfval = 0.5*objfval;

% #######################################################################
% End of this function
% #######################################################################    