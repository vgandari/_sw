% Test for dextral rotation matrix

function dextraltest(A, b)
    if det(A) == 1
        if b ~= 0
            fprintf('Matrix is dextral\n');
        end
    elseif det(A) == -1
        error('Matrix is sinistral\n');
    elseif det(A) == 0
        error('Matrix is singular, noninvertible\n');
%     else
%         error('Matrix is not a rotation matrix\n');
    end
end

