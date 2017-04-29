%**************************************************************************
% Purpose: Plot graphics of problem.
% -------  
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
function cm_plot( lbx, lby, ubx, uby, xpos, ypos, timet, ...
                       spar, smpar, va1, va2, vb, vc, vd, ve, vf, ...
                       delta, vgv, vga, opt )
                   
%-------------------------------------
% check options.isvisual, plot or not.
%-------------------------------------
opt.isvisual = [opt.isvisual, repmat(' ', 1, 13 -length(opt.isvisual))];
if ~findstr( opt.isvisual, 'offOFF' )
    fprintf('-> visualization ... \n');
end

%---------------------
% compute min and max of spar and smpar
%---------------------
minspar = min( spar ); maxspar = max( spar );
minsmpar = min( smpar ); maxsmpar = max( smpar );
vs   = minspar:0.005:maxspar;
vsm  = minsmpar:0.005:maxsmpar;

%---------------------
% pseudo velocity.
%---------------------
if findstr(opt.isvisual(1:2), 'pvPVpVPv')
    % cubic spline 
    pcoeff = spline( spar, sqrt( vf ) );
    svf = ppval( pcoeff, vs );

    % plot figure
    figure(1)
    plot( vs, svf, 'r' );
    xlabel('path coordinate (-)'); ylabel('pseudo velocity ds');
    title('Pseudo velocity');
    axis tight; as = axis; axis([as(1) as(2) as(3) as(4)*1.05]);
end
%---------------------
% pseudo acceleration.
%---------------------
if findstr(opt.isvisual(3:4), 'paPApAPa')
    % cubic spline
    pcoeff = spline( smpar, ve );
    sve = ppval( pcoeff, vsm );

    % plot figure
    figure(2)
    plot( vsm, sve, 'b' );
    xlabel('path coordinate (-)'); ylabel('pseudo acceleration (ds^2)');
    title('Pseudo acceleration');
    axis tight; as = axis; axis([as(1) as(2) as(3)*1.05 as(4)*1.05]);
end
%---------------------
% Acceleration
%---------------------
if findstr(opt.isvisual(5:6), 'taTATatA')
    % cubic spline
    pcoeff = spline( smpar, va1 );
    sva1 = ppval( pcoeff, vsm );
    pcoeff = spline( smpar, va2 );
    sva2 = ppval( pcoeff, vsm );

    % plot figure
    figure(3)
    plot( vsm, sva1, 'b:', vsm, sva2, 'r-.');
    xlabel('path coordinate (-)'); ylabel('acceleration (m/s2)');
    title(' Acceleration');
    legend('a1','a2' );
    axis tight; as = axis; axis([as(1) as(2) as(3)*1.01 as(4)*1.01]);
end
%---------------------
% Deformation
%---------------------
if findstr(opt.isvisual(7), 'Dd')
    % cubic spline
    pcoeff = spline( [smpar, 1], vb );
    svb = ppval( pcoeff, [vsm, 1] );

    % plot figure
    figure(4)
    plot( [vsm, 1], svb, 'm' );
    xlabel('path coordinate (-)'); ylabel('deformation b(s)');
    title('Deformation b(s)');
    axis tight; as = axis; axis([as(1) as(2) as(3)*1.05 as(4)*1.05]);
end
%-------------------------------
% Spatial Geometric Velocity
%-------------------------------
if findstr(opt.isvisual(8), 'vV')
    % compute vgv1, vgv2
    vgv1 = vgv(1:2:end, 1);
    vgv2 = vgv(2:2:end, 1);

    % cubic spline
    pcoeff = spline( smpar, vgv1 );
    svgv1 = ppval( pcoeff, vsm );
    pcoeff = spline( smpar, vgv2 );
    svgv2 = ppval( pcoeff, vsm );

    % plot figure
    figure(5)
    plot( vsm, svgv1, 'b--', vsm, svgv2, 'r-.');
    xlabel('path coordinate (-)'); ylabel('velocity (m/s)');
    title(' Spatial Geometric Velocity');
    legend('v_x','v_y' );
    axis tight; as = axis; axis([as(1) as(2) as(3)*1.01 as(4)*1.01]);
end
%-------------------------------
% Spatial Geometric Acceleration
%-------------------------------
if findstr(opt.isvisual(9), 'aA')
    % compute vga1, vga2
    vga1 = vga(1:2:end, 1);
    vga2 = vga(2:2:end, 1);

    % cubic spline
    pcoeff = spline( smpar, vga1 );
    svga1 = ppval( pcoeff, vsm );
    pcoeff = spline( smpar, vga2 );
    svga2 = ppval( pcoeff, vsm );

    % plot figure
    figure(6)
    plot( vsm, svga1, 'b--', vsm, svga2, 'r-.');
    xlabel('path coordinate (-)'); ylabel('acceleration (m/s2)');
    title(' Spatial Geometric Acceleration');
    legend('a_x','a_y' );
    axis tight; as = axis; axis([as(1) as(2) as(3)*1.01 as(4)*1.01]);
end
%---------------------
% Trajectory of car.
%---------------------
if findstr(opt.isvisual(10:11), 'TrtrTrtR')
    figure(7)
    plot( lbx, lby, 'b--', ubx, uby, 'b--', xpos, ypos, 'r' );
    xlabel('x-coordinate'); ylabel('y-coordinate');
    title('Car trajectory');
    axis tight; as = axis; axis([as(1) as(2) as(3)*1.05 as(4)*1.05]);

    % create line
    hold on;
    plot( [lbx(1);ubx(1)], [lby(1);uby(1)], 'b' );
    hold on;
    plot( [lbx(end);ubx(end)], [lby(end);uby(end)], 'b' );
    axis equal;
end

% modeling motion 
if findstr(opt.isvisual(12), 'Mm')
    % compute time
    nvf = length( svf );
    time(1,1) = 0;
    for k=1:nvf-1
        time(k+1) = 2*delta/(svf(k)+svf(k+1));
    end;

    hold on
    rsz = 0.5;
    nsz = length( xpos );
    for k=1:nsz
        rectangle( 'Position', [xpos(k)-0.5*rsz, ypos(k)-0.5*rsz, rsz, rsz], ...
                   'Curvature', [0.4], 'EraseMode', 'xor');

        pause(time(k));

        rectangle( 'Position', [xpos(k)-0.5*rsz, ypos(k)-0.5*rsz, rsz, rsz], ...
                   'Curvature', [0.4], 'EraseMode', 'xor');
    end
end
%**************************************************************************
% End of this function.
%**************************************************************************