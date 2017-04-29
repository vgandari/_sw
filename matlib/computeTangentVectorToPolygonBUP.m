function u = computeTangentVectorToPolygon(P,q)

[n,m] = size(P);

% Create previous distance to polygon for loop iterations
dPrevious = Inf;
% Create previous vector to test for (counter)clockwise rotations
uPrevious = [0; 0];
d = Inf;

for ii = 1:n
    % Create indices to ensure distances from all sides are measured
    if ii < 2
        a = n;
        b = 1;
    else
        a = ii - 1;
        b = ii;
    end
    
    P(a,:)'
    P(b,:)'
    
    % Compute distances to determine if q is closest to vertex or side
    dL = computeDistancePointToLine(P(a,:)', P(b,:)', [q(1); q(2)]);
    dS = computeDistancePointToSegment(P(a,:)', P(b,:)', [q(1); q(2)])
    
    % Store line segment vector
    u = P(b,:)' - P(a,:)';
    
    % Store information about vertex angle direction
    counterclockwise = [0 0 1]*cross([uPrevious; 0], [u; 0]);
    
    % Store u for next loop iteration
    uPrevious = u;
    
    % if new distance calculated is less than current distance, update flag
    % that spcifies whether q is closer to a side or a vertex
    if dS < d
        % If distance to line segment is greater than distance to line, then q
        % is closer to a vertex than to a side
        if dL < dS
            closestToVertex = 1
        else
            closestToVertex = 0
        end
        d = dS
        dL
    end
    
    % Store closest vertex when q closest to a vertex, distance unchanged
    if closestToVertex && d == dPrevious
        v = P(a,:)';
    else
        v = P(b,:)';
    end
    
    % Only update dPrevious if d < dPrevious
    dPrevious = min(d, dPrevious);
    
%     dSide = d;
%     dPrevious;
end

if closestToVertex
    % Find vector tangent to circle centered at v
    u = cross([0; 0; 1], [v; 0]);
    u = [u(1); u(2)];
elseif counterclockwise < 0
    u = -u;
end

u = u/norm(u);