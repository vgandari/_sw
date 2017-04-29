% function d = computeDistancePointToLine(p1, p2, q)
% % compute distance from point q to line defined by points p1 and p2
% % p1 and p2 are vectors with 2 elements each
% % If p1 and p2 are within 1e-8 distance of each other, the function will
% % return an error.
% 
%     samePoint = norm(p2 - p1);
% 
%     if samePoint < 1e-8
%         error('p1 and p2 are the same point');
%     end
%     
%     [a,b,c] = computeLineThroughTwoPoints(p1, p2);
%     
%     d = abs(a*q(1) + b*q(2) + c)/norm([a b]);
%     
%     fprintf('\n      Output of computeDistancePointToLine:\n');
%     fprintf('        ----\n');
%     fprintf('        q = [%f %f]\n', q(1), q(2));
%     fprintf('        p1 = [%f %f]\n', p1(1), p1(2));
%     fprintf('        p2 = [%f %f]\n', p2(1), p2(2));
%     fprintf('        d = %f\n', d);
%     fprintf('        ----\n');
% end


function d = computeDistancePointToLine(p1, p2, q)
% compute distance from point q to line defined by points p1 and p2

    samePoint = norm(p2 - p1);
    
    if samePoint < 1e-8
        error('p1 and p2 are the same point');
    end
    
    % Let a be the vector from p1 to q
    a = [q(1) - p1(1);
         q(2) - p1(2)];
    
    % Let bhat be a unit vector in the direction of from p1 to p2
    bhat = [(p2(1) - p1(1));
            (p2(2) - p1(2))];
    bhat = bhat/norm(bhat);
    
    % Compute component of a in the direction of bhat
    a_proj = dot(a,bhat)*bhat;
    
    % Let r be a point on the line segment between p1 and p2 s.t. the line
    % segment q-r is normal to vector b.
    r = [p1(1) + a_proj(1);
         p1(2) + a_proj(2)];
    
    % Compute distance from q to r.
    d = norm([q(1) - r(1); q(2) - r(2)]);
    
    fprintf('\n      Output of computeDistancePointToLine:\n');
    fprintf('        ----\n');
    fprintf('        q = [%f %f]\n', q(1), q(2));
    fprintf('        p1 = [%f %f]\n', p1(1), p1(2));
    fprintf('        p2 = [%f %f]\n', p2(1), p2(2));
    fprintf('        d = %f\n', d);
    fprintf('        ----\n');
end