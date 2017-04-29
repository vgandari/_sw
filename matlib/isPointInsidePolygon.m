function B = isPointInsidePolygon(P,p)
index = [1:length(P),1];

% P = [P, P(:,1)];

B = true;

for k = 1:length(index)
    k
    B = (B && rayIntersectsSegment(P(:,index(k)),P(:,index(k+1)),p,P(:,1)))
end