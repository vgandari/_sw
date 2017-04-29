function S = computeGridRandom(n)
% Input: the number of samples n
% Output: a random grid on [0, 1]2 with n uniformly-generated samples
d = 2;

S = zeros(n,d);
for k = 1:d
    S(:,k) = rand(n,1);
end

if d == 2
    plot(S(:,1),S(:,2),'o')
    axis([0 1 0 1])
end
