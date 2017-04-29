% MAE242 HW4 test script. Run this after writing computeDistanceOnCircle
% and computeDistanceOnTorus to make sure your formatting is correct.
% Note, I will make more test cases when I grade the assignment! - Evan

clear; clc; close all
eps = 0.001;

alpha1 = 0;
alpha2 = pi/3;
dist1 = computeDistanceOnCircle(alpha1, alpha2);
expected1 = pi/3;

beta1 = 5*pi/6;
beta2 = -5*pi/6;
% dist2 = computeDistanceOnTorus(alpha1, alpha2, beta1, beta2);
dist2 = computeDistanceOnTorus(alpha1, beta1, alpha2, beta2);
expected2 = sqrt((pi/3)^2 + (pi/3)^2);

dist3 = computeCounterclockwiseDistanceOnCircle(beta1, beta2)
dist3 = computeClockwiseDistanceOnCircle(beta1, beta2)
dist3 = computeDistanceOnCircle(beta1, beta2)

alpha3 = -pi;
alpha4 = pi;
dist3 = computeDistanceOnCircle(alpha3, alpha4);
expected3 = 0;

beta3 = -pi/2;
beta4 = pi/2;
% dist4 = computeDistanceOnTorus(alpha3, alpha4, beta3, beta4);
dist4 = computeDistanceOnTorus(alpha3, beta3, alpha4, beta4);
expected4 = pi;

num_wrong = 0;
if (abs(dist1 - expected1) > eps)
    fprintf('Called computeDistanceOnCircle(0, pi/3)\n')
    fprintf('Expected output: %f   Received: %f\n', expected1, dist1)
    num_wrong = num_wrong + 1;
end
if (abs(dist2 - expected2) > eps)
    fprintf('Called computeDistanceOnTorus(0, pi/3, 5*pi/6, -5*pi/6)\n')
    fprintf('Expected output: %f   Received: %f\n', expected2, dist2)
    num_wrong = num_wrong + 1;
end
if (abs(dist3 - expected3) > eps)
    fprintf('Called computeDistanceOnCircle(-pi, pi)\n')
    fprintf('Expected output: %f   Received: %f\n', expected3, dist3)
    num_wrong = num_wrong + 1;
end
if (abs(dist4 - expected4) > eps)
    fprintf('Called computeDistanceOnTorus(-pi, pi, -pi/2, pi/2)\n')
    fprintf('Expected output: %f   Received: %f\n', expected4, dist4)
    num_wrong = num_wrong + 1;
end
if (num_wrong == 0)
    disp('All cases passed!')
end