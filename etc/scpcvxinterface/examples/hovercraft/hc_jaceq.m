% #######################################################################
% Function: [ ... ] = hc_jaceq( ... )
%+ This function computes jacobian matrix of equality constraints G(w) = 0.
%
% Created by: Quoc Tran Dinh, ESAT/SCD-OPTEC, KULeuven, Belgium
% Date: 22-06-2009
%
% Copyright 2009 Quoc Tran Dinh and Moritz Diehl.
% See the file COPYING.txt for full copyright information.
% The command 'scp_where' will show where this file is located.
% #######################################################################
function jacfval = hc_jaceq( x4, x5, u1, u2, n, x0, h, M, I, r )

% Compute the coefficient constants 
A = h/M;
B = h*r/I;

% The iterative loop to compute the function components.
x3 = x0(3);
x6 = x0(6);

for k=1:n
    % compute A*cos( x3 ), A*sin( x3 ) and Bh.
    Acosx3 = A*cos( x3 );
    Asinx3 = A*sin( x3 );
    Bh = B*h;
    
    % compute the derivative components
    if( k == 1 )
        % if k==1 then compute directly.
        jacfval( 2*k-1, k )       = -1;
        jacfval( 2*k-1, 2*n+k )   = Acosx3; 
        jacfval( 2*k-1, 3*n+k ) = Acosx3; 
        jacfval( 2*k, n+k )       = -1;
        jacfval( 2*k, 2*n+k )     = Asinx3; 
        jacfval( 2*k, 3*n+k )     = Asinx3; 

    else % if k>1 then compute by 'for' loop.
        
        jacfval( 2*k-1, k-1 )   = 1;
        jacfval( 2*k-1, k ) = -1;
        jacfval( 2*k-1, 2*n+k ) = Acosx3;
        jacfval( 2*k-1, 3*n+k ) = Acosx3;
        
        jacfval( 2*k, n+k-1 )   = 1;
        jacfval( 2*k, n+k ) = -1;
        jacfval( 2*k, 2*n+k ) = Asinx3;
        jacfval( 2*k, 3*n+k ) = Asinx3;
        
        for i=1: k-2
            
            uAsinx3Bh = (u1(k)+u2(k))*Asinx3*(k-i-1)*Bh;
            jacfval(2*k-1, 2*n+i) = -uAsinx3Bh;
            jacfval(2*k-1, 3*n+i) =  uAsinx3Bh;
            
            uAcosx3Bh = (u1(k)+u2(k))*Acosx3*(k-i-1)*Bh;
            jacfval(2*k, 2*n+i) =  uAcosx3Bh;
            jacfval(2*k, 3*n+i) = -uAcosx3Bh;
            
        end;
               
    end;
    
    % compute x3(k)
    x3 = x3 + h*x6;
    
    % compute x6(k).
    x6 = x6 + B*( u1(k) - u2(k) );
    
end;

% #######################################################################
%% End of the function.
% #######################################################################
