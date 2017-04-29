% Converts from lambda vector and angle of rotation to DCM
% input theta in radians

% Advantage: uses vectors
% Disadvantage: uses more memoruy (b variable)

function C = SRT_lam2DCM_vec(lambda, theta)
    b(:, 1) = [1 0 0]'*cos(theta) - cross([1 0 0]', lambda)*sin(theta) + lambda(1)*lambda*(1 - cos(theta));
    b(:, 2) = [0 1 0]'*cos(theta) - cross([0 1 0]', lambda)*sin(theta) + lambda(2)*lambda*(1 - cos(theta));
    b(:, 3) = [0 0 1]'*cos(theta) - cross([0 0 1]', lambda)*sin(theta) + lambda(3)*lambda*(1 - cos(theta));
    
    bb = [b(:, 1) b(:, 2) b(:, 3)]
    
    C(1, 1) = dot([1 0 0]', b(:, 1));
    C(1, 2) = dot([1 0 0]', b(:, 2));
    C(1, 3) = dot([1 0 0]', b(:, 3));
    C(2, 1) = dot([0 1 0]', b(:, 1));
    C(2, 2) = dot([0 1 0]', b(:, 2));
    C(2, 3) = dot([0 1 0]', b(:, 3));
    C(3, 1) = dot([0 0 1]', b(:, 1));
    C(3, 2) = dot([0 0 1]', b(:, 2));
    C(3, 3) = dot([0 0 1]', b(:, 3));
end
