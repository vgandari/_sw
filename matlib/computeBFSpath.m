function [path] = computeBFSpath(AdjTable, start, goal)

parent = computeBFStree(AdjTable, start, goal);

% initialize path
path = [];
path = [path goal];

% store goal to add to path
u = goal;

% while parent of u is not SELF
while parent(u) ~= u
    % set u to parent
    u = parent(u);
    % add u to path
    path = [u path];
end