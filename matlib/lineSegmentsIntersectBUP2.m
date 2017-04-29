function B = lineSegmentsIntersect(p1,p2,p3,p4)

A = [p2(1)-p1(1), p3(1)-p4(1);
    p2(2)-p1(2), p3(2)-p4(2)]
b = [p3(1)-p1(1);
    p3(2)-p1(2)]

A\b
% det(A) == 0 -> unique solution exists
% det(A) ~= 0, b == 0 -> infinite solutions
B = det(A)
B = ((B == 0 && b(1) == 0 && b(2) == 0) || B ~= 0);