function d = computeCounterclockwiseDistanceOnCircle(theta1,theta2)
d = mod(2*pi + theta2, 2*pi) - mod(2*pi + theta1, 2*pi);
% d = mod((theta2-theta1)*2*pi,2*pi);