function d = computeClockwiseDistanceOnCircle(a,b)
d = 2*pi - computeCounterclockwiseDistanceOnCircle(a,b);