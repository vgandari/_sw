function B = lineSegmentsIntersectBUP(p1,p2,q1,q2)
p1 = [p1(1) p1(2)];
p2 = [p2(1) p2(2)];
q1 = [q1(1) q2(1)];
q2 = [q2(1) q2(2)];
% Compute lines
[a1,b1,c1] = computeLineThroughTwoPoints(p1, p2);
[a2,b2,c2] = computeLineThroughTwoPoints(q1, q2);

% Lines are coincident
B = linesAreCoincident(a1,b1,c1,a2,b2,c2);
if B
    B = ( ...
        (q1(1) >= min([p1(1), p2(1)]) && q1(1) <= max([p1(1), p2(1)])) || ...
        (q2(2) >= min([p1(2), p2(2)]) && q2(2) <= max([p1(2), p2(2)])) );
else
    % Lines intersect or are coincident 
    B = linesIntersect(a1,b1,c1,a2,b2,c2);
    % If lines intersect, check if line segments intersect
    if B
        % store segments as vectors
        p1p2 = [p2 - p1, 0]
        q1q2 = [q2 - q1, 0];

        % store points connecting line segments as vectors
        p2q1 = [q1 - p2, 0];
        p2q2 = [q2 - p2, 0];

        q2p1 = [p1 - q2, 0];
        q2p2 = [p2 - q2, 0];

    %     figure(1)
    %     plot([p1(1) p2(1)],[p1(2) p2(2)],...
    %     [q1(1) q2(1)],[q1(2) q2(2)],...
    %     [p2q1(1) p2q1(1)],[p2q1(2) p2q1(2)],...
    %     [p2q2(1) p2q2(1)],[p2q2(2) p2q2(2)],...
    %     [q2p1(1) q2p1(1)],[q2p1(2) q2p1(2)],...
    %     [q2p2(1) q2p2(1)],[q2p2(2) q2p2(2)])

        % compute sine of angle (p1,p2,q1)
        sTheta1 = cross(p1p2,p2q1);
        sTheta1 = norm(sTheta1)/(norm(p1p2)*norm(p2q1));
        % compute cosine of angle (p1,p2,q1)
        cTheta1 = dot(p1p2,p2q1)/(norm(p1p2)*norm(p2q1));

        % compute sine of angle (p1,p2,q2)
        sTheta2 = cross(p1p2,p2q2);
        sTheta2 = sTheta2(3)/(norm(p1p2)*norm(p2q2));
        % compute cosine of angle (p1,p2,q2)
        cTheta2 = dot(p1p2,p2q2)/(norm(p1p2)*norm(p2q2));

        % compute sine of angle (p2,q2,p1)
        sPhi1 = cross(q1q2,q2p1);
        sPhi1 = sPhi1(3)/(norm(q1q2)*norm(q2p1));
        % compute cosine of angle (p2,q2,p1)
        cPhi1 = dot(q1q2,q2p1)/(norm(q1q2)*norm(q2p1));

        % compute sine of angle (p2,q2,q1)
        sPhi2 = cross(q1q2,q2p2);
        sPhi2 = sPhi2(3)/(norm(q1q2)*norm(q2p2));
        % compute cosine of angle (p2,q2,q1)
        cPhi2 = dot(q1q2,q2p2)/(norm(q1q2)*norm(q2p2));

        % compute angles
        theta1 = atan2(sTheta1,cTheta1);
        phi1 = atan2(sPhi1,cPhi1);

        theta2 = atan2(sTheta2,cTheta2);
        phi2 = atan2(sPhi2,cPhi2);

        % if both sets of angles are opposite in sign, then lines intersect
        B = (phi1*theta1 < 0 && phi2*theta2 < 0);
    end
end