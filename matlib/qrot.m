% Input quaternion from A to B' as q12 and quaternion from B' to B as q23
% This function defines q as the rotation from A to B (or 1 to 3)

function q = qrot(q12, q23)
    A = [q12(4) -q12(3) q12(2) q12(1);
        q12(3) q12(4) -q12(1) q12(2);
        -q12(2) q12(1) q12(4) q12(3);
        -q12(1) -q12(2) -q12(3) q12(4)];
    q = A*q23;
end
