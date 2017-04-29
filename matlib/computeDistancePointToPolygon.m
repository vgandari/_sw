function d = computeDistancePointToPolygon(P, q)

P = [P; P(1,1) P(1,2)];
[n,m] = size(P);

% Create previous distance to polygon for loop iterations
dPrevious = Inf;

for ii = 2:n
    d = computeDistancePointToSegment(P(ii-1,:), P(ii,:), q);
    dPrevious = min(d, dPrevious);
end

d = dPrevious;  