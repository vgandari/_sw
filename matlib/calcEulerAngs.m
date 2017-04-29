function [t1, t2, t3] = calcEulerAngs(A , rotSet , space )
    % INPUT
    % A       3x3 Direction Cosine Matrix
    % rotSet  1x3 (or 3x1) array of rotation axes to use
    % space   logical, true for Space rotation, false for Body
    % OUTPUT
    % t1,t2,t3 Euler angles (in radians)
    
    % figure out if this is 2 or 3 axis
    n = length(unique(rotSet));
    
    % assume Body rotations unless told otherwise
    if ~exist('space','var')
        space = false;
    end
    
    ax2neginds = [8, 3, 4]; % negative elements for 2 axis rotations
    i = rotSet(1);
    j = rotSet(2);
    
    switch n
        case 3
            A = A .*[1 -1 1; 1 1 -1; -1 1 1];
            if space
                A = A .';
            end
            k = rotSet (3);
            
            c2 = sqrt(A(i, i)^2 + A(i, j)^2);
            t1 = atan2(A(j, k)/c2, A(k, k)/c2);
            t2 = atan2(A(i, k), c2 );
            t3 = atan2(A(i, j)/c2, A(i, i)/c2);
        case 2
            A(ax2neginds(j)) = -A(ax2neginds(j));
            if space
                A = A .';
            end
            p = 6 - (i + j); % element missing from rotSet
            
            s2 = sqrt(A(i, p)^2 + A(i, j)^2);
            t1 = atan2(A(j, i)/s2, A(p, i)/s2);
            t2 = atan2(s2, A(i, i));
            t3 = atan2(A(i, j)/s2, A(i, p)/s2);
        otherwise
            error('calcEulerAngs:inputError','Invalid rotSet.');
    end
end
