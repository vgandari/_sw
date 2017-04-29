%**************************************************************************
% Purpose: This function computes the coordinate of the function r(s) in 
% -------  Caterian coordinate system r(s) = (x(s), y(s)) and its 
%          derivatives 
% 
% Date: 27/01/2008
% Quoc Tran Dinh, OPTEC-SCD, ESAT, KULeuven, Belgium.
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%**************************************************************************
function [ x0, y0, dx, dy, d2x, d2y, d3x, d3y ] = cm_pfunc( s, pars, xsp, ysp )

switch( pars ) 
    
    case 1 % 3-order polynomial path.

        % parameterize the path r0(s) = (x0(s), y0(s)).
        scalex = 50;
        scaley = 10;

        x0 = scalex*(s-0.5);
        y0 = scaley*(20*s.*s.*s - 30*s.*s + 10*s);
        
        dx = scalex*1;
        dy = scaley*(60*s.*s - 60*s + 10);
        
        d2x = 0;
        d2y = scaley*(120*s - 60);
        
        d3x = 0;
        d3y = scaley*120;

    case 2 % parabol path.

        % function
        x0 = 50*(s-0.5);
        y0 = 50*(s*s - s);

        % derivatives
        dx = 50;
        dy = 50*(2*s - 1);

        d2x = 0; 
        d2y = 100;

        d3x = 0; 
        d3y = 0;
    
    case 3 % the path based on sin function
        scalex = 6;
        scaley = 6;
        
        s0 = 4*pi*(s-0.5);
        x0 = scalex*s0;
        y0 = scaley*sin( s0 );
        
        dx = scalex*4*pi;
        dy = scaley*4*pi*cos( s0 );
        
        d2x = 0;
        d2y = -scaley*(4*pi)^2*sin( s0 );
        
        d3x = 0;
        d3y = -scaley*(4*pi)^3*cos( s0 );

    case 4 % the line
        
        x0 = 10*(s-0.5);
        y0 = 10*(s-0.5);
        
        dx = 10;
        dy = 10;
        
        d2x = 0;
        d2y = 0;
        
        d3x = 0;
        d3y = 0;

    %==========================
    % Case 5. Circle
    %==========================
    case 5  
        scale = 20;
        x0 = scale*cos( 2*pi* s );
        y0 = scale*sin( 2*pi* s );

        dx = -scale*2*pi*sin( 2*pi*s );
        dy = scale*2*pi*cos( 2*pi*s );

        d2x = -scale*4*pi*pi*cos( 2*pi*s );
        d2y = -scale*4*pi*pi*sin( 2*pi*s );

        d3x = scale*8*pi*pi*pi*sin( 2*pi*s );
        d3y = -scale*8*pi*pi*pi*cos( 2*pi*s );

    %==========================
    % Case 6. the 4th polynomial
    %==========================
    case 6
        scalex = 50;
        scaley = 500;

        x0 = scalex*(s-0.5);
        y0 = scaley*(s-0.1)*(s-0.2)*(s-0.8)*(s-0.9);
        % y0 = scale*(s*s*s*s - 2*s*s*s + 1.25*s*s - 0.25*s + 0.0144);

        dx = scalex;
        dy = scaley*( 4*s*s*s - 6*s*s + 2.5*s - 0.25 );

        d2x = 0;
        d2y = scaley*( 12*s*s - 12*s + 2.5 );

        d3x = 0;
        d3y = scaley*( 24*s - 12 );
        
    %==========================
    % Case 7. curvature
    %==========================
    case 7
        
	nsp = length( xsp )-1;
    tsp = 0:1/nsp:1;
	px = spline( tsp, xsp );
    py = spline( tsp, ysp ); 
    x0  = ppval( px, s );
    y0  = ppval( py, s );

    d1px = px; 
    d1px.order = 3;
    d1px.coefs = px.coefs*diag([3,2,1,0]);
    dx = ppval( d1px, s );
    
    d1py = py; 
    d1py.order = 3;
    d1py.coefs = py.coefs*diag([3,2,1,0]);
    dy = ppval( d1py, s );
    
    d2px = d1px;
    d2px.order = 2;
    d2px.coefs = d1px.coefs*diag([2,1,0,0]);
    d2x = ppval( d2px, s );
    
    d2py = d1py;
    d2py.order = 2;
    d2py.coefs = d1py.coefs*diag([2,1,0,0]);
    d2y = ppval( d2py, s );
    
    d3px = d2px;
    d3px.order = 1;
    d3px.coefs = d2px.coefs*diag([1,0,0,0]);
    d3x  = ppval( d3px, s );
    
    d3py = d2py;
    d3py.order = 1;
    d3py.coefs = d2py.coefs*diag([1,0,0,0]);
    d3y  = ppval( d3py, s );
    
    %==========================
    % Case 8. 
    %==========================
    case 8
        scale = 5;

        x0 = scale*(pi*s-sin(pi*s));
        y0 = scale*(1-cos(pi*s));

        dx = scale*(pi-pi*cos(pi*s));
        dy = scale*pi*sin(pi*s);

        d2x = scale*pi*pi*sin(pi*s);
        d2y = scale*pi*pi*cos(pi*s);

        d3x = scale*pi*pi*pi*cos(pi*s);
        d3y = -scale*pi*pi*pi*sin(pi*s);
    
	%==========================
    % Case 9. 
    %==========================
    case 9
        scale = 5;

        x0 = scale*(2*cos(2*pi*s)-cos(4*pi*s));
        y0 = scale*(2*sin(2*pi*s)-sin(4*pi*s));

        dx = scale*(-4*pi*sin(2*pi*s) + 4*pi*sin(4*pi*s));
        dy = scale*(4*pi*cos(2*pi*s)-4*pi*cos(4*pi*s));

        d2x = scale*(8*pi*pi*cos(2*pi*s) + 16*pi*pi*cos(4*pi*s));
        d2y = scale*(-8*pi*pi*sin(2*pi*s) + 16*pi*pi*sin(4*pi*s));

        d3x = scale*(-16*pi*pi*pi*sin(2*pi*s) - 64*pi*pi*pi*sin(4*pi*s));
        d3y = scale*(-16*pi*pi*pi*cos(2*pi*s) + 64*pi*pi*pi*cos(4*pi*s));
  
    %==========================
    % Case 10. 
    %==========================
    case 10
        scale = 10;
        shift = 20;

        x0 = ( shift + scale*cos(4*pi*s) )*cos( 2*pi*s );
        y0 = ( shift + scale*cos(4*pi*s) )*sin( 2*pi*s );

        dx = -2*pi*( shift + scale*cos(4*pi*s) )*sin( 2*pi*s ) ...
             -4*pi*scale*sin(4*pi*s)*cos( 2*pi*s );

        dy = 2*pi*( shift + scale*cos(4*pi*s) )*cos( 2*pi*s ) ...
             -4*pi*scale*sin(4*pi*s)*sin( 2*pi*s ); 

        d2x = -4*pi*pi*cos(2*pi*s)*(shift+scale*cos(4*pi*s)) ...
              -16*pi*pi*scale*cos( 6*pi*s );

        d2y = -4*pi*pi*cos(2*pi*s)*(shift+scale*cos(4*pi*s)) ...
              -16*pi*pi*scale*sin( 6*pi*s );

        d3x = 8*pi*pi*pi*sin(2*pi*s)*(shift+scale*cos(4*pi*s)) ...
            + 16*pi*pi*pi*scale*cos(2*pi*s)*sin(4*pi*s) ...
            + 96*pi*pi*pi*scale*sin(6*pi*s);
        
        d3y = -8*pi*pi*pi*cos(2*pi*s)*(shift+scale*cos(4*pi*s)) ...
              +16*pi*pi*pi*scale*sin(2*pi*s)*sin(4*pi*s) ...
              -96*pi*pi*pi*scale*cos(6*pi*s);
    
    %==========================
    % Otherwise. curvature
    %==========================
    otherwise
        
        % parameterize the path r0(s) = (x0(s), y0(s)).
        scalex = 20;
        scaley = 20;

        x0 = scalex*( 0.85 - 0.65*cos( s + 0.4 ) );
        y0 = scaley*( 0.65*sin( s + 0.4 ) );
      
        % its first order derivatives
        dx = scalex*( 0.65*sin( s + 0.4 ) );
        dy = scaley*( 0.65*cos( s + 0.4 ) );

        % its second order derivatives
        d2x = scalex*( 0.65*cos( s + 0.4) );
        d2y = scaley*( -0.65*sin( s + 0.4) );

        % its third order derivatives
        d3x = scalex*( -0.65*sin( s + 0.4) );
        d3y = scaley*( -0.65*cos( s + 0.4) );

end
%**************************************************************************
% End of this function.
%**************************************************************************