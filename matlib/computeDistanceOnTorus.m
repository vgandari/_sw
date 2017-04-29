function d = computeDistanceOnTorus(a,b,c,d)
d = sqrt(computeDistanceOnCircle(a,c)^2 + computeDistanceOnCircle(b,d)^2);