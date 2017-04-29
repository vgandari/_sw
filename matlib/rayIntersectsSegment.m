function B = rayIntersectsSegment(p1,p2,p3,p4)

% define ray
q = p4 - p3;
p3

% angle of q with x axis
angleQ = atan2(q(2),q(1));
angleQ = computeCounterclockwiseDistanceOnCircle(0,angleQ);
negAngleQ = computeCounterclockwiseDistanceOnCircle(0,-angleQ);

% angle of p1 with x axis
angleP1 = atan2(p1(2),p1(1));
angleP1 = computeCounterclockwiseDistanceOnCircle(0,angleP1);

% angle of p2 with x axis
angleP2 = atan2(p2(2),p2(1));
angleP2 = computeCounterclockwiseDistanceOnCircle(0,angleP2);

if angleP1 > angleP2
    temp = angleP1;
    angleP1 = angleP2;
    angleP2 = temp;
end

% angleP1 < angleP2
B1 = ( angleP1 <= angleQ && angleQ <= angleP2 );
% -q
B2 = ( angleP1 <= negAngleQ && negAngleQ <= angleP2 );

% B1 = ( abs(angleP2 - angleQ) < 1e-6 || abs(angleP1 - angleQ) < 1e-6 || B1 );
% B2 = ( abs(angleP2 - negAngleQ) < 1e-6 || abs(angleP1 - negAngleQ) < 1e-6 || B2 );

B = B1 || B2;