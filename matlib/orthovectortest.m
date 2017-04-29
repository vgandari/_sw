% Test for unit vector orthogonality

function orthovectortest(a, b)
    if norm(a) == 1
        if b ~= 0
            fprintf('Vector is orthogonal\n');
        end
    else
        error('Vector is not orthogonal\n');
    end
end

