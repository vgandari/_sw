% Victor Gandarillas
% AAE 590 Spacecraft Attitude Dynamics
% Problem Set 8

function inertia_ellipsoid(I, J)
    % I matrix (principal axes, b frame) must be axisymmetric
    % omega (rad/s) in b frame
    % H (kg-rad^2/s) in b frame
    % Jind (--) index of J in inertia dyad
    % x location of omega/ellipse intersection from inspection
    % y location of omega/ellipse intersection from inspection
    % t (s) time array

    if J < I
        fprintf('rod\n');
    else
        fprintf('disk\n');
    end
    
    alpha1 = 1/sqrt(I);
    alpha2 = 1/sqrt(J);
    alpha3 = 1/sqrt(I);
    
    fprintf('Ratios:\n');
    disp([alpha1/alpha2 alpha1/alpha3 alpha2/alpha1 alpha2/alpha3 alpha3/alpha1 alpha3/alpha2])

    [x,y,z] = ellipsoid(0, 0, 0, alpha1, alpha2, alpha3, 30);

    subplot(2, 2, 1)
    surfl(x, y, z)
    title('Victor Gandarillas\_Inertia Ellipsoid P1a')
    xlabel('c1 [mL^2]')
    ylabel('c2 [mL^2]')
    zlabel('c3 [mL^2]')
    subplot(2, 2, 2)
    surfl(x, y, z)
    title('Victor Gandarillas\_Inertia Ellipsoid P1a')
    xlabel('c1 [mL^2]')
    ylabel('c2 [mL^2]')
    zlabel('c3 [mL^2]')
    subplot(2, 2, 3)
    surfl(x, y, z)
    title('Victor Gandarillas\_Inertia Ellipsoid P1a')
    xlabel('c1 [mL^2]')
    ylabel('c2 [mL^2]')
    zlabel('c3 [mL^2]')
    subplot(2, 2, 4)
    surfl(x, y, z)
    title('Victor Gandarillas\_Inertia Ellipsoid P1a')
    xlabel('c1 [mL^2]')
    ylabel('c2 [mL^2]')
    zlabel('c3 [mL^2]')

%     psi = linspace(0, 2*pi, 10000);
% 
%     x1 = alpha1*cos(psi);
%     x3 = alpha3*sin(psi);
% 
%     m = H(3)/H(1);
%     m = -1/m;
%     b = y - m*x;
% 
%     figure(3)
%     hold on
%     plot(x1, x3)
%     plot([x1, x2], [y1, y2]) % polhode curve (coordinates from inspection)
%     quiver(0, 0, 3*H(1)/norm(H), 3*H(3)/norm(H))
%     quiver(0, 0, omega(1), omega(3))
%     plot([0, omega(1)], [0, omega(3)], 'r')
%     plot([-1, 5], m*[-1, 5] + b, 'g')
%     plot([x, x], [y, -y], 'm')
%     title('Victor Gandarillas\_Energy Ellipsoid c1-c3 Projection P2b')
%     xlabel('c1')
%     ylabel('c3')
%     legend('Energy Ellipsoid', 'h', '\omega', '\pi', 'polhode')
%     axis([-4, 4, -3, 5])

%     % t = 1
%     p = norm(H)/Io;
% 
%     s = (Io - J)/Io*omega(1);
% 
%     phi = acosd(J*s/(Io - J)/p); % nutation if n1 || H
% 
%     % t = 3
%     precession = p*3*180/pi;
% 
%     spin = s*3*180/pi;
% 
% 
%     % t = 1
%     h = H/norm(H);
%     q1(1:3) = h*sin(p/2);
%     q1(4) = cos(p/2);
%     q1 = q1';
% 
% 
%     C1 = q2DCM(q1);
% 
% 
%     kappa1 = acosd(C1(1, 1));
% 
% 
%     % t = 3
%     q3(1:3) = H/norm(H)*sin(3*p/2);
%     q3(4) = cos(3*p/2);
%     q3 = q3';
% 
%     C3 = q2DCM(q3);
% 
% 
%     kappa3 = acosd(C3(1, 1));
%     % Euler parameters in terms of c
% 
%     t = [1, 3];
%     q = qcone(phi*pi/180, p, s, t);
% 
% 
%     C_CB1 = [1 0 0;
%         0 cos(s) -sin(s);
%         0 sin(s) cos(s)];
% 
%     qb1(1:3) = q(1:3, 1)'*C_CB1;
%     qb1(4) = q(4, 1);
%     qb1 = qb1';
% 
%     C_CB3 = [1 0 0;
%         0 cos(3*s) -sin(3*s);
%         0 sin(3*s) cos(3*s)];
% 
%     qb3(1:3) = q(1:3, 2)'*C_CB3;
%     qb3(4) = q(4, 2);
%     qb3 = qb3';

end