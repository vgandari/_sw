function [path] = extractPath(parent, start, goal)
path = [];
path = [path goal];
u = goal;
% while parent of u is not SELF
while parent(u) ~= u
    % set u to parent
    u = parent(u);
    % add u to path
    path = [u path];
end