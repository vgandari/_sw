function [a, b, c] = computeLineThroughTwoPoints(p1, p2)
% Given two points on a line, p1 and p2 (column vectors), find parameters
% a, b, and c such that ax + by + c = 0.
% p1 and p2 are vectors with 2 elements each
% If p1 and p2 are within 1e-8 distance of each other, the function will return an error.

    samePoint = norm(p2 - p1);

    if samePoint < 1e-8
        error('p1 and p2 are the same point');
    end

    dy = (p2(2) - p1(2));
    dx = (p2(1) - p1(1));

    if dx == 0 % vertical line
        a = 1;
        b = 0;
        c = p2(1);
    elseif dy == 0 % horizontal line
        a = 0;
        b = 1;
        c = p2(2);
    else
        % set up system matrix
        A = [p1(1) p1(2); p2(1) p2(2)];

        % assume c = -[1; 1] (magnitude depends on magnitude of [a; b])
        % solve for [a; b]
        c = -[1; 1];
        ab = A\c;

        % normalize [a; b]
        ab = ab/norm(ab);

        % compute c for normaized [a; b]
        c = -A*ab;

        % Output parameters
        c = c(1);
        a = ab(1);
        b = ab(2);
    end
end
