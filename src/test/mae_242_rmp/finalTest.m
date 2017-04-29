% Progrmming Final Assignment Test Script

close all
clear all

clc
% 1
p1 = [3 4];
p2 = [3 7];
q1 = [3 5];
q2 = [3 8];

B = lineSegmentsIntersect(p1,p2,q1,q2);

% 2
n = 4;

q = [0; 2];
P = [-1 -1 1 1;
    1 -1 -1 1];

tol = 4;

figure(2)
plot(q(1),q(2),'x')
hold on
for i = 1:n
    plot(P(1,i), P(2,i),'o')
end

B = isPointOnPolygon(P,q,tol);
    
B = isPointInsidePolygon(P,q);

% 3
s = rand(20,2);
p = rand(2,1);
r = rand(1,1);
S = findNeighboringPoints(p,s,r);

x = linspace(-1,1,100);
y1 = sqrt(r^2 - x.^2) + p(2);
y2 = -sqrt(r^2 - x.^2) + p(2);

figure(3)
hold on
plot(x + p(1),y1,x + p(1),y2)
plot(p(1),p(2),'x')
for i = 1:10
    plot(s(2*i-1,1),s(2*i,1),'o')
end
axis([0 1 0 1])

% 4
n=10;
Obs = [2.5, 2.2;
    2.6, 2;
    2.7, 2.7;
    2.5, 2.8];
S1 = [2.332,2.5;
    2.662, 2.25;
    2.112, 2.75;
    2.44, 2.125;
    2.223, 2.625;
    2.778, 2.375;
    2.556, 2.875;
    2.889, 2.0625;
    2.037, 2.5625;
    2.3704, 2.3125];
S2 = [2.7037, 2.8125;
    2.1481, 2.1875;
    2.4815, 2.675;
    2.2593, 2.4356;
    2.5926, 2.0312;
    2.9259, 2.5312;
    2.0741, 2.2812;
    2.4074, 2.7821;
    2.7407, 2.1562;
    2.185, 2.6562];
S = [S1;S2];

isPointInsidePolygon(Obs',[2.5926; 2.0312])

% If point is inside obstacle, remove from set
Q1 = [];
for i = 1:length(S1)
    if ~isPointInsidePolygon(Obs',S1(i,:)')
        Q1 = [Q1;S1(i,:)];
    end
end

Q2 = [];
for i = 1:length(S2)
    if ~isPointInsidePolygon(Obs',S2(i,:)')
        Q2 = [Q2;S2(i,:)];
    end
end

Q = [];
for i = 1:length(S)
    if ~isPointInsidePolygon(Obs',S(i,:)')
        Q = [Q;S(i,:)];
    end
end

% plot obstacle
Obs = [Obs;Obs(1,:)];
figure(4)
hold on
for i = 1:4
    plot([Obs(i,1) Obs(i+1,1)], [Obs(i,2) Obs(i+1,2)])
end
figure(1)
hold on
for i = 1:4
    plot([Obs(i,1) Obs(i+1,1)], [Obs(i,2) Obs(i+1,2)])
end
for i = 1:10
    plot(S1(i,1), S1(i,2),'o')
    plot(S2(i,1), S2(i,2),'.')
end
axis([2 3 2 3])


% 4
% r = 0.425;
% G = findRoadmap(Obs,S2,r)
% 
% 
% 
% 
% % roadmaps over S1, S2, and union(S1,S2)
% 
% 
