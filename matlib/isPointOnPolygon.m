function B = isPointOnPolygon(P,q,tol)

[n,m] = size(P);
if m > n
    P = P';
end

if tol > 1e-6
    tol = 1e-6;
end

B = computeDistancePointToPolygon(P, q) < tol;