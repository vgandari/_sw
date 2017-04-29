function d = computeDistancePointToLine(p1, p2, q)
% compute distance from point q to line defined by points p1 and p2

    samePoint = norm(p2 - p1);
    
    if samePoint < 1e-8
        error('p1 and p2 are the same point');
    end
    
    % Let a be the vector from p1 to q
    a = [q(1) - p1(1);
         q(2) - p1(2)];
    
    % Let bhat be a unit vector in the direction of from p1 to p2
    bhat = [(p2(1) - p1(1));
            (p2(2) - p1(2))];
    bhat = bhat/norm(bhat);
    
    % Compute component of a in the direction of bhat
    a_proj = dot(a,bhat)*bhat;
    
    % Let r be a point on the line segment between p1 and p2 s.t. the line
    % segment q-r is normal to vector b.
    r = [p1(1) + a_proj(1);
         p1(2) + a_proj(2)];
    
    % Compute distance from q to r.
    d = norm([q(1) - r(1); q(2) - r(2)]);
end