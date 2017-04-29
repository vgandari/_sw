function energy_ellipsoid(I, J, omega, H)
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

    c = sqrt(omega'*H);

    alpha1 = c/sqrt(I(1, 1));
    alpha2 = c/sqrt(I(2, 2));
    alpha3 = c/sqrt(I(3, 3));

    figure(2)
    surfl(x, y, z)
    title('Victor Gandarillas\_Energy Ellipsoid P2b')
    xlabel('c1')
    ylabel('c2')
    zlabel('c3')
    
end