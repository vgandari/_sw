function S = computeHaltonSequence(N,p)

S = zeros(N,1);
for i = 1:N
    iTemp = i;
    f = 1/p;
    while iTemp > 0
        q = floor(iTemp/p);
        r = mod(iTemp,p);
        S(i) = S(i) + f*r;
        iTemp = q;
        f = f/p;
    end
end

if max(S) >1
    error('not inside [0,1]');
end
