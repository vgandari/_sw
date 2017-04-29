function G = findRoadmap(Obs,S,r)
% creates cell array representing adjacency table that defines edges with
% distance < r of graph with vertices in S

G = {};
[s,b] = size(S);

if b == 2
    T = zeros(2*s,1);
    for i = 1:s
        T(2*i-1,1) = S(i,1);
        T(2*i,1) = S(i,2);
    end
    S = T;
end

% s = length(S)

% plot graph vertices
% for i = 1:4
%     plot([Obs(i,1) Obs(i+1,1)], [Obs(i,2) Obs(i+1,2)])
% end
Obs = [Obs;Obs(1,:)];

for i = 1:s
    Q = findNeighboringPoints(S(2*i-1:2*i),S,r);
    q = length(Q)/2;
    
    G{i} = {};
    l = 1;
    for j = 1:q
        if j ~= i
            for k = 1:4
                Obs(k,:)
                Obs(k+1,:)
                if ~lineSegmentsIntersect(S(2*i-1:2*i),Q(2*j-1:2*j),Obs(k,:),Obs(k+1,:))
                    G{i}{l} = [Q(2*j-1) Q(2*j)];
                end
            end
        end
        G
        figure(2)
        hold on
        plot(Q(2*l-1), Q(2*l),'o')
        l = l + 1;
    end
end
axis([2 3 2 3])
