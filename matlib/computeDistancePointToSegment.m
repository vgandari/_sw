function d = computeDistancePointToSegment(p1, p2, q)
% compute distance from point q to line defined by points p1 and p2
% p1, p2, and q are vectors with 2 elements each
% If p1 and p2 are within 1e-8 distance of each other, the function will return an error.

    samePoint = norm(p2 - p1);

    if samePoint < 1e-8
        error('p1 and p2 are the same point');
    end

    % compute unit vector in direction from p1 to p2
    bhat = [(p2(1) - p1(1));
            (p2(2) - p1(2))];
    bhat = bhat/norm(bhat);
    
    % Compute distance from q to p1
    d1 = norm([q(1) - p1(1); q(2) - p1(2)]);
    % Compute distance from q to p2
    d2 = norm([q(1) - p2(1); q(2) - p2(2)]);

    % determine location of q wrt line segment
    % define unit vectors from p1 and p2 to q
    q1 = [(q(1) - p1(1))/d1;
          (q(2) - p1(2))/d1];
    q2 = [(q(1) - p2(1))/d2;
          (q(2) - p2(2))/d2];
    
    % project unit vectors q1 and q2 onto line segment between p1 and p2
    % variables are named assuming line segment is horizontal
    lProduct = dot(q1,bhat); % "left" projection
    rProduct = dot(q2,bhat); % "right" projection
    
    dL = computeDistancePointToLine(p1, p2, q);
    
    % determine location of q and compute distance appropriately
    % if projections are in the same direction; i.e. if q is on either side
    % of the line segment,
    if lProduct * rProduct > 0
        % Compute minimum of both distances
        d = min([d1 d2]);
    else
        % Compute perpendicular distance from q to line
        d = dL;
    end
end
