function B = isPointInsidePolygonBUP(P,q)

% polygon must be convex, counterclockwise sequence of vertices

[n,m] = size(P);
if m > n
    P = P';
end

% P = [P(n-1,1) P(n-1,2); P(n,1) P(n,2); P];
if n > m
    P = [P(n,1) P(n,2); P;P(n,1) P(n,2)];
else
    P = [P(n,1) P(n,2); P;P(n,1) P(n,2)];
end

r = zeros(n+2,3);
sTheta = zeros(n+2,1);
cTheta = zeros(n+2,1);
sPhi = zeros(n+2,1);
cPhi = zeros(n+2,1);

B = false;

for i = 1:n
    % store segments as vectors
    r(i,:) = [P(i+1,:) - P(i,:), 0];
    r(i+1,:) = [P(i+2,:) - P(i+1,:), 0];
    
    % compute sine of exterior angle
    sTheta = cross(r(i,:),r(i+1,:));
    sTheta(i) = sTheta(3)/(norm(r(i,:))*norm(r(i+1,:)));
    % compute cosine of exterior angle
    cTheta(i) = dot(r(i,:),r(i+1,:));
    
    if sTheta(i) < 0 || sTheta(i) > pi
        error('Polygon must be convex');
    end
    
    % compute sine of angle from end of segment i to q
    sPhi = cross(r(i,:),[q(1) q(2) 0]-[P(i+1,:) 0]);
    sPhi(i) = sPhi(3)/(norm(r(i,:))*norm([q(1) q(2) 0]-[P(i+1,:) 0]));
    % compute cosine of angle from end of segment i to q
    cPhi(i) = dot(r(i,:),[q(1) q(2) 0]-[P(i+1,:) 0]);
    
    theta(i) = atan2(sTheta(i),cTheta(i));
    phi(i) = atan2(sPhi(i),cPhi(i));
    
    % 0 < theta < pi
    % 0 < phi < pi
%     B = (cPhi(i) < cTheta(i) && sPhi(i) > 0);
    B = ((phi(i) > theta(i) && phi(i) < pi) && B);
end