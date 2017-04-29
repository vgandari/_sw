% #######################################################################
% Function: [ ... ] = hc_objfunc( ... )
%
% Created by: Quoc Tran Dinh, ESAT/SCD-OPTEC, KULeuven, Belgium
% Date: 22-06-2009
%
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% #######################################################################
function  objfval  = hc_objfunc( w, nw, x0, h, Q, R, Sf, I, r )

% Length of variables: w = ( x4, x5, u1, u2).
n  = nw / 4;

% Compute matrix B.
B = h*r/I;
dagQ = diag(Q); dagR = diag(R); dagSf = diag(Sf);

% Get the components of w = ( x4, x5, u1, u2).
x4 = w( 1: n, 1 );
x5 = w( n+1:2*n, 1 );
u1 = w( 2*n+1:3*n, 1 );
u2 = w( 3*n+1:4*n, 1 );

% The iterative loop to compute the function components.
x1 = x0(1);
x2 = x0(2);
x3 = x0(3);
x6 = x0(6);

% Init objfval = 0.
objfval = 0;

% This loop computes the value of objective function.
for k=1:n-1
    
    if( k == 1 )
       % compute value of objective function.
       x = [ x1; x2; x3; x0(4); x0(5); x6 ];
       u = [u1(k); u2(k)];
       
       objfval = objfval + x'*dagQ*x + u'*dagR*u;

       % compute the value of x1, x2, x3.   
       x1 = x1 + h*x0(4);
       x2 = x2 + h*x0(5);
       x3 = x3 + h*x0(6);
       
    else
       % compute value of objective function.
       x = [ x1; x2; x3; x4(k-1); x5(k-1); x6 ];
       u = [u1(k); u2(k)];
           
       objfval = objfval + x'*dagQ*x + u'*dagR*u;
       
       % compute the value of x1, x2, x3.   
       x1 = x1 + h*x4(k-1);
       x2 = x2 + h*x5(k-1);
       x3 = x3 + h*x6;
    end;
    
    % compute the value of x6.
    x6 = x6 + B*( u1(k) - u2(k) );
end
    
% compute the last component.
x = [ x1; x2; x3; x4(n); x5(n); x6 ];

% and its value.
objfval = 0.5*( objfval + x'*dagSf*x );

% #######################################################################
% End of this function
% #######################################################################    