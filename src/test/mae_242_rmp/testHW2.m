% testHW2
clc
close all

% set up rectangle test case
P = [0 0;
    1 0;
    1 1;
    0 1];
q = [1.5 0.5];
q = randn(2,1);

[n,m] = size(P);

figure(1)
hold on
for ii = 2:n
    plot(P(ii-1,:),P(ii,:),'o')
end
plot(q(1), q(2), 'x')
axis([-1 2 -1 2])

d = computeDistancePointToPolygon(P, q);


% Randomly generated figure (not guaranteed to be closed, edges may
% intersect)
% 
% n = 5;
% P = randn(n, 2)/randn(1);
% 
% figure(2)
% hold on
% for ii = 2:n
%     plot(P(:,1),P(:,2))
% end
% plot(q(1), q(2), 'x')
% 
% d = computeDistancePointToPolygon(P, q);



% test computeTangentVectorToPolygon
u = computeTangentVectorToPolygon(P,q);

plot([q(1) q(1)+u(1)],[q(2) q(2)+u(2)])