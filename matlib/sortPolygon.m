function Ps = sortPolygon(P)

% sorts vertices of polygon into counterclockwise sequence of vertices

[n,m] = size(P);
P = [P(n,1) P(n,2); P;P(n,1) P(n,2)];

r = zeros(n+2,3);
sTheta = zeros(n+2,1);
cTheta = zeros(n+2,1);
sPhi = zeros(n+2,1);
cPhi = zeros(n+2,1);
for i = 1:n
    % store segments as vectors
    r(i,:) = [P(i+1,:) - P(i,:), 0];
    r(i+1,:) = [P(i+2,:) - P(i+1,:), 0];
    
    % compute sine of exterior angle
    sTheta(i) = norm(cross(r(i,:),r(i+1,:)));
    % compute cosine of exterior angle
    cTheta(i) = dot(r(i,:),r(i+1,:));
end
