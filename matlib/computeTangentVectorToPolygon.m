function u = computeTangentVectorToPolygon(P,q)

P = [P; P(1,1) P(1,2)];
[n,m] = size(P);

% Create previous distance to polygon for loop iterations
dPrevious = Inf;

% find closest vertex/segment of polygon to point q
for ii = 2:n
    % Compute distances to determine if q is closest to a vertex or a side
    
    p1 = P(ii-1,:)';
    p2 = P(ii,:)';
    
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
    
    
    % update min distance to polygon vertex/segment
    if d < dPrevious
        % if distance to segment not distance to line, store vertex
        % else, store segment vector
        if d ~= dL
            closestToVertex = 1;
            % if closest to a vertex, store vertex
            if d == d1
                v = p1;
            elseif d == d2
                v = p2;
            end
        else
            closestToVertex = 0;
            u = p2 - p1;
            % assume polygon segments are given in counterclockwise order
%             % Store information about vertex angle direction
%             counterclockwise = [0 0 1]*cross([uPrevious; 0], [u; 0]);
% 
%             % Store u for next loop iteration
%             uPrevious = u;
        end
    end
    
    % store previous distance for next iteration
    dPrevious = min([d dPrevious]);
end

if closestToVertex
    % Find vector tangent to circle centered at v
    u = cross([0; 0; 1], [q(1)-v(1); q(2)-v(2); 0]);
end

u = [u(1); u(2)];
u = u/norm(u);