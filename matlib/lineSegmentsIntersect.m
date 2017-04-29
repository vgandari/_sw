function B = lineSegmentsIntersect(p1,p2,p3,p4)

B = rayIntersectsSegment(p1,p2,p3,p4);
B = (B && rayIntersectsSegment(p1,p2,p4,p3));