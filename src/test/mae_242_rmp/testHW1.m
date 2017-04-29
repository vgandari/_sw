% testHW1
% This script tests the functions written for HW1:
% computeLineThroughTwoPoints
% computeDistancePointToLine
% computeDistancePointToSegment

clc

% define test inputs

% Test computeLineThroughTwoPoints

% vertical line case
p1 = randn(2,1);
p2 = randn(2,1);

p2(1) = p1(1); % set x components equal

[a, b, c] = computeLineThroughTwoPoints(p1, p2);

if a ~= 1 || b~= 0
    error('vertical line test failed');
end

% horizontal line case
p1 = randn(2,1);
p2 = randn(2,1);

p2(2) = p1(2); % set y components equal

[a, b, c] = computeLineThroughTwoPoints(p1, p2);

if a ~= 0 || b ~= 1
    error('horizontal line test failed');
end

% any other line case

[a, b, c] = computeLineThroughTwoPoints(p1, p2);

testNorm = norm([a b]);
if abs(testNorm - 1) > 1e-8
    fprintf('a^2 + b^2 == %f\n', testNorm);
    error('abs((a^2 + b^2) - 1) > 1e-8');
end


% Test computeDistancePointToLine and computeDistancePointToSegment
p1 = randn(2,1);
p2 = randn(2,1);
q = randn(2,1);

d = computeDistancePointToLine(p1, p2, q)

% Test computeDistancePointToSegment

d1 = norm(q - p1)
d2 = norm(q - p2)
ds = computeDistancePointToLine(p1, p2, q)

d = computeDistancePointToSegment(p1, p2, q)

if d > min([d1 d2])
    error('selected wrong distance from q to line segment');
end
