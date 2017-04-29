function B = linesIntersect(a1,b1,c1,a2,b2,c2)
% lines have different slopes or one is vertical or one is horizontal
B = ( a1/b1 ~= a2/b2 || (a1 == 0 && a2 ~= 0) || (b1 == 0 && b2 ~= 0) );

% if lines have same slope, check if coincident
if ~B
    B = linesAreCoincident(a1,b1,c1,a2,b2,c2);
end