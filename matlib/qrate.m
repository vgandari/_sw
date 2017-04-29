% Derive rate of change in quaterion from quaternion and angular velocity vector.
% Make sure that both are in the same reference frame.

% q and omega must both be column vectors.

function qdot = qrate(q, omega)
    E = [q(4) -q(3) q(2) q(1);
        q(3) q(4) -q(1) q(2);
        -q(2) q(1) q(4) q(3);
        -q(1) -q(2) -q(3) q(4)];
    qdot = (1/2*[omega; 0]'*E')';
end
