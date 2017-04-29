% Test for orthognality of matrix

function orthomatrixtest(A, b)
    l = size(A);
    if rank(A) < min(l)
        error('Matrix is not full rank\n');
    else
        if b ~=0
            fprintf('Matrix is full rank\n');
        end
        
        for n = 1:l(1)
            test = norm(A(n, :));
            if test > 1 + eps || test < 1 - eps
                error('Matrix not orthogonal\n');
            end
%             if n > 1 && dot(A(n, :), A(n - 1, :)) ~= 0 TRYING TO INCLUDE DOT PRODUCT TEST
%                 error('Matrix not orthogonal\n');
%             end
        end
        
        for n = 1:l(2)
            test  = norm(A(:, n));
            if test > 1 + eps || test < 1 - eps
                error('Matrix not orthogonal\n');
            end
%             if n > 1 && dot(A(:, n), A(:, n - 1)) ~= 0 TRYING TO INCLUDE DOT PRODUCT TEST
%                 error('Matrix not orthogonal\n');
%             end
        end
        
        if b ~= 0
           fprintf('Matrix is orthogonal\n');
        end
    end
end