function d = computeDistanceOnCircle(a,b)
d = min(computeClockwiseDistanceOnCircle(a,b),computeCounterclockwiseDistanceOnCircle(a,b));