function Q = findNeighboringPoints(p,S,r)
% finds point in set S within distance r of point p
Q = [];
for i = 1:length(S)/2
    d = norm(p - S(2*i-1:2*i,1));
    if d <= r
        Q = [Q; S(2*i-1:2*i)];
    end
end

% k = length(S)/2