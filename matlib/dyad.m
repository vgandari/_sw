% Inputs are two 3x3 vectors u and v
% Output is D = uv = dyad(u, v)


function D = dyad(u, v)
    D = [u(1)*v(1) u(1)*v(2) u(1)*v(3);
        u(2)*v(1) u(2)*v(2) u(2)*v(3);
        u(3)*v(1) u(3)*v(2) u(3)*v(3)];
end